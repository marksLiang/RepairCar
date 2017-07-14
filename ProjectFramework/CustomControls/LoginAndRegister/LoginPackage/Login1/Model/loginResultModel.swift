//
//  File.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/10/25.
//  Copyright © 2016年 HCY. All rights reserved.
//

import Foundation

 class loginResultModel:NSObject {
    
    ///用户id
    var MemberID=""
   
    var RealName=""
    
    var Sex=""
   
    var HeadImgPath=""
    ///登录成功
    var IsLoginSuccess=false
    ///登录信息
    var LoginMessage=""
    ///角色
    var Roles = [Any]()
    ///token
    var Token=""
     
}
