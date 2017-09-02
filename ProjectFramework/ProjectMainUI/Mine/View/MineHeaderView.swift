//
//  MineHeaderView.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/13.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class MineHeaderView: UIView {
    typealias CallbackValue=(_ value:String)->Void //类似于OC中的typedef
    var myCallbackValue:CallbackValue?  //声明一个闭包 类似OC的Block属性
    func  FuncCallbackValue(value:CallbackValue?){
        myCallbackValue = value //返回值
    }
    
    @IBOutlet weak var userHeadImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        userHeadImage.layer.cornerRadius = userHeadImage.frame.width / 2
        userHeadImage.clipsToBounds = true
        self.backgroundColor = CommonFunction.SystemColor()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapclick))
        self.addGestureRecognizer(tap)
    }
    func tapclick() -> Void {
        if myCallbackValue != nil {
            myCallbackValue!("")
        }
    }
    func setData() -> Void {
        if(Global_UserInfo.IsLogin==true){
            userHeadImage.ImageLoad(PostUrl: HttpsUrlImage+Global_UserInfo.ImagePath)
            userName.text = Global_UserInfo.UserName
            userPhone.text = Global_UserInfo.Phone
        }else{
            userName.text = "未登录"
            userPhone.text = "点击去登录吧!"
        }
    }
}
