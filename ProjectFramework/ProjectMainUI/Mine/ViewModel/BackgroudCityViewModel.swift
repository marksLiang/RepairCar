//
//  BackgroudCityViewModel.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/11/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class BackgroudCityViewModel: NSObject {
    var ListData = [BackgroudCityModel]()
    func GetAuthorizationCityListAdmin(result:((_ result:Bool?) -> Void)?) {
        
        CommonFunction.Global_Get(entity: BackgroudCityModel(), IsListData: true, url: HttpsUrl+"api/City/GetAuthorizationCityListAdmin", isHUD: false, isHUDMake: false, parameters: ["UserID":Global_UserInfo.UserID,"IsAuthorise":"false"]) { (resultModel) in
            
            if resultModel?.Success == true {
                if resultModel?.Content != nil && resultModel?.ret == 0{
                    self.ListData = resultModel?.Content as! [BackgroudCityModel]
                    if self.ListData.first?.ParentID == 0 {
                        self.ListData.removeFirst()
                    }
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
