//
//  CityListViewModel.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/19.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class CityListViewModel: NSObject {
    var ListData = [CityListModel]()
    func GetCityList (result:((_ result:Bool?,_ errorString:String?) -> Void)?){
        CommonFunction.Global_Get(entity: CityListModel(), IsListData: true, url: HttpsUrl+"api/City/GetCityList", isHUD: false, isHUDMake: false, parameters: nil) { (resultModel) in
            if(resultModel?.Success==true){
                if(resultModel?.ret==0){
                    self.ListData = resultModel?.Content   as!  [CityListModel]
                    result?(true,"")
                }else{
                    result?(true,resultModel!.Result)
                }
            }else{
                result?(false,"")
            }
        }
    }
}
