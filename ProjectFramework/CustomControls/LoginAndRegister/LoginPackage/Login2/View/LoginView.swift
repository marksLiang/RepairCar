//
//  LoginView.swift
//  Cloudin
//
//  Created by hcy on 2017/3/8.
//  Copyright © 2017年 子轩. All rights reserved.
//

import UIKit

class LoginView: UIView
{
    ///背景图片
    lazy var backgroundImage:UIImageView =
        {
        let Imageview = UIImageView(frame: self.frame)
            Imageview.image=UIImage(named: "Login2Resource.bundle/登录页面背景.png")
        return Imageview
        }()
    
    ///用户图片
    lazy var UserImage:UIImageView = {
        let imgWh:CGFloat=90
        let img = UIImageView(frame: CGRect(x: self.bounds.width/2-imgWh/2, y: 100, width:imgWh, height: imgWh))
        img.image=UIImage.init(named: "userIcon_defualt")
        img.layer.borderColor=UIColor.white.cgColor
        img.layer.borderWidth=4
        img.layer.cornerRadius=imgWh/2
        img.layer.masksToBounds=true
        return img
    }()
    
    ///用户登录账号图标
    lazy var uimage:UIImageView = {
        let image = UIImageView(frame: CGRect(x: 30, y: self.UserImage.frame.maxY+50, width: 27, height: 27))
        image.image=UIImage(named: "Login2Resource.bundle/用户.png")
        image.contentMode = .center
        return image
    }()
    
    ///用户登录账号
    lazy var UserNameText:UITextField = {
        let imgWh:CGFloat=70
        let newTextField = UITextField(frame: CGRect(x: 70, y: self.UserImage.frame.maxY+50, width: self.bounds.width-100, height: 27))
        newTextField.placeholder="请输入"
        newTextField.font=UIFont.systemFont(ofSize: 12)
        newTextField.clearButtonMode = .always
        newTextField.textColor=UIColor.white
        newTextField.attributedPlaceholder=NSAttributedString(string: newTextField.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.white])    //修改placeholder的颜色
        return newTextField
    }()
    
    ///用户登录账号线条
    lazy var UsernameLine:UILabel = {
        
        let line = UILabel(frame: CGRect(x: 20, y: self.UserNameText.frame.maxY+2, width: self.bounds.width-40, height: 1))
        line.backgroundColor=UIColor.white
        return line
    }()
    
    
    ///用户登录账号图标
    lazy var pawuimage:UIImageView = {
        let image = UIImageView(frame: CGRect(x: 30, y: self.UsernameLine.frame.maxY+30, width: 27, height: 27))
        image.image=UIImage(named: "Login2Resource.bundle/锁.png")
        image.contentMode = .center
        return image
    }()
    
    ///用户登录账号
    lazy var pawNameText:UITextField = {
        let imgWh:CGFloat=70
        let newTextField = UITextField(frame: CGRect(x: 70, y: self.UsernameLine.frame.maxY+30, width: self.bounds.width-100, height: 27))
        newTextField.placeholder="请输入"
        newTextField.font=UIFont.systemFont(ofSize: 12)
        newTextField.clearButtonMode = .always
        newTextField.textColor=UIColor.white
        newTextField.isSecureTextEntry=true
        newTextField.attributedPlaceholder=NSAttributedString(string: newTextField.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.white])    //修改placeholder的颜色
        return newTextField
    }()
    
    ///用户登录账号线条
    lazy var pawnameLine:UILabel = {
        
        let line = UILabel(frame: CGRect(x: 20, y: self.pawNameText.frame.maxY+2, width: self.bounds.width-40, height: 1))
        line.backgroundColor=UIColor.white
        return line
    }()
    
    ///忘记密码
    lazy var Forgetpassword:UIButton = {
        
        let btn = UIButton(frame: CGRect(x: self.pawnameLine.frame.maxX-80, y: self.pawnameLine.frame.maxY+5, width:  80, height: 20))
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle(  "忘记密码？",   for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return btn
    }()
    
    
    
    ///登录 按钮
    lazy var loginbtn:UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 20, y: self.Forgetpassword.frame.maxY+20, width: self.bounds.width-40, height: 35))
        btn.backgroundColor=UIColor(red: 255/255, green: 193/255, blue: 37/255, alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle(  "登  录",   for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.layer.cornerRadius=4
        btn.layer.masksToBounds=true
        return btn
    }()
    
    ///注册 按钮
    lazy var registerbtn:UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 20, y: self.loginbtn.frame.maxY+20, width: self.bounds.width-40, height: 35))
        btn.backgroundColor=UIColor(red: 92/255, green: 190/255, blue: 255/255, alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle(  "注  册",   for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.layer.cornerRadius=4
        btn.layer.masksToBounds=true
        return btn
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ShowView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func ShowView( ){
        self.addSubview(backgroundImage)
        
        self.addSubview(UserImage)
        self.addSubview(uimage)
        self.addSubview(UserNameText)
        self.addSubview(UsernameLine)
          
        self.addSubview(pawuimage)
        self.addSubview(pawNameText)
        self.addSubview(pawnameLine)
        
        self.addSubview(Forgetpassword)
        
        self.addSubview(loginbtn)
        self.addSubview(registerbtn)
        
    }

}
