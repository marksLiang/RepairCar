//
//  MyReleseViewModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/1.
//  Copyright © 2017年 HCY. All rights reserved.
//

import Foundation

class MyReleseViewModel {
    var ListData = [DemandModel]()
    func GetMyDemandInfoList(PageIndex:Int ,PageSize:Int ,UserID:Int , DemandType: Int ,result:((_ result:Bool?,_ NoMore:Bool?,_ Nodata:Bool?) -> Void)?){
        let parameters=["PageIndex":PageIndex,"PageSize":PageSize,"UserID":UserID,"DemandType":DemandType]
        CommonFunction.Global_Get(entity: DemandModel(), IsListData: true, url: HttpsUrl+"api/System/GetMyDemandInfoList", isHUD: false, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            if(resultModel?.Success==true){
                //没有数据
                if(resultModel?.ret==5){
                    result?(true,false,true)
                    return
                }
                let model =  resultModel?.Content   as!  [DemandModel]
                if(PageIndex>=2){
                    for item in model {
                        self.ListData.append(item)
                    }
                    //分页没有数据
                    if(resultModel?.ret==6){
                        result?(true,true,false)
                        return
                    }
                }else{
                    self.ListData = model
                    result?(true,false,false)
                }
            }else{
                result?(false,false,false)
            }
        }
    }
}
