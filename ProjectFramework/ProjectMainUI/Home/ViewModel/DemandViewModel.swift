//
//  DemandViewModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/31.
//  Copyright © 2017年 HCY. All rights reserved.
//

import Foundation

class DemandViewModel {
    var model = DemandModel()
    func GetDemandInfoInfoSingle(DemandID:Int,result:((_ result:Bool?) -> Void)?) {
        let parameters=["DemandID":DemandID]
        CommonFunction.Global_Get(entity: DemandModel(), IsListData: false, url: HttpsUrl+"api/System/GetDemandInfoInfoSingle", isHUD: false, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            if resultModel?.Success == true && resultModel?.ret == 0{
                if resultModel?.Content != nil {
                    self.model =  resultModel?.Content   as!  DemandModel
                    result?(true)
                }
            }else{
                result?(false)
            }
        }
    }
    func SetDemandStatus(DemandID:Int , result:((_ result:Bool?) -> Void)?) {
        let parameters=["DemandID":DemandID]
        CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl+"api/System/SetDemandStatus", isHUD: true, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            if resultModel?.Success == true && resultModel?.ret == 0{
                if resultModel?.Content != nil {
                    result?(true)
                    return
                }
                result?(false)
            }else{
                result?(false)
            }
        }
    }
}
