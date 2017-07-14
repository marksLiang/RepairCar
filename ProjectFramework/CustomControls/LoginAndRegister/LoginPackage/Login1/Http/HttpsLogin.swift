//
//  HttpsLogin.swift
//  ProjectFramework
//
//  Created by hcy on 16/6/12.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

///登录请求类
class HttpsLogin  {
    
    //数据请求
    func LoginHttp(_ vc:UIViewController?,parameters:NSDictionary,model:((_ model:AppResultModel) -> Void)?)->Void{
        //网络请求
        
        AFNHelper.post(vc, urlString: HttpsUrl+"api/Login/UserLogin", parameters:parameters,isHUD: false,isHUDMake: false, success: { (json) in
            
            if(json != nil){    //==nil表示失败的
                let  value = AppResultModel.mj_object(withKeyValues: json?.description)!
                
                let modelvalue = loginResultModel.mj_object(withKeyValues: value.Content)
                value.Content=modelvalue
                model?(value)
                
            }
            
        }) { (error) in
            print(error)
        }
        
    }
    
}
