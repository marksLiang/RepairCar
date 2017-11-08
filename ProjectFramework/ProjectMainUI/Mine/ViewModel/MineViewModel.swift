//
//  MineViewModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/1.
//  Copyright © 2017年 HCY. All rights reserved.
//

import Foundation

class MineViewModel {
    //MARK: 实时获取用户信息
    var model = MaintenanceModel()
    var resultString = ""
   class func GetUserInfo(result:((_ result:Bool?,_ UserType:Int?) -> Void)?)  {
        CommonFunction.Global_Get(entity: LoginMode(), IsListData: false, url: HttpsUrl+"api/My/GetUserInfo", isHUD: false, isHUDMake: false, parameters: ["UserID":Global_UserInfo.UserID] as NSDictionary) { (resultModel) in
            if resultModel?.Success == true {
                if resultModel?.ret == 0 && resultModel?.Content != nil {
                    let model = resultModel?.Content as! LoginMode
                    Global_UserInfo.ProvinceName = model.ProvinceName
                    Global_UserInfo.cityName = model.CityName
                    result?(true,model.UserType)
                    return
                }
            }else{
                result?(false,1)
            }
        }
    }
    //MARK: 获取店铺状态   1//被后台删除  2//未申请入驻   3//正在审核  4//被驳回 0 //存在店铺
    func GetMaintenanceStatus(result:((_ result:Bool?,_ type:Int?) -> Void)?) -> Void {
        CommonFunction.Global_Get(entity: nil, IsListData: false, url: HttpsUrl+"api/Maintenance/GetMaintenanceStatus", isHUD: true, isHUDMake: false, parameters: ["UserID":Global_UserInfo.UserID] as NSDictionary) { (resultModel) in
            
            if resultModel?.Success == true {
                //被后台删除
                if resultModel?.ret == 4 {
                    result?(true,1)
                    return
                }
                //未申请
                if resultModel?.ret == 5 {
                    result?(true,2)
                    return
                }
                //正在审核
                if resultModel?.ret == 0 && resultModel?.Content == nil {
                    result?(true,3)
                    return
                }
                //被驳回
                if resultModel?.ret == 2 {
                    debugPrint(resultModel?.Result ?? "")
                    self.resultString = resultModel?.Result ?? ""
                    let model = MaintenanceModel.mj_object(withKeyValues: resultModel?.Content)
                    self.model = model!
                    result?(true,4)
                    return
                }
                if resultModel?.ret == 0 && resultModel?.Content != nil {
                    let model = MaintenanceModel.mj_object(withKeyValues: resultModel?.Content)
                    self.model = model!
                    result?(true,0)
                    return
                }
            }else{
                result?(false,0)
            }
            
        }
    }
    
}
