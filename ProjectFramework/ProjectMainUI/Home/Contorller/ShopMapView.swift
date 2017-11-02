//
//  ShopMapView.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/25.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopMapView: UIViewController {
    
    fileprivate var _locationManager: CLLocationManager?=nil
    fileprivate var endLocation:CLLocationCoordinate2D!=nil
    //var model:RepairShopModel?=nil
    var Lat = 0.00000000000000
    var lng = 0.00000000000000
    var annotationTitle = ""
    fileprivate lazy var _mapView: MKMapView = {
        let _mapView = MKMapView.init(frame: self.view.bounds)
        _mapView.showsUserLocation = true
        _mapView.userTrackingMode = .follow
        _mapView.mapType = .standard
        _mapView.delegate = self
        return _mapView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "店铺地址"
        self.view.backgroundColor = UIColor.white
        self.inspectionService()
        self.view.addSubview(_mapView)
        self.initMapView()
    }
    private func initMapView()->Void{
        //添加大头针
        let span = MKCoordinateSpan.init(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let lat = CLLocationDegrees(Lat)
        let Lng = CLLocationDegrees(lng)
        //百度坐标转火星坐标
        let center = MapTool.transformFromBaidu(toGCJ: CLLocationCoordinate2D.init(latitude: lat, longitude: Lng))
        self.endLocation = center
        //center = MapTool.marsGS2WorldGS(center)
        let region = MKCoordinateRegion.init(center: center, span: span)
        let annotation = MKPointAnnotation.init()
        annotation.coordinate = center
        annotation.title = annotationTitle
        self._mapView.addAnnotation(annotation)
        //延时一秒选中动画
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            self._mapView.selectAnnotation(annotation, animated: true)
            self._mapView.setRegion(region, animated: true)
        })
    }
    private func inspectionService()->Void{
        if !CLLocationManager.locationServicesEnabled() {
            CommonFunction.HUD("定位服务暂未开启", type: .error)
            return
        }
        // 2、请求用户授权（iOS8以后，弹框提示用户是否允许使用定位）
        // a、请求在使用期间授权，需添加NSLocationWhenInUseUsageDescription字段到info.plist文件中
        //设置定位精度
        self._locationManager = CLLocationManager()
        self._locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        //设置定位频率
        self._locationManager?.distanceFilter = 1000.0
        self._locationManager?.delegate = self
        //self._locationManager?.startUpdatingLocation()
        if (self._locationManager?.responds(to: #selector(self._locationManager?.requestWhenInUseAuthorization)))! {
            self._locationManager?.requestWhenInUseAuthorization()
        }
    }
}
extension ShopMapView: CLLocationManagerDelegate,MKMapViewDelegate  {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        //异常处理
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }else{
            if annotation.isKind(of: MKPointAnnotation.self){
//                debugPrint("我执行到这里了")
                let identifier = "123"
                let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                var mpinView:MKPinAnnotationView!=nil
                if pinView == nil {
                    mpinView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
                }
                mpinView.annotation = annotation
                mpinView.animatesDrop = true
                mpinView.canShowCallout = true
                pinView?.image = UIImage.init(named: "weixiu")
//                if #available(iOS 9.0, *) {
//                    pinView.pinTintColor = CommonFunction.SystemColor()
//                }
                let button = UIButton.init(type: .system)
                button.bounds = CGRect.init(x: 0, y: 0, width: 80, height: 35)
                button.layer.cornerRadius = 5
                button.backgroundColor = CommonFunction.SystemColor()
                button.setTitle("导航", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(ShopMapView.buttonclick), for: .touchUpInside)
                mpinView.rightCalloutAccessoryView = button
                return mpinView
            }
            return nil
        }
        
    }
    func buttonclick() -> Void {
        CommonFunction.AlertController(self, title: "是否跳转至苹果地图开启导航？", message: "", ok_name: "确定", cancel_name: "取消", OK_Callback: {
            let currenItem = MKMapItem.forCurrentLocation()
            let locItem = MKMapItem.init(placemark: MKPlacemark.init(coordinate: self.endLocation, addressDictionary: nil))
            _ = MKMapItem.openMaps(with: [currenItem,locItem], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: Int(true)])
        }) {
            
        }
    }
}
