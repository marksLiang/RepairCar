//
//  ShopBrowseViewModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/9.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopBrowseViewModel: NSObject {
    var ListData = [ShopBrowseModel]()
    
    func GetMyOrderInfo(PageIndex:Int , PageSize: Int ,UserID:Int,Type:Int ,result:((_ result:Bool?,_ NoMore:Bool?,_ Nodata:Bool?) -> Void)?) {
        let parameters=["pageIndex":PageIndex,"pageSize":PageSize,"UserID":UserID,"Type":Type]
        CommonFunction.Global_Get(entity: ShopBrowseModel(), IsListData: true, url: HttpsUrl+"api/Order/GetMyOrderInfo", isHUD: false, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            //debugPrint(parameters)
            if(resultModel?.Success==true){
                //没有数据
                if(resultModel?.ret==5){
                    result?(true,false,true)
                    return
                }
                let model =  resultModel?.Content   as!  [ShopBrowseModel]
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
    
    //修改评分
    func SetMaintenanceScore(OrderID:String , MaintenanceID:Int , UserID:Int=Global_UserInfo.UserID , Score:Int , Msg:String="" ,result:((_ isSuscce: Bool) -> Void)?) {
        let parameters = ["OrderID":OrderID,"MaintenanceID":MaintenanceID,"UserID":UserID,"Score":Score,"Msg":Msg] as [String : Any]
        CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl+"api/Maintenance/SetMaintenanceScore", isHUD: true, isHUDMake: false, parameters: parameters as NSDictionary) { (resultData) in
            
            if resultData?.ret == 0 && resultData?.Success == true {
                result?(true)
            }else{
                result?(false)
            }
        }
    }
}
