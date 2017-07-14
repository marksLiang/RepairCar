//
//  GlobalParameter.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/10/18.
//  Copyright © 2016年 HCY. All rights reserved.
//

import Foundation
import SwiftTheme


///用户信息(个人信息)数据模型
class MyInfoModel:NSObject  {
    ///是否已登录
    var IsLogin=false
    ///用户ID
    var userid=0
    ///图片
    var HeadImgPath=""
    ///名称(姓名
    var  RealName=""
    ///性别
    var  Sex=""
    ///手机
    var  PhoneNo=""
    ///token
    var  Token=""
    ///0 未授权 1数据挖掘
    var authorizationtype=0
    
}



//支付宝AppScheme
let ZFBAppScheme = "alisdknmsclv"  //应用注册scheme,在Info.plist定义URL types  (特注说明：如果一个app下存在多个相同公司产品 那么他的 Scheme不能一样 否则调整支付宝后无法跳转回来该应用)
let ZFBPayNoticeResultStatus="PayResultStatus"      //支付宝通知的Name

let placeholderImage="loadimg"  //SDWebImage 默认加载图片

let UMAPPKey="58ad571299f0c768cc000f0d"      //友盟Appkey
let BaiduMapKey="bkKIE4v1nTBGCRYZ4Zpg34LrynTExfXk" //百度地图key
let BaiduTTAppID="9311410"                         //百度地图开启语音功能需要用appid
let JpushKey="d2bea33f0be75f93ed0fd1c8"            //激光推送Key

#if DEBUG
let HttpsUrl="http://192.168.1.20:5499/";
let HttpsUrlImage="http://192.168.1.20:5488/";
let HttpsPanorama360="http://www.8gsky.com/360/?id=";
let HttpsVR="http://m.8gsky.com/vision/videoplay.aspx?app=1&id=";
#else
let HttpsUrl="http://api.8gsky.com/";
let HttpsUrlImage="http://images.8gsky.com/";
let HttpsPanorama360="http://www.8gsky.com/360/?id=";
let HttpsVR="http://m.8gsky.com/vision/videoplay.aspx?app=1&id=";

#endif

/* 设置使用最新新浪微博SDK来处理SSO授权(通过客户端设置appkey进行访问)
 并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
@param appKey 新浪App Key 参数1
@param appSecret 新浪App Secret 参数2
@param redirectURL 回调URL 参数3  */
let XinLangShareParameter:[String] = ["","",""]  //新浪微博分享参数

/*设置微信AppId和url地址
@param app_Id 微信应用Id 参数1
@param app_Secret 微信应用secret 参数2
@param url 微信消息分享网页类型的url地址 参数3 */
let WeiXinShareParameter:[String] = ["","",""]  //微信分享参数

/* 设置分享到手机QQ和QQ空间的应用ID
@param appId QQ互联应用Id
@param appKey QQ互联应用Key
@param url 分享URL链接 */
let QQShareParameter:[String] = ["","",""]  //QQ分享参数

var NetWordStatus=false //网络状态  true连接网络，false未连接 
var Global_latitude:CLLocationDegrees=0    //全局纬度
var Global_longitude:CLLocationDegrees=0   //全局经度
var Global_UserInfo=MyInfoModel()          //我的信息全局

let StartOneImageList:[String] = ["index1","index2","index4"]       //第一次启动引导页图片

/// TabBarController 全局参数变量
let TabBar_Title = ["首页","频道","游记","我的"]      //标题
let TabBar_StoryName = ["HoneMain","ClassifCation","Travel","My"]  //sb名称（UI)
let TabBar_SelectedImage = ["Home_Click","ClassifCation_Click","Travel_Click","My_Click"]        //选择的图片
let TabBar_NoSelectedImage = ["Home_Default","ClassifCation_Default","Travel_Default","My_Default"]      //未选择图片








