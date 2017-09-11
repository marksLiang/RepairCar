//
//  FeedbackViewModel.swift
//  ProjectFramework_Tourism
//
//  Created by 住朋购友 on 2017/5/4.
//  Copyright © 2017年 HCY. All rights reserved.
//

import Foundation
import RxSwift

class FeedbackViewModel {
    
    
    let Description = Variable<String>("")     //描述数据
    let QQPhone  = Variable<String>("")    //联系方式数据
    var delegate: UIViewController?=nil
    // 按钮点击 绑定的 事件
    let  Event = PublishSubject<Void>()
    // 保存返回数据
    var Result: Observable<Bool>? = nil
    
    init( ) {
        
        let parameter = Observable.combineLatest(Description.asObservable(),QQPhone.asObservable()){($0,$1)}
       Result =  Event.asObserver()
            .withLatestFrom(parameter)
            .flatMapLatest({ (Description,QQPhone) -> Observable<Bool> in
                //业务处理逻辑处理
                if(Description == ""){
                    CommonFunction.HUD("请输入您要反馈的信息", type: .error)
                    return Observable.just(false)
                }
                if(QQPhone == ""){
                    CommonFunction.HUD("请输入您的联系方式", type: .error)
                    return Observable.just(false)
                }
                let parameters = [ "msg":Description,"QQPhone":QQPhone]
                CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl+"api/System/SetFeedback", isHUD: true, isHUDMake: false, parameters: parameters as NSDictionary, Model: { (resultData) in
                    
                    if(resultData?.Success==true){
                        CommonFunction.HUD("提交成功", type: .success)
                        self.delegate?.navigationController?.popViewController(animated: true)
                    }else{
                        CommonFunction.HUD("提交失败", type: .error)
                    }
                    
                })
                
                return Observable.just(true)
                
            }).shareReplay(1)
    }
    
  
    
}
