//
//  MyinfoViewModel.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/9/4.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyinfoViewModel: NSObject {
    //更新用户信息
    func SetUpdateUserInfo(UserID:Int, UserName:String , ImagePath:String , Sex:String , Phone:String,result:((_ result:Bool?) -> Void)?) -> Void {
        let parameters=["UserID":UserID,"UserName":UserName,"ImagePath":ImagePath,"Sex":Sex,"Phone":Phone] as [String : Any]
        CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl+"api/My/SetUpdateUserInfo", isHUD: true, isHUDMake: true, parameters: parameters as NSDictionary) { (resultModel) in
            if resultModel?.Success == true {
                if resultModel?.ret == 0 {
                    let model = resultModel?.Content as! Dictionary<String, Any>
                    Global_UserInfo.ImagePath=model["ImagePath"] as! String
                    Global_UserInfo.Phone=model["Phone"] as! String
                    Global_UserInfo.UserName=model["UserName"] as! String
                    Global_UserInfo.Sex=model["Sex"] as! String
                    CommonFunction.ExecuteUpdate("update MemberInfo set UserID = (?), Phone = (?) , Token = (?), IsLogin = (?) ,UserName=(?),Sex=(?),ImagePath=(?),UserType=(?)",
                                                 [Global_UserInfo.UserID as AnyObject
                                                    ,Global_UserInfo.Phone as AnyObject
                                                    ,"" as AnyObject
                                                    ,true as AnyObject
                                                    ,Global_UserInfo.UserName as AnyObject
                                                    ,Global_UserInfo.Sex as AnyObject
                                                    ,Global_UserInfo.ImagePath as AnyObject
                                                    ,Global_UserInfo.UserType as AnyObject
                        ], callback: nil )
                    result?(true)
                }else{
                   result?(false)
                }
                
            }else{
                result?(false)
            }
        }
    }
    
    //MARK: 公共上传图片
    func SetImageUpload( datas:Array<Data>,Model:((_ model:AppResultModel?) -> Void)?) -> Void {
        AFNHelper.upload(HttpsUrl+"api/ImageUpload/SetImageUpload", parameters: nil, constructingBodyWithBlock: { (formData) in
            for i in 0..<datas.count{
                let formatter = DateFormatter.init()
                formatter.dateFormat = "yyyyMMddHHmmss"
                let dateString: String = formatter.string(from: Date())
                let fileName = dateString+i.description + ".jpg"
                print(fileName)
                formData.appendPart(withFileData: datas[i], name: "upuserinfo", fileName: fileName, mimeType: "image/jpge")
            }
            
        }, uploadProgress: { (progress) in
            debugPrint(progress.fractionCompleted)
        }, success: { (obj) in
            print("上传成功")
            let valuemodel = AppResultModel.mj_object(withKeyValues: JSON(obj).description)
            Model?(valuemodel)
        }, failure: { (error) in
            let valuemodel=AppResultModel()
            valuemodel.ret=2
            valuemodel.Result=error.description
            Model?(valuemodel)
        })

    }
}
