//
//  PostedDemandViewModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/24.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class PostedDemandViewModel: NSObject {
    
    let titlename = Variable<String>("")     //发布标题
    let username = Variable<String>("")     //用户名
    let phoneNumber = Variable<String>("")     //手机号
    let typeName = Variable<String>("")     //维修类型
    let content = Variable<String>("")     //需求内容
    var adress = ""                        //当前地址
    var currenLocation:CLLocation!=nil      //当前坐标
    var isUrgency = false                  //是否加急
    var currenImageList = [UIImage]()     //当前图片数组
    fileprivate var imageListString = [String]()
    // 保存按钮点击 绑定的 事件
    let saveEvent = PublishSubject<Void>()
    // 保存数据信号回调
    var saveResult: Observable<ValidationResult>? = nil
    var delegate: UIViewController? = nil
    override init() {
        super.init()
        self.bindtoValue()
    }
    //绑定值
    private func bindtoValue()->Void{
        //组合成一个新事件
        let parameter = Observable.combineLatest(titlename.asObservable(),username.asObservable(),phoneNumber.asObservable(),typeName.asObservable(),content.asObservable()){($0,$1,$2,$3,$4)}
        saveResult = saveEvent.asObserver()//事件监听
            .withLatestFrom(parameter)
            .flatMapLatest({ (title,user,phone,type,cont) -> Observable<ValidationResult> in
                debugPrint(self.adress,self.currenImageList.count,self.currenLocation.coordinate.latitude,self.currenLocation.coordinate.longitude)
                //业务逻辑处理
                if title == ""{
                    CommonFunction.HUD("请输入标题", type: .error)
                    return Observable.just(ValidationResult.empty)
                }
                //联系人验证
                if user == ""{
                    CommonFunction.HUD("请输入联系人", type: .error)
                    return Observable.just(ValidationResult.empty)
                }
                //手机号验证
                if(phone.characters.count != 11){
                    //校验手机号码
                    CommonFunction.HUD("请输入11位手机号", type: .error)
                    return Observable.just(ValidationResult.error)
                }else{
                    if(!Validate.phoneNum(phone).isRight){
                        CommonFunction.HUD("请输入正确的手机号", type: .error)
                        return Observable.just(ValidationResult.error)
                    }
                }
                //维修类型选择验证
                if type == "" {
                    CommonFunction.HUD("请选择一个维修类型", type: .error)
                    return Observable.just(ValidationResult.error)
                }
                //当前位置验证
                if self.adress == "" {
                    CommonFunction.HUD("请选择您的位置", type: .error)
                    return Observable.just(ValidationResult.error)
                }
                if cont == "" {
                    CommonFunction.HUD("请输入内容", type: .error)
                    return Observable.just(ValidationResult.error)
                }
                //带不带图都可以  加不加急都可以
                
                return Observable.just(ValidationResult.ok)
                
            }).shareReplay(1)
    }
    func SetDemandInfo() -> Void {
        if currenImageList.count == 0 {
            self.PostDemand()
        }else{
            self.upLoadImage()
        }
    }
    //先上传图片获取路径再发布需求
    private func upLoadImage()->Void{
        var dataArray = [Data]()
        for image in currenImageList {
            let data = UIImageJPEGRepresentation(image, 0.9)!
            dataArray.append(data)
        }
        MyinfoViewModel().SetImageUpload(datas: dataArray) { (resultModel) in
            if resultModel?.Success == true {
                if resultModel?.Content != nil {
                    self.imageListString = resultModel?.Content as! [String]
                    self.PostDemand()
                }
            }else{
                CommonFunction.HUD("上传图片失败", type: .error)
            }
        }
    }
    private func PostDemand()->Void{
        let parameters = ["Title":titlename.value,"Contact":username.value,"Phone":phoneNumber.value,"TypeNames":typeName.value,"Describe":content.value,"IsUrgent":isUrgency,"UserID":Global_UserInfo.UserID,"Lng":currenLocation.coordinate.longitude,"Lat":currenLocation.coordinate.latitude,"PathImages":self.imageListString,"CityName":CurrentCity] as [String : Any]
        CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl+"api/System/SetDemandInfo", isHUD: true, HUDMsg: "正在提交中...",isHUDMake: false, parameters: parameters as NSDictionary) { (resultData) in
            
            if(resultData?.Success==true){
                if resultData?.Content != nil {
                    
                    CommonFunction.AlertController(self.delegate!, title: "发布成功", message: "是否返回", ok_name: "确定", cancel_name: "取消", OK_Callback: {
                        self.delegate?.navigationController?.popViewController(animated: true)
                    }, Cancel_Callback: nil)
                }
            }else{
                CommonFunction.HUD("发布失败", type: .error)
            }
        }
    }
}

