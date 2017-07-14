//
//  File.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/10/26.
//  Copyright © 2016年 HCY. All rights reserved.
//

import Foundation


class AppResultModel:NSObject{
    ///Success
    var Success = false
    ///错误代码标识   0正常  1参数错误  2 get post失败  3内部错误  4其他错误 5 没有记录 6 没有更多分页
    var ret = 4
    ///返回结果
    var Result:String=""
    ///包体（消息)
    var Content:Any?
}
