//
//  regiestViewModel.swift
//  Cloudin
//
//  Created by 住朋购友 on 2017/3/24.
//  Copyright © 2017年 子轩. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources



class regiestViewModel {
    
    // input 监听数据      用于 UI 控件值 绑定 VM
    let username = Variable<String>("")     //用户名称的数据
    let password  = Variable<String>("")    //密码的数据
    let VerificationCode = Variable<String>("") //验证码数据
    // 注册按钮点击 绑定的 事件
    let registerEvent = PublishSubject<Void>()
    // 验证码按钮点击 绑定的 事件
    let VerificationCodeEvent = PublishSubject< Void >()
    var VerificationCodeEvent1:registerViewCell?=nil
    // 注册返回数据
    var registeResult: Observable<ValidationResult>? = nil
    
    var delegate: UIViewController? = nil
    
    init( ) {
        register()
        GetVerificationCode()
    }
    
    //注册
    func register(){
        
        
        
        let parameter = Observable.combineLatest(username.asObservable(),password.asObservable(),VerificationCode.asObservable()){($0,$1,$2)}
        registeResult = registerEvent.asObserver()
            .withLatestFrom(parameter)
            .flatMapLatest({ (name,pwd,vercode) -> Observable<ValidationResult> in
                //业务处理逻辑处理
                
                //------------用户名处理
                if(name==""){
                    //空值处理
                    CommonFunction.HUD("手机号不可为空", type: .error)
                    return Observable.just(ValidationResult.empty)
                }
                
                if(name.characters.count != 11){
                    //校验手机号码
                    CommonFunction.HUD("手机号码不正确", type: .error)
                    return Observable.just(ValidationResult.error)
                }
                else{
                    if(!Validate.phoneNum(name).isRight){
                        CommonFunction.HUD("非法手机号码", type: .error)
                        return Observable.just(ValidationResult.error)
                    }
                }
                
                
                //----------------密码处理
                if(pwd==""){
                    CommonFunction.HUD("密码不可为空", type: .error)
                    return Observable.just(ValidationResult.empty)
                    
                }
                if(pwd.characters.count < 6){
                    CommonFunction.HUD("密码不可小于6位数", type: .error)
                    //密码位数不能小于6位
                    return Observable.just(ValidationResult.error)
                    
                }
                
                
                //----------验证码处理
                if(vercode==""){
                    //空值处理
                    CommonFunction.HUD("验证码不可为空", type: .error)
                    return Observable.just(ValidationResult.empty)
                    
                }
                
                return Observable.just(ValidationResult.ok)
                
            }).shareReplay(1)
        
        
        
    }
    
    //获取验证码
    func GetVerificationCode(){
        
        _ =  VerificationCodeEvent.subscribe( onNext:{
            if(self.username.value==""){
                CommonFunction.HUD("手机号不可为空", type: .error)
                return
            }
            if(!Validate.phoneNum(self.username.value).isRight){
                CommonFunction.HUD("非法手机号码", type: .error)
                return
            }
            self.VerificationCodeEvent1?.StartTime()   //开启计时器
            CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl+"api/Login/RegisterVerificationCode", isHUD: true,HUDMsg: "正在获取验证码...", isHUDMake: false, parameters: ["Phone":self.username.value], Model: { (resultData) in
                if(resultData?.Success==true){
                     CommonFunction.HUD("发送成功", type: .success)
                }else{
                    CommonFunction.HUD(resultData!.Result, type: .error)
                }
            }) 
        }
        )
        
    }
    
    ///注册
    func SetRegister(){
        let parameters = ["Phone":username.value,"PassWord":password.value,"VerificationCode":VerificationCode.value]
        CommonFunction.Global_Post(entity: nil, IsListData: false, url:  HttpsUrl+"api/Login/SetRegister", isHUD: true,HUDMsg: "正在提交中...", isHUDMake: false, parameters:parameters as NSDictionary) { (resultData) in
            if(resultData?.Success==true){
                CommonFunction.HUD("注册成功", type: .success)
                self.delegate?.dismiss(animated: true, completion: { 
                    
                })
            }else{
                CommonFunction.HUD(resultData!.Result, type: .success)
            }
        }
    }
    
    
    
    
    
    
}
