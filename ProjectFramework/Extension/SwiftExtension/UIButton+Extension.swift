//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit


private var SUIBUTTONPERSON_ID_NUMBER_PROPERTY = ""
private var topNameKey = ""
private var rightNameKey = ""
private var bottomNameKey = ""
private var leftNameKey = ""
//拓展UIButton 1个属性   ExpTagString->String
extension UIButton {
    
    var ExpTagString:String{
        
        get{
            let result = objc_getAssociatedObject(self, &SUIBUTTONPERSON_ID_NUMBER_PROPERTY) as? String
            if result == nil {
                return ""
            }
            
            return result!
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &SUIBUTTONPERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy(rawValue: 3)!)
        }
    }
    
    ///圆角
    func CornerRadius (cornerRadius: CGFloat, borderColor: CGColor?,borderWidth: CGFloat){
        self.layer.cornerRadius=cornerRadius
        self.layer.borderColor=borderColor
        self.layer.borderWidth=borderWidth
        self.layer.masksToBounds=true
    }
    
    func setEnlargeEdgeWithTop(_ top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        objc_setAssociatedObject(self, topNameKey, Int(top), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, rightNameKey, Int(right), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, bottomNameKey, Int(bottom), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, leftNameKey, Int(left), .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    
    /// 设置文字和图片上下左右btn.setImageTitle(image: UIImage(named: "index1"), title: "文字在上方", titlePosition: .top,additionalSpacing: 10.0, state: .normal)
    ///
    /// - Parameters:
    ///   - anImage: 图片  格式 48*48
    ///   - title: 文字
    ///   - titlePosition: 位置  （上下左右)
    ///   - additionalSpacing: 间距
    ///   - state: state
    @objc func setImageTitle(image anImage: UIImage?, title: String,
                   titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state) 
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIViewContentMode,
                                             spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        let titleheight:CGFloat = 20
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleheight, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: -titleheight, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    
    
    ///搜索框
    ///用法：  self.navigationItem.titleView=UIButton().SearchBtn(target: self,actionEvent: #selector(SearchEvent), placeholder: "测试")
    func SearchBtn(target:Any,actionEvent:Selector,placeholder:String,placeholderColor:UIColor=UIColor.gray) ->UIButton   {
        
        //搜索框
        let Searchbtn = UIButton(type: .custom)
        Searchbtn.setTitle(placeholder, for: .normal)
        Searchbtn.setTitleColor(placeholderColor, for: .normal)
        Searchbtn.setImage(UIImage(named: "index_search"), for: .normal)
        Searchbtn.backgroundColor=UIColor.white
        Searchbtn.contentHorizontalAlignment = .left
        Searchbtn.titleLabel?.font=UIFont.systemFont(ofSize: 12)
        Searchbtn.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0)
        Searchbtn.imageEdgeInsets=UIEdgeInsetsMake(0, 8, 0, 0)
        Searchbtn.frame.size.width=CommonFunction.kScreenWidth*0.6
        Searchbtn.frame.size.height=30
        Searchbtn.layer.masksToBounds=true
        Searchbtn.CornerRadius(cornerRadius: 15, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        Searchbtn.addTarget(target, action: actionEvent, for: .touchUpInside)
        return Searchbtn
    }
    
}


                                            
