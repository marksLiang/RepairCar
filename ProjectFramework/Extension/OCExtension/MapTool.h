//
//  MapTool.h
//  众彩生活
//
//  Created by Apple on 2017/7/18.
//  Copyright © 2017年 zhongcaishenghuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapTool : NSObject
//从高德转化到百度坐标
+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor;
//火星坐标转换成地图坐标
+ (CLLocationCoordinate2D)MarsGS2WorldGS:(CLLocationCoordinate2D)coordinate;


//地图坐标转换成火星坐标
+ (CLLocation *)transformToMars:(CLLocation *)location;

/**
 *  将GCJ-02(火星坐标)转为百度坐标:
 */
+(CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p;
/**
 *  将百度坐标转为GCJ-02(火星坐标):
 */
+(CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p;
@end
