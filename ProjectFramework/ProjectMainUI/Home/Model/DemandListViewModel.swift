//
//  DemandListViewModel.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/22.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemandListViewModel: NSObject {
    var ListData = [DemandListModel]()
    func GetDemandInfoList (PageIndex:Int,PageSize:Int,CityName:String,result:((_ result:Bool?,_ NoMore:Bool?,_ Nodata:Bool?) -> Void)?){
        let parameters=["PageIndex":PageIndex,"PageSize":PageSize,"CityName":CityName] as [String : Any]
        CommonFunction.Global_Get(entity: DemandListModel(), IsListData: true, url: HttpsUrl+"api/System/GetDemandInfoList", isHUD: false, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            if(resultModel?.Success==true){
                //没有数据
                if(resultModel?.ret==5){
                    result?(true,false,true)
                    return
                }
                //分页没有数据
                if(resultModel?.ret==6){
                    result?(true,true,false)
                    return
                }
                let model =  resultModel?.Content   as!  [DemandListModel]
                if(PageIndex>=2){
                    for item in model {
                        self.ListData.append(item)
                    }
                }else{
                    self.ListData = model
                }
                result?(true,false,false)
            }else{
                result?(false,false,false)
            }
        }
    }
}
