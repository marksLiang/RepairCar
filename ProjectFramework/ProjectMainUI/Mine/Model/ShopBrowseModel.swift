//
//  ShopBrowseModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/9.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopBrowseModel: NSObject {
    var Images:[ImageList]?
    var OrderID=""
    var DealPrice=""
    var ActualPrice=""
    var PayType=0
    var CreateTime=""
    var MaintenanceID=0
    var TitleName=""
    var Address=""
    var Phone=""
    var Area=""
    var Lng=""
    var Lat=""
    var CityName=""
    var TypeNames=""
    var Introduce=""
    var StarRating=""
    var Views=0
    var ViewsFlase=0
    var UserID=0
    var IsScore=false
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["Images":ImageList.self]
    }
}
