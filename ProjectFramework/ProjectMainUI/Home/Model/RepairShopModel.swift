//
//  RepairShopModel.swift
//  RepairCar
//
//  Created by 住朋购友 on 2017/7/18.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class RepairShopModel: NSObject {
    var Images:[ImageList]?
    var KM=""
    var MaintenanceID=0
    var TitleName=""
    var Address=""
    var Phone=""
    var Area=""
    var Lng=0.0
    var Lat=0.0
    var CityName=""
    var TypeNames=""
    var Introduce=""
    var StarRating=0.0
    var UserID=1
    var IsRecommend=false
    var IsTop=false
    var IsAudit=false
    var Views=0
    var ViewsFlase=0
    var IsDel=false
    var CreateTime=""
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["Images":ImageList.self]
    }
}

class ImageList: NSObject {
    var ImgID=0
    var ImgPath=""
    var ImgDescribe=""
    var ImgType=0
    var OtherID=0
    var CreateTime=""
}
