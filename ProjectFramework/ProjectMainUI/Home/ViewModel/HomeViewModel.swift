//
//  HomeViewModel.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/17.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    var ListData = [RepairShopModel]()
    func GetHomeMaintenanceInfo(CityName:String , Longitude:String , Latitude:String ,result:((_ result:Bool?) -> Void)?) -> Void {
        
        let parameters=["CityName":CityName,"Longitude":Longitude,"Latitude":Latitude]
        CommonFunction.Global_Get(entity: RepairShopModel(), IsListData: true, url: HttpsUrl + "api/Maintenance/GetHomeMaintenanceInfo", isHUD: false, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            if(resultModel?.Success==true){
               self.ListData = resultModel?.Content as! [RepairShopModel]
                result?(true)
            }else{
                result?(false)
            }
        }
    }
    func GetMaintenanceDetailsIsPay(MaintenanceID:Int , UserID:Int,result:((_ result:Bool?) -> Void)?) -> Void {
        let parameters=["MaintenanceID":MaintenanceID,"UserID":UserID]
        CommonFunction.Global_Get(entity: nil, IsListData: false, url: HttpsUrl + "api/Maintenance/GetMaintenanceDetailsIsPay", isHUD: true, isHUDMake: true, parameters: parameters as NSDictionary) { (resultModel) in
            if(resultModel?.Success==true){
                if resultModel?.ret == 0 {
                    let bool = resultModel?.Content as! Bool
                    result?(bool)
                }else{
                    result?(true)
                }
            }
        }
    }
}

class AdvertisingViewModel: NSObject {
    var ListData = [AdvertisingModel]()
    func GetAdvList(CityName:String , AdvType:Int , result:((_ result:Bool?) -> Void)?) -> Void {
        let parameters=["CityName":CityName,"AdvType":AdvType] as [String : Any]
        CommonFunction.Global_Get(entity:AdvertisingModel(), IsListData: true, url: HttpsUrl+"api/System/GetAdvList", isHUD: false, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            if(resultModel?.Success==true){
                self.ListData = resultModel?.Content as! [AdvertisingModel]
                result?(true)
            }else{
                result?(false)
            }
        }
    }
}
