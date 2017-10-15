//
//  ProcjectHeader.h
//  ProjectFramework
//
//  Created by hcy on 16/4/4.
//  Copyright © 2016年 HCY. All rights reserved.
//


//系统  ↓
#import <StoreKit/StoreKit.h>       //打开第三方应用
#import <AssetsLibrary/AssetsLibrary.h> //系统图片
#import <MobileCoreServices/MobileCoreServices.h>//系统图片
#import <CoreMotion/CoreMotion.h>    


// Facebook开源的动画框架-Pop。
#import <pop/POP.h>

//支付宝
#import <AlipaySDK/AlipaySDK.h> 
#import "Order.h"
//百度API ↓
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件


//极光推送API ↓
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h> 
#endif

//其他第三方 ↓ 
#import "MBProgressHUD.h"       //HUD
#import "MBProgressHUD+NJ.h"    //HUD 
#import "Reachability.h"        //判断网络  
#import <SDWebImage/UIImageView+WebCache.h>     //缓存图片
#import <MJRefresh/MJRefresh.h>                //上啦下拉刷新第三方
#import <MJExtension/MJExtension.h>                 
#import <CYLTabBarController/CYLTabBarController.h> //第三方 TabBarcontroller
#import <CWStatusBarNotification/CWStatusBarNotification.h> //系统通知Notification 
#import <FMDB/FMDB.h> //数据库SQLliite
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h> //Tableview CollectionView 空视图
 
#import "MHActionSheet.h"
#import "TZImagePickerController.h" //图片选择
#import "PYSearchViewController.h" //搜索UI 
#import "XHStarRateView.h"         //评分星星
#import "PanoramaViewController.h"      // 全景图
#import "HcdPopMenu.h"              //动画菜单
#import "JLPhotoBrowser.h"          //图片浏览
#import "ZFChooseTimeViewController.h"//酒店时间选择
#import "SDCycleScrollView.h"       //轮播图
#import "TagsFrame.h"               //标签
#import "CityData.h"

