//
//  MyShopViewModel.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/11/4.
//  Copyright © 2017年 HCY. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class MyShopViewModel: NSObject {
    let shopName = Variable<String>("")     //店名
    let phoneNumber = Variable<String>("")     //手机号
    let arae = Variable<String>("")     //面积
    let city = Variable<String>("")     //城市
    let typeName = Variable<String>("")     //城市
    var adress = ""                        //当前地址
    var currenLocation:CLLocation!=nil      //当前坐标
    let content = Variable<String>("")     //店铺描述
    var permit = UIImage() //营业执照
    var currenImageList = [UIImage]()     //当前图片数组
    fileprivate var permitString = [String]() //营业执照
    fileprivate var imageListString = [String]()//店铺图片
    // 保存按钮点击 绑定的 事件
    let saveEvent = PublishSubject<Void>()
    // 保存数据信号回调
    var saveResult: Observable<ValidationResult>? = nil
    var delegate: UIViewController? = nil
    var MaintenanceID=0
    //店铺模型
    var model = MaintenanceModel()
    var isHave = false
    override init() {
        super.init()
        self.bindtoValue()
    }
    //绑定值
    private func bindtoValue()->Void{
        //组合成一个新事件
        let parameter = Observable.combineLatest(shopName.asObservable(),phoneNumber.asObservable(),arae.asObservable(),city.asObservable(),typeName.asObservable(),content.asObservable()){($0,$1,$2,$3,$4,$5)}
        saveResult = saveEvent.asObserver()//事件监听
            .withLatestFrom(parameter)
            .flatMapLatest({ (title,phone,arae,city,type,cont) -> Observable<ValidationResult> in
                debugPrint(self.adress,self.currenImageList.count,self.currenLocation.coordinate.latitude,self.currenLocation.coordinate.longitude)
                //业务逻辑处理
                if title == ""{
                    CommonFunction.HUD("请输入店铺名称", type: .error)
                    return Observable.just(ValidationResult.empty)
                }
                //联系人验证
                if phone == ""{
                    CommonFunction.HUD("请输入电话号码", type: .error)
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
                //面积
                if arae == "" {
                    CommonFunction.HUD("请输入店铺面积", type: .error)
                    return Observable.just(ValidationResult.error)
                }
                //面积
                if city == "" {
                    CommonFunction.HUD("请选择所属城市", type: .error)
                    return Observable.just(ValidationResult.error)
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
                    CommonFunction.HUD("请输入店铺描述", type: .error)
                    return Observable.just(ValidationResult.error)
                }
                //营业执照
                if self.permit == UIImage.init(named: "shopDefault")!  {
                    CommonFunction.HUD("请上传营业执照", type: .error)
                    return Observable.just(ValidationResult.error)
                }
                //店铺图片
                if self.currenImageList.count == 0 {
                    CommonFunction.HUD("请上传至少一张店铺图片", type: .error)
                    return Observable.just(ValidationResult.error)
                }
                return Observable.just(ValidationResult.ok)
                
            }).shareReplay(1)
    }
    //MARK: 上传店铺图片
    func upLoadImage() -> Void {
        var dataArray = [Data]()
        for image in currenImageList {
            let data = UIImageJPEGRepresentation(image, 0.9)!
            dataArray.append(data)
        }
        MyinfoViewModel().SetImageUpload(datas: dataArray) { (resultModel) in
            if resultModel?.Success == true {
                if resultModel?.Content != nil {
                    self.imageListString = resultModel?.Content as! [String]
                    debugPrint(self.imageListString)
                    self.upLoadPermit()//上传营业执照
                }
            }else{
                CommonFunction.HUD("上传图片失败", type: .error)
            }
        }
    }
    private func upLoadPermit() -> Void{
        let data = UIImageJPEGRepresentation(permit, 0.9)!
        MyinfoViewModel().SetImageUpload(datas: [data]) { (resultModel) in
            if resultModel?.Success == true {
                if resultModel?.Content != nil {
                    self.permitString = resultModel?.Content as! [String]
                    if self.isHave {
                        self.SetUserMaintenanceEditSave()
                    }else{
                        self.SetMaintenanceApplyFor()
                    }
                }
            }else{
                CommonFunction.HUD("上传图片失败", type: .error)
            }
        }
    }
    //MARK: 保存店铺数据
    private func SetUserMaintenanceEditSave()->Void{
        let coordinate = MapTool.bd09(fromGCJ02: self.currenLocation.coordinate)
        let parameters = ["MaintenanceID":self.MaintenanceID,"TitleName":shopName.value,"Address":self.adress,"Phone":phoneNumber.value,"Area":arae.value,"CityName":city.value,"TypeNames":typeName.value,"Introduce":content.value,"UserID":Global_UserInfo.UserID,"Lng":coordinate.longitude,"Lat":coordinate.latitude,"PathImages":self.imageListString,"LicenseImages":self.permitString] as [String : Any]
        CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl+"api/Maintenance/SetUserMaintenanceEditSave", isHUD: true, HUDMsg: "正在提交中...",isHUDMake: false, parameters: parameters as NSDictionary) { (resultData) in
            
            if(resultData?.Success==true){
                if resultData?.Content != nil {
                    CommonFunction.HUD("保存成功", type: .success)
                }
            }else{
                CommonFunction.HUD("发布失败", type: .error)
            }
        }
    }
    //MARK: 提交数据
    private func SetMaintenanceApplyFor() -> Void{
        let coordinate = MapTool.bd09(fromGCJ02: self.currenLocation.coordinate)
        let parameters = ["MaintenanceID":self.MaintenanceID,"TitleName":shopName.value,"Address":self.adress,"Phone":phoneNumber.value,"Area":arae.value,"CityName":city.value,"TypeNames":typeName.value,"Introduce":content.value,"UserID":Global_UserInfo.UserID,"Lng":coordinate.longitude,"Lat":coordinate.latitude,"PathImages":self.imageListString,"LicenseImages":self.permitString] as [String : Any]
        CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl+"api/Maintenance/SetMaintenanceApplyFor", isHUD: true, HUDMsg: "正在提交中...",isHUDMake: false, parameters: parameters as NSDictionary) { (resultData) in
            
            if(resultData?.Success==true){
                if resultData?.Content != nil {
                    
                    CommonFunction.AlertController(self.delegate!, title: "提交成功", message: "请耐心等待审核", ok_name: "确定", cancel_name: nil, OK_Callback: {
                        self.delegate?.navigationController?.popToRootViewController(animated: true)
                    }, Cancel_Callback: nil)
                }
            }else{
                CommonFunction.HUD("发布失败", type: .error)
            }
        }
    }
    //MARK: 获取店铺数据
    func GetMaintenanceInfoSingle(MaintenanceID:Int,result:((_ result:Bool?) -> Void)?) {
        CommonFunction.Global_Get(entity: MaintenanceModel(), IsListData: false, url: HttpsUrl+"api/Maintenance/GetMaintenanceInfoSingle", isHUD: false, isHUDMake: false, parameters: ["MaintenanceID":MaintenanceID] as NSDictionary) { (resultData) in
            if resultData?.Success == true {
                if resultData?.ret == 0 && resultData?.Content != nil {
                    self.model = resultData?.Content as! MaintenanceModel
                    result?(true)
                    return
                }
                result?(false)
            }else{
                result?(false)
            }
        }
    }
}
