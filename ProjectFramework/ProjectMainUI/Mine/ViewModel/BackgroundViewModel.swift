//
//  BackgroundViewModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/6.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class BackgroundViewModel: NSObject {
    var ListData = [MaintenanceModel]()
    //MARK: 获取是否省级
    func GetAuthorizationCityIsisProvince(city:String ,result:((_ result:Bool?) -> Void)?) {
        CommonFunction.Global_Get(entity: nil, IsListData: false, url: HttpsUrl+"api/City/GetAuthorizationCityIsisProvince", isHUD: true, isHUDMake: false, parameters: ["CityName":city] as NSDictionary) { (resultModel) in
            
            if resultModel?.Success == true && resultModel?.Content != nil {
                let bool = resultModel?.Content as! Bool
                result?(bool)
            }else{
                result?(false)
            }
        }
    }
    //MARK: 获取后台管理数据
    func GetAdminHome(CityName:String ,UserID:Int ,isProvinceSelece:Bool,result:((_ result:Bool?) -> Void)?) {
        let parameters=["CityName":CityName,"UserID":UserID,"isProvinceSelece":isProvinceSelece] as [String : Any]
        CommonFunction.Global_Get(entity: MaintenanceModel(), IsListData: true, url: HttpsUrl+"api/AdminHome/GetAdminHome", isHUD: false, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            if resultModel?.Success == true {
                if resultModel?.Content != nil {
                    self.ListData = resultModel?.Content as! [MaintenanceModel]
                    result?(true)
                    return
                }
                result?(true)
            }else{
                result?(false)
            }
        }
    }
}
