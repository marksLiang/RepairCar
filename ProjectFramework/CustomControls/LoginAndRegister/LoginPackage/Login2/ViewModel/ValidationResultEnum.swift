//
//  Protocols.swift
//  loginRx
//
//  Created by zhanghao on 17/2/27.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import UIKit

enum ValidationResult {
    case ok
    case error
    case empty
}


// 计算性属性，一般只写 get 方法，get 可省略，一般不会去监听属性改变
// MARK: 计算性属性 是否验证通过
extension ValidationResult {
    
    var isValid: Bool {
        switch self {
            case .ok:
                return true
            default:
                return false
        }
    }
    
}
 










