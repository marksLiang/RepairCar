//
//  MapTool.m
//  众彩生活
//
//  Created by Apple on 2017/7/18.
//  Copyright © 2017年 zhongcaishenghuo. All rights reserved.
//

#import "MapTool.h"
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
@implementation MapTool
// 高德坐标转百度坐标
+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude, y = coor.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}
//地图坐标转火星坐标
+ (CLLocation *)transformToMars:(CLLocation *)location {
    //是否在中国大陆之外
    if ([[self class] outOfChina:location]) {
        return location;
    }
    double dLat = [[self class] transformLatWithX:location.coordinate.longitude - 105.0 y:location.coordinate.latitude - 35.0];
    double dLon = [[self class] transformLonWithX:location.coordinate.longitude - 105.0 y:location.coordinate.latitude - 35.0];
    double radLat = location.coordinate.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    return [[CLLocation alloc] initWithLatitude:location.coordinate.latitude + dLat longitude:location.coordinate.longitude + dLon];
}

+ (BOOL)outOfChina:(CLLocation *)location {
    if (location.coordinate.longitude < 72.004 || location.coordinate.longitude > 137.8347) {
        return YES;
    }
    if (location.coordinate.latitude < 0.8293 || location.coordinate.latitude > 55.8271) {
        return YES;
    }
    return NO;
}
//火星坐标转地图坐标

+ (CLLocationCoordinate2D)MarsGS2WorldGS:(CLLocationCoordinate2D)coordinate
{
    double gLat = coordinate.latitude;
    double gLon = coordinate.longitude;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:gLat longitude:gLon];
    location = [self transformToMars:location];
    
    CLLocationCoordinate2D marsCoor = [location coordinate];
    double dLat = marsCoor.latitude - gLat;
    double dLon = marsCoor.longitude - gLon;
    return CLLocationCoordinate2DMake(gLat - dLat, gLon - dLon);
}
+ (double)transformLatWithX:(double)x y:(double)y {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double)transformLonWithX:(double)x y:(double)y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}
//火星坐标转百度
+(CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p
{
    long double z = sqrt(p.longitude * p.longitude + p.latitude * p.latitude) + 0.00002 * sin(p.latitude * M_PI);
    long double theta = atan2(p.latitude, p.longitude) + 0.000003 * cos(p.longitude * M_PI);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude = (z * sin(theta) + 0.006);
    geoPoint.longitude = (z * cos(theta) + 0.0065);
    return geoPoint;
}
//百度转火星
+(CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p
{
    double x = p.longitude - 0.0065, y = p.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude  = z * sin(theta);
    geoPoint.longitude = z * cos(theta);
    return geoPoint;
}
@end
