//
//  LoginViewModel.swift
//  Cloudin
//
//  Created by 住朋购友 on 2017/3/27.
//  Copyright © 2017年 子轩. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources



class LoginViewModel {
    
    // input 监听数据      用于 UI 控件值 绑定 VM
    let username = Variable<String>("")     //用户名称的数据
    let password  = Variable<String>("")    //密码的数据
    // 注册按钮点击 绑定的 事件
    let LoginEvent = PublishSubject<Void>()
    
    // 保存返回数据
    var LoginResult: Observable<ValidationResult>? = nil
    
    init( ) {
        Login()
    }
    
    //请求登录
    func Login(){
        
        
        
        let parameter = Observable.combineLatest(username.asObservable(),password.asObservable()){($0,$1)}
        
        LoginResult = LoginEvent.asObserver()
            .withLatestFrom(parameter)
            .flatMapLatest({ (name,pwd) -> Observable<ValidationResult> in
                //业务处理逻辑处理
                
                //------------用户名处理
                if(name==""){
                    CommonFunction.HUD("账号不可为空", type: .error)
                    //空值处理
                    return Observable.just(ValidationResult.empty)
                }
               
                //----------------密码处理
                if(pwd==""){
                    //空值处理
                    CommonFunction.HUD("密码不可为空", type: .error)
                    return Observable.just(ValidationResult.empty)
                    
                }
                if(pwd.characters.count == 0){
                    //密码位数不能小于6位
                    CommonFunction.HUD("请输入密码", type: .error)
                    return Observable.just(ValidationResult.error)
                }
                
                
                
                return Observable.just(ValidationResult.ok)
                
            }).shareReplay(1)
        
        
        
    }
    
    func SetLogin( result:((_ result:Bool?) -> Void)?){
        let parameters=["UsersName":username.value,"PassWord":password.value]
        CommonFunction.Global_Post(entity: LoginMode(), IsListData: false, url: HttpsUrl+"api/Login/Login", isHUD: true, isHUDMake: false, parameters: parameters as NSDictionary) { (resultData) in
            if(resultData?.Success==true){
                if resultData?.ret == 0 {
                    let model = resultData?.Content as! LoginMode
                    
                    Global_UserInfo.ImagePath=model.ImagePath
                    Global_UserInfo.Phone=model.Phone
                    Global_UserInfo.UserName=model.UserName
                    Global_UserInfo.Sex=model.Sex
                    Global_UserInfo.UserID=model.UserID
                    Global_UserInfo.IsLogin=true
                    
                    Global_UserInfo.UserType=model.UserType
                    
                    //登陆成功后 存储到数据库
                    CommonFunction.ExecuteUpdate("update MemberInfo set UserID = (?), Phone = (?) , Token = (?), IsLogin = (?) ,UserName=(?),Sex=(?),ImagePath=(?),UserType=(?)",
                                                 [Global_UserInfo.UserID as AnyObject
                                                    ,Global_UserInfo.Phone as AnyObject
                                                    ,"" as AnyObject
                                                    ,Global_UserInfo.IsLogin as AnyObject
                                                    ,Global_UserInfo.UserName as AnyObject
                                                    ,Global_UserInfo.Sex as AnyObject
                                                    ,Global_UserInfo.ImagePath as AnyObject
                                                    ,Global_UserInfo.UserType as AnyObject
                        ], callback: nil )
                    
                    
                    
                    result?(true)
                }
                else{
                    CommonFunction.HUD(resultData!.Result, type: .error)
                    result?(false)
                }
            }else{
                    CommonFunction.HUD(resultData!.Result, type: .error)
            }
        }
    }
    
    
    
}
