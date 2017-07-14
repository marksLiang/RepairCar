//
//  AppDelegate.swift
//  ProjectFramework
//
//  Created by hcy on 16/4/4.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import FMDB
import IQKeyboardManager
import SwiftTheme

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate,BMKGeneralDelegate {
    var window: UIWindow?
     
    var IsPushuProduction=false     //是否是发布产品  （用于极光推送)
 
    var conn:Reachability?  //苹果提供的网络检测类
    var locService: BMKLocationService?
    var _mapManager:BMKMapManager?
    // MARK: - 初始化
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        InitUI()    //初始化UI   (第一次启动的导航页，需要在里面设置)
        Init_Navigationbar_TabbarStyle()    //导航样式设置
        InitBaidu()           //百度地图 
        InitUMshare()         //友盟分享
        InitNetworkCheck()    //网络检测
        InitDB()              //初始化sqlite数据库
        InitJpush(didFinishLaunchingWithOptions:launchOptions)  //极光推送
        return true
    }
    // MARK: - 析构方法
    //析构方法
    deinit{
        self.conn?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    func Init_Navigationbar_TabbarStyle(){
     
        // navigation bar
        
        let navigationBar = UINavigationBar.appearance()
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        let titleAttributes: [[String: AnyObject]] = ["#FFF"].map { hexString in
            return [
                NSForegroundColorAttributeName: UIColor(rgba: hexString),
                NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                NSShadowAttributeName: shadow
            ]
        }
        
        navigationBar.theme_tintColor = ThemeColorPicker.pickerWithColors(["#FFF"])
        navigationBar.theme_barTintColor = [CommonFunction.SystemColor()]
        navigationBar.theme_titleTextAttributes = ThemeDictionaryPicker.pickerWithDicts(titleAttributes)
        
        // tab bar
        
        let tabBar = UITabBar.appearance()
        tabBar.theme_tintColor = [CommonFunction.SystemColor()]  //字体颜色
//        tabBar.theme_barTintColor = globalBarTintColorPicker  //颜色
    }
    
    // MARK: - 初始化UI
    func InitUI(){
        //状态栏的颜色 Default 表示黑色的 LightContent 白色
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true);
        self.window=UIWindow()
        self.window!.backgroundColor=UIColor.white   //设置windows是白色的 不然自定义push的时候右上角会有黑角快
        self.window!.frame=UIScreen.main.bounds
        IQKeyboardManager.shared().isEnabled = true
        //判断是否第一次启动：
        if((UserDefaults.standard.bool(forKey: "IsFirstLaunch") as Bool!) == false || (UserDefaults.standard.bool(forKey: "IsFirstLaunch") as Bool!)==nil ){
            //第一次启动，播放引导页面
            let vc = ScrollViewPageViewController(Enabletimer: false,   //是否启动滚动
                timerInterval: 3,     //如果启用滚动，滚动秒数
                ImageList:StartOneImageList  ,//图片
                frame: CGRect(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight),Callback_SelectedValue: { (value,isLast) -> Void in
                    if(isLast==true){   //最后一张图 点击进入
                        let mainvc = MainTabBarController()
                        mainvc.StartPageImage.image=UIImage(named: StartOneImageList[value])
                        self.window!.rootViewController = mainvc
                        //设置为非第一次启动
                        UserDefaults.standard.set(true, forKey: "IsFirstLaunch")
                    }
                } , isJumpBtn: true, Callback_JumpValue: { (selectedImage)->Void in
                    //点击跳转 isJumpBtn是否显示跳转按钮
                    let mainvc = MainTabBarController()
                    mainvc.StartPageImage.image=selectedImage
                    self.window!.rootViewController = mainvc
                    //设置为非第一次启动
                    UserDefaults.standard.set(true, forKey: "IsFirstLaunch")
            })
            self.window!.rootViewController =  vc
            
        }
        else{
            //不是第一次进入，进入主页面
            self.window!.rootViewController =  MainTabBarController()
        }
        
        self.window!.makeKeyAndVisible()
    }
    
    
    // MARK: - 初始化百度地图
    func InitBaidu(){
        
        _mapManager = BMKMapManager() // 初始化 BMKMapManager
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start(BaiduMapKey, generalDelegate: self)
        if  ret == false {
            print("失败")
        }
        else{
            
            //初始化BMKLocationService
            locService = BMKLocationService()
            locService?.delegate = self
            //启动LocationService
            locService?.startUserLocationService()
            // 设置定位精确度，默认：kCLLocationAccuracyBest
            locService?.desiredAccuracy=kCLLocationAccuracyBest
            //指定最小距离更新(米)，默认：kCLDistanceFilterNone
            locService?.distanceFilter=0.1
        }
        
        
    }
    
    //实现相关delegate 处理位置信息更新
    //处理方向变更信息
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        if(userLocation.location != nil){
            //print("更新了地理位置")
            //纬度,经度
        }
    }
    
//    //处理位置坐标更新  /********************  此代理方法在OC调用有效 在swift则不执行 ********************/
//    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
//        print("处理位置坐标更新---",userLocation)
//    }
    func didUpdate(_ userLocation: BMKUserLocation!) {
        //debugPrint("处理位置坐标更新---",userLocation)
        Global_latitude=userLocation.location.coordinate.latitude
        Global_longitude=userLocation.location.coordinate.longitude
    }
    // MARK: - 友盟分享
    func InitUMshare(){
        
        //打开调试log的开关
        #if DEBUG
            UMSocialData.openLog(true)
        #else
            UMSocialData.openLog(false)
        #endif
        
        //设置友盟社会化组件appkey
        UMSocialData.setAppKey(UMAPPKey)
        //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
        UMSocialConfig.setSupportedInterfaceOrientations(.all)
        
        
        //设置微信AppId，设置分享url，默认使用友盟的网址
        UMSocialWechatHandler.setWXAppId(WeiXinShareParameter[0], appSecret: WeiXinShareParameter[1], url: WeiXinShareParameter[2])
        
        // 打开新浪微博的SSO开关
        // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
        UMSocialSinaSSOHandler.openNewSinaSSO(withAppKey: XinLangShareParameter[0], secret: XinLangShareParameter[1], redirectURL: XinLangShareParameter[2])
        
        //设置分享到QQ空间的应用Id，和分享url 链接
        UMSocialQQHandler.setQQWithAppId(QQShareParameter[0], appKey:QQShareParameter[1], url: QQShareParameter[2])
        
    }
    
    //分享成功入口(需要设置 否则 didFinishGetUMSocialDataInViewController 无法进入该函数)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return UMSocialSnsService.handleOpen(url)
    }
    
    // MARK: - 推送
    ///极光推送
    func InitJpush( didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        } else if #available(iOS 8.0, *) {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        
        #if DEBUG
           IsPushuProduction=false
        #else
         IsPushuProduction=true
        #endif
        
        JPUSHService.setup(withOption: launchOptions,
                           appKey: JpushKey,
                           channel: "app store",
                           apsForProduction: IsPushuProduction)
     
    }
    
    
    
    // MARK: - 网络检测
    //网络检测
    func InitNetworkCheck(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckNetwork), name: NSNotification.Name.reachabilityChanged, object: nil)
        self.conn=Reachability.forInternetConnection()
        self.conn?.startNotifier()
        let status =    self.conn!.currentReachabilityStatus() as NetworkStatus
        
        switch status {
        case NotReachable:  //网络未连接
            CommonFunction.MessageNotification("网络未连接", interval: 3, msgtype: .error)
            break
        default:
            NetWordStatus=true
            break
        }
    }
    
    func CheckNetwork (){
        CheckNetworkStatus()
    }
    //检测网络连接状态
    func CheckNetworkStatus(){
        switch self.conn!.currentReachabilityStatus() {
        case NotReachable:  //未连接
            CommonFunction.MessageNotification("网络未连接", interval: 3, msgtype: .error)
            NetWordStatus=false
            break
        case ReachableViaWiFi:  //wifi
            CommonFunction.MessageNotification("当前使用WIFI", interval: 2, msgtype: .none)
            NetWordStatus=true
            break
        case ReachableViaWWAN:  //移动网络 2g 3g 4g
            CommonFunction.MessageNotification("当前使用移动网络2g3g4g", interval: 2, msgtype: .none)
            NetWordStatus=true
            break
        default:
            break
        }
        
    }
    
    // MARK: - 创建数据库
    func InitDB(){
        CreatedbBase().CreateDB()   //创建已封装好的数据库
    }
    
     // MARK: -  极光
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
       // if Global_UserInfo.MemberID != "" { //添加别名
         //   JPUSHService.setAlias(Global_UserInfo.MemberID, callbackSelector: nil, object: self )
        //}
    } 
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
           JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    
    
    // MARK:
    ///当有电话进来或者锁屏时，应用程序便会挂起。
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    ///应用程序进入后台时执行
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    ///应用程序将要重新回到前台时执行
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        application.applicationIconBadgeNumber=0
    }
    ///应用程序重新进入活动状态时执行
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool{
        if(url.scheme==ZFBAppScheme){
          return  safepay(url: url as URL)
        }
        
        return true
    }
    
    
    
    // NOTE: 9.0以后使用新API接口
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
       
        if(url.scheme==ZFBAppScheme){
          return safepay(url: url)
        }
        
        return true
    }
    
    //支付宝处理结果
    func safepay (url: URL) ->Bool{
        
        if url.scheme==ZFBAppScheme {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                debugPrint("reslut = \(String(describing: resultDic))")
                if let Alipayjson = resultDic as NSDictionary?{
                    let resultStatus = Alipayjson.value(forKey: "resultStatus") as! String
                    //利用KVO通知支付页面已经完成
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ZFBPayNoticeResultStatus), object: nil, userInfo: ["resultStatus": resultStatus])
                }
            })
            // 授权跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic) in
                debugPrint(resultDic as Any)
                // 解析 auth code
                let  result:NSString =  resultDic?["result"] as! NSString
                var authCode  = ""
                if(result.length>0){
                    let resultArr = result.components(separatedBy: "&")
                    for suresult in resultArr {
                        if(suresult.characters.count > 10 && suresult.hasPrefix("auth_code=")){
                            let index = suresult.index(suresult.endIndex, offsetBy: 10)
                            authCode=suresult.substring(from: index)
                            break
                        }
                    }
                }
                debugPrint("授权结果:"+(authCode ))
                
            })
            
        }
         return true
    }
}


extension AppDelegate : JPUSHRegisterDelegate{
    @objc(jpushNotificationCenter:willPresentNotification:withCompletionHandler:) @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        JPUSHService.setBadge(0)
        UIApplication.shared.applicationIconBadgeNumber=0
        debugPrint(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @objc(jpushNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:) @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
          JPUSHService.setBadge(0)
    UIApplication.shared.applicationIconBadgeNumber=0
        debugPrint(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
}
