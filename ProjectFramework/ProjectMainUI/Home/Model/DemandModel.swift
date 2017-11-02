//
//  DemandModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/31.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemandModel: NSObject {
    var Images:[ImageList]?
    var DemandID=0
    var Title=""
    var Contact=""
    var Phone=""
    var TypeNames=""
    var Describe=""
    var IsUrgent=false
    var UserID=0
    var IsDel=false
    var CityName=""
    var ReleaseType=0
    var CreateTime=""
    var Lng=""
    var Lat=""
    var ProvinceName=""
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["Images":ImageList.self]
    }
}
