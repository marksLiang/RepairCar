//
//  SfitParmterModel.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/21.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class SfitParmterModel: NSObject {
    var MaintenanceTypeNames:[StarRatingList]?
    var StarRating:[StarRatingList]?
    var Distance:[StarRatingList]?
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["MaintenanceTypeNames":StarRatingList.self,"StarRating":StarRatingList.self,"Distance":StarRatingList.self]
    }
}
class StarRatingList: NSObject {
    var ShowTitle=""
    var StarRatingEnum=0
}
