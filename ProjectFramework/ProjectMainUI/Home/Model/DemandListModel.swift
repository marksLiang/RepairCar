//
//  DemandListModel.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/22.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemandListModel: NSObject {
    var Images:[ImageList]?
    var DemandID=0
    var Title=""
    var Contact=""//联系人
    var Phone=""
    var TypeNames=""
    var Describe=""//描述
    var IsUrgent=false
    var UserID=1
    var IsDel=false
    var CityName=""
    var ReleaseType=0
    var CreateTime=""
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["Images":ImageList.self]
    }
}
