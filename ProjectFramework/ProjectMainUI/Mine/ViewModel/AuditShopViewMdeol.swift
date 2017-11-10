//
//  AuditShopViewMdeol.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/11/8.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class AuditShopViewMdeol: NSObject {
    //店铺模型
    var model = MaintenanceModel()
    var imageString = [String]()
    //MARK: 获取店铺数据
    func GetMaintenanceInfoSingle(MaintenanceID:Int,result:((_ result:Bool?) -> Void)?) {
        CommonFunction.Global_Get(entity: MaintenanceModel(), IsListData: false, url: HttpsUrl+"api/Maintenance/GetMaintenanceInfoSingle", isHUD: false, isHUDMake: false, parameters: ["MaintenanceID":MaintenanceID] as NSDictionary) { (resultData) in
            if resultData?.Success == true {
                if resultData?.ret == 0 && resultData?.Content != nil {
                    self.model = resultData?.Content as! MaintenanceModel
                    result?(true)
                    return
                }
                result?(false)
            }else{
                result?(false)
            }
        }
    }
    func SetMaintenanceIsAudit(MaintenanceID:Int ,IsAudit:Bool ,RejectMsg:String ,result:((_ result:Bool?) -> Void)?) -> Void {
        let parameters = ["MaintenanceID":MaintenanceID ,"IsAudit":IsAudit ? "true" : "false","RejectMsg":RejectMsg] as [String : Any]
        CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl+"api/Maintenance/SetMaintenanceIsAudit", isHUD: true, isHUDMake: false, parameters: parameters as NSDictionary) { (resultData) in
            debugPrint(resultData?.Content ?? "")
            
            if resultData?.Success == true {
                if resultData?.ret == 0 {
                    result?(true)
                }else{
                    CommonFunction.HUD(resultData?.Result ?? "", type: .error)
                    result?(false)
                }
            }else{
                CommonFunction.HUD("提交失败", type: .error)
                result?(false)
            }
        }
    }
    

}
