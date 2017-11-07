//
//  MaintenanceModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/6.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class BackgroundModel: NSObject {
    var UserAddStatistics=0
    var DemandReleaseStatistics=0
    var TurnoverDayStatistics=0.00
    var TurnoverMonthStatistics=0.00
    var AddMaintenanceCount=0
    var MaintenanceInfoList:[MaintenanceModel]?
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["MaintenanceInfoList":MaintenanceModel.self]
    }
}
class MaintenanceModel: NSObject {
    var Images:[ImageList]?
    var LicenseImgs:[ImageList]?
    var KM=""
    var MaintenanceID=0
    var TitleName=""
    var Address=""
    var Phone=""
    var Area=""
    var Lng=0.00000000000000
    var Lat=0.00000000000000
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
    var ProvinceName=""
    var TopTime=""
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["Images":ImageList.self,"LicenseImgs":ImageList.self]
    }
}
