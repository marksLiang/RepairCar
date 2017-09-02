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
