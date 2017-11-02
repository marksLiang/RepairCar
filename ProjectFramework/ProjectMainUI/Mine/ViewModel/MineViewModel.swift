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
   class func GetUserInfo(result:((_ result:Bool?,_ UserType:Int?) -> Void)?)  {
        CommonFunction.Global_Get(entity: LoginMode(), IsListData: false, url: HttpsUrl+"api/My/GetUserInfo", isHUD: false, isHUDMake: false, parameters: ["UserID":Global_UserInfo.UserID] as NSDictionary) { (resultModel) in
            if resultModel?.Success == true {
                if resultModel?.ret == 0 && resultModel?.Content != nil {
                    let model = resultModel?.Content as! LoginMode
                    result?(true,model.UserType)
                    return
                }
            }else{
                result?(false,1)
            }
        }
    }
    //MARK: 获取店铺状态   1//被后台删除  2//未申请入驻   3//正在审核   0 //存在店铺
    class func GetMaintenanceStatus(result:((_ result:Bool?,_ type:Int?) -> Void)?) -> Void {
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
                if resultModel?.ret == 0 && resultModel?.Content != nil {
                    result?(true,0)
                    return
                }
            }else{
                result?(false,0)
            }
            
        }
    }
}