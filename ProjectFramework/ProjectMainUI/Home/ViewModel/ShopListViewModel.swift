//
//  ShopListViewModel.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/21.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopListViewModel: NSObject {
    var ListData = [RepairShopModel]()
    func GetMaintenanceInfo(PageIndex:Int,PageSize:Int,CityName:String,SearchName:String,MaintenanceTypeName:String,StarRating:Int,Longitude:String,Latitude:String,Distance:Int,result:((_ result:Bool?,_ NoMore:Bool?,_ Nodata:Bool?) -> Void)?){
        
        let parameters=["PageIndex":PageIndex,"PageSize":PageSize,"CityName":CityName,"SearchName":SearchName,"MaintenanceTypeName":MaintenanceTypeName,"StarRating":StarRating,"Longitude":Longitude,"Latitude":Latitude,"Distance":Distance] as [String : Any]
        CommonFunction.Global_Get(entity: RepairShopModel(), IsListData: true, url: HttpsUrl+"api/Maintenance/GetMaintenanceInfo", isHUD: false, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            //debugPrint(parameters,resultModel?.Content)
            if resultModel?.Success == true {
                //没有数据
                if resultModel?.ret == 5 {
                    result?(true,false,true)
                }
                //没有更多数据
                if(resultModel?.ret==6){
                    result?(true,true,false)
                    return
                }
                if resultModel?.Content != nil {
                    //有数据PageIndex>=2
                    let model =  resultModel?.Content   as!  [RepairShopModel]
                    if(PageIndex>=2){
                        for item in model {
                            self.ListData.append(item)
                        }
                    }else{
                        self.ListData = model
                    }
                    result?(true,false,false)
                    return
                }
                result?(true,false,true)
            }else{
                result?(false,false,false)
            }
        }
    }
}

class SfitViewModel: NSObject {
    var ListData = SfitParmterModel()
    //获取公共的搜索参数
    func GetScreeningCondition(result:((_ result:Bool?) -> Void)?){

        CommonFunction.Global_Get(entity: SfitParmterModel(), IsListData: false, url: HttpsUrl+"api/Maintenance/GetScreeningCondition", isHUD: false, isHUDMake: false, parameters: nil) { (resultModel) in
            if(resultModel?.Success==true){
                self.ListData = resultModel?.Content   as!  SfitParmterModel
                result?(true)
            }else{
                result?(false)
            }
        }
    }
}
