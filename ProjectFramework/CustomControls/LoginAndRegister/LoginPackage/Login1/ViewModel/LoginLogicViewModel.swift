//
//  LoginLogic.swift
//  ProjectFramework
//
//  Created by hcy on 16/7/8.
//  Copyright © 2016年 HCY. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginLogicViewModel {
    
    let regHttps = HttpsRegister()
    let fpHttps = HttpsForget_Password()
    let loginHttps = HttpsLogin()
    
    func LoginLogicViewModel(_ vc:UIViewController){
        
        let loginvc =  CommonFunction.ViewControllerWithStoryboardName("SB_Login", Identifier: "SB_Login") as! LoginViewController
        /*---登录----*/
        loginvc.Callback_loginInValue { (phone, password) in
            //操作登录逻辑
            debugPrint("用户登录")
            let device =   CommonFunction.GetPhoneDeviceModel()
            
            let parameters = ["PhoneNo": phone,"Password":password,"LoginWay":"ios客户端","MachineType":"ios","MachineInfo":device] as [String : Any]
           
            self.loginHttps.LoginHttp(nil, parameters:parameters as NSDictionary, model: { (model) in
                if(model.Success==true){
                    //登录成功 
                    //更新当前数据库存储的用户信息
                    if(model.ret==5){
                        CommonFunction.HUD("该账户未存在", type: .error)
                        return
                    }
                    let LoginResult = model.Content as! loginResultModel
                  
                    if(LoginResult.MemberID == "" || LoginResult.MemberID == "0" ){return}
                    
                    CommonFunction.ExecuteUpdate("update MemberInfo set MemberID = (?), PhoneNo = (?) , Token = (?), IsLogin = (?) ,RealName=(?),Sex=(?),HeadImgPath=(?)",
                                                 [LoginResult.MemberID as AnyObject
                                                    ,phone as AnyObject
                                                    ,LoginResult.Token as AnyObject
                                                    ,true as AnyObject
                                                    ,LoginResult.RealName as AnyObject
                                                    ,LoginResult.Sex as AnyObject
                                                    ,LoginResult.HeadImgPath as AnyObject
                        ], callback: nil )
                    
 
                    //极光推送添加别名
                      //JPUSHService.setAlias(Global_UserInfo.MemberID, callbackSelector: nil, object: self )
                    //如果登录成功 可以退出该页面了
                    vc.dismiss(animated: true, completion: nil)
                }else{
                    CommonFunction.HUD("账号密码是否正确", type: .error)
                }
            })
            
        }
        /*---用户注册----*/
        
        loginvc.Callback_RegisterVerificationCodeValue  { (phone) in
            debugPrint("用户注册验证码")
            //type = 2 表示是手机的验证码  1是PC端的
            self.regHttps.RegVerCodeHttp(nil, parameters: ["PhoneNo": phone,"type":2],model: { (model) in
                if(model .Success==true){
                    CommonFunction.HUD("验证码已发送", type: .success)
                }else{
                    CommonFunction.HUD(model.Result, type: .error)
                }
            })
        }
        loginvc.Callback_RegisterSubmitValue {  (phone, password, againpassword, VerificationCode) in
            debugPrint("用户注册提交")
           
            let parameters =  ["Name": "","Pwd":password,"Pwd_c":againpassword,"Email":"","PhoneNo":phone,"Code":VerificationCode] as NSDictionary
            self.regHttps.RegHttp(nil,parameters: parameters,model: { (model) in
                if(model.Success==true){
                    CommonFunction.HUD("用户注册成功！", type: .success)
                }else{
                    CommonFunction.HUD(model.Result, type: .error)
                }
            })
            
        }
        
        /*---忘记密码----*/
        loginvc.Callback_ForgetpasswordVerificationCodeValue { (phone) in
            debugPrint("用户注册验证码")
        }
        loginvc.Callback_ForgetpasswordSubmitValue {  (phone, password, againpassword, VerificationCode) in
            debugPrint("用户忘记密码提交")
        }
        
        //present类型 (用户登录)
        vc.present(loginvc, animated: true, completion: nil)
        
    }
     
}
