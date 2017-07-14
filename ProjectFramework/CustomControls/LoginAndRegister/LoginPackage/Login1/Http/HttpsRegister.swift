//
//  HttpsRegister.swift
//  ProjectFramework
//
//  Created by hcy on 16/6/12.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

///注册请求类
class HttpsRegister {
    
    ///验证码
    func RegVerCodeHttp(_ vc:UIViewController?,parameters:NSDictionary,model:((_ model:AppResultModel) -> Void)?)->Void{
        //网络请求
        
        AFNHelper.post(vc, urlString: HttpsUrl+"api/Reg/VerificationCode", parameters:parameters,isHUD: false,isHUDMake: false, success: { (json) in
         
            if(json != nil){    //==nil表示失败的
                let  value = AppResultModel.mj_object(withKeyValues: json?.description)
                model?(value!)
            }
            
        }) { (error) in
            print(error)
        }
        
    }
    
    ///注册
    func RegHttp(_ vc:UIViewController?,parameters:NSDictionary,model:((_ model:AppResultModel) -> Void)?)->Void{
        //网络请求
        
        AFNHelper.post(vc, urlString:  HttpsUrl+"api/Reg/registered", parameters:parameters,isHUD: false,isHUDMake: false, success: { (json) in
            debugPrint(json?.dictionaryValue as Any)
            debugPrint(json as Any)
            if(json != nil){    //==nil表示失败的
                let  value = AppResultModel.mj_object(withKeyValues: json?.description)
                model?(value!)
            }
            
        }) { (error) in
            print(error)
        }
        
    }
    
}
