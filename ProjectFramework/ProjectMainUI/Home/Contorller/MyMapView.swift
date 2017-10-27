//
//  MyMapView.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/20.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import MapKit


class MyMapView: UIViewController {
    typealias CallbackValue=( _ loaction:CLLocation , _ adress:String)->Void //类似于OC中的typedef
    var myCallbackValue:CallbackValue?  //声明一个闭包 类似OC的Block属性
    func  FuncCallbackValue(value:CallbackValue?){
        myCallbackValue = value //返回值
    }
    fileprivate var _locationManager: CLLocationManager?=nil
    var currenLocation:CLLocation!=nil
    fileprivate lazy var _mapView: MKMapView = {
        let _mapView = MKMapView.init(frame: self.view.bounds)
        _mapView.showsUserLocation = true
        _mapView.userTrackingMode = .follow
        _mapView.mapType = .standard
        _mapView.delegate = self
        return _mapView
    }()
    fileprivate lazy var adressLable: UILabel = {
        let adressLable = UILabel.init(frame: CGRect.init(x: 20, y: 52, width: self.view.frame.width-20, height: 48))
        adressLable.backgroundColor = UIColor().TransferStringToColor("#F9F9F9")
        adressLable.text = "正在获取地理位置....";
        adressLable.numberOfLines = 2
        adressLable.font = UIFont.systemFont(ofSize: 14)
        return adressLable
    }()
    fileprivate lazy var sureButton: UIButton = {
       let sureButton = UIButton.init(type: .system)
        sureButton.frame = CGRect.init(x: CommonFunction.kScreenWidth - 100, y: 10, width: 80, height: 35)
        sureButton.layer.cornerRadius = 5
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(UIColor.white, for: .normal)
        sureButton.backgroundColor = CommonFunction.SystemColor()
        sureButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return sureButton
    }()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "选择地址"
        self.view.backgroundColor = UIColor.white
        self.inspectionService()
        self.initMapView()
    }
    func buttonClick() -> Void {
        if myCallbackValue != nil {
            myCallbackValue!(self.currenLocation,self.adressLable.text!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    //MARK: initMapView
    private func initMapView()->Void{
        self.view.addSubview(_mapView)
        let bottomView = UIView.init(frame: CGRect.init(x: 0, y: CommonFunction.kScreenHeight - 100, width: self.view.frame.width, height: 100))
        bottomView.backgroundColor = UIColor().TransferStringToColor("#F5F5F5")
        let lable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 50))
        lable.backgroundColor = UIColor().TransferStringToColor("#F9F9F9")
        lable.text = "    我的位置"
        let image = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 28, height: 30))
        image.center = _mapView.center
        image.image = UIImage.init(named: "MapLoc定位")
        self.view.addSubview(bottomView)
        bottomView.addSubview(lable)
        bottomView.addSubview(adressLable)
        bottomView.addSubview(sureButton)
        self._mapView.addSubview(image)
    }
    //MARK: 开启定位服务
    private func inspectionService()->Void{
        // *  城市经纬度：
        // *  成都：纬度（latitude）：30.5743289508  经度（longitude）：104.0646699946
        // 自定义模拟器经纬度步骤：
        // 选中模拟器 -> Debug -> Location -> Custom Location....
        // 1、异常处理：判断设备是否支持定位；
        if !CLLocationManager.locationServicesEnabled() {
            CommonFunction.HUD("定位服务暂未开启", type: .error)
            return
        }
        // 2、请求用户授权（iOS8以后，弹框提示用户是否允许使用定位）
        // a、请求在使用期间授权，需添加NSLocationWhenInUseUsageDescription字段到info.plist文件中
        //设置定位精度
        self._locationManager = CLLocationManager()
        self._locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        //设置定位频率
        self._locationManager?.distanceFilter = 5.0
        self._locationManager?.delegate = self
        self._locationManager?.startUpdatingLocation()
        if (self._locationManager?.responds(to: #selector(self._locationManager?.requestWhenInUseAuthorization)))! {
            self._locationManager?.requestWhenInUseAuthorization()
        }
    }
}

extension MyMapView: CLLocationManagerDelegate,MKMapViewDelegate  {
    //定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self._locationManager?.stopUpdatingLocation()
        let loc = MapTool.transform(toMars: locations.first)
        self.currenLocation = loc
        let center = CLLocationCoordinate2D(latitude: (loc?.coordinate.latitude)!, longitude:  (loc?.coordinate.longitude)!)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion.init(center: center, span: span)
        self._mapView.region = region
        let geocoder = CLGeocoder.init()
        //定位失败
        geocoder.reverseGeocodeLocation(locations.last!) { (placemarks, error) in
            if placemarks?.count == 0 || (error != nil) {
                CommonFunction.HUD("获取定位失败", type: .error)
                return
            }
            //显示位置
            let pm = placemarks?.first!
            let array = pm!.addressDictionary!["FormattedAddressLines"] as! Array<Any>
            let text = array.first as! String
            self.adressLable.text = text
        }
    }
    //地图加载失败
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        CommonFunction.AlertController(self, title: "地图加载失败", message: "", ok_name: "确定", cancel_name: "取消", OK_Callback: {

        }) {

        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.adressLable.text = "正在获取地理位置....";
        let coordinate = mapView.region.center
        var region = MKCoordinateRegion.init()
        let location = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.currenLocation = location
        region.center = coordinate
        let geocoder = CLGeocoder.init()
        //定位失败
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if placemarks?.count == 0 || (error != nil) {
                CommonFunction.HUD("编码失败", type: .error)
                return
            }
            //显示位置
            let pm = placemarks?.first!
            let array = pm!.addressDictionary!["FormattedAddressLines"] as! Array<Any>
            let text = array.first as! String
            self.adressLable.text = text
        }
    }
}

