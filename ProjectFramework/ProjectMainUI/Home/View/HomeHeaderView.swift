//
//  HomeHeaderView.swift
//  RepairCar
//
//  Created by 住朋购友 on 2017/7/19.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {
    typealias CallbackValue=(_ value:Int)->Void //类似于OC中的typedef
    var myCallbackValue:CallbackValue?  //声明一个闭包 类似OC的Block属性
    func  FuncCallbackValue(value:CallbackValue?){
        myCallbackValue = value //返回值
    }
    /*******************懒加载*********************/
    //查看所有维修店
    fileprivate lazy var allShopView: UIView = {
        let allShopView = UIView.init(frame: CGRect.init(x: 5, y: 155, width: (CommonFunction.kScreenWidth - 15) * 0.382, height: 90))
        allShopView.backgroundColor = CommonFunction.RGBA(243, g: 159, b: 36)
        
        let hotimage = UIImageView.init(frame: CGRect.init(x: 4, y: 3, width: 16, height: 20))
        hotimage.image = UIImage.init(named: "hot")
        allShopView.addSubview(hotimage)
        
        let xiuiamge = UIImageView.init(frame: CGRect.init(x: 0, y: 10, width: 40, height: 40))
        xiuiamge.center.x = allShopView.center.x - 5
        xiuiamge.image = UIImage.init(named: "xiu")
        allShopView.addSubview(xiuiamge)
        
        let lable = UILabel.init(frame: CGRect.init(x: 0, y: xiuiamge.frame.maxY + 10, width: allShopView.frame.width, height: 20))
        lable.center.x = allShopView.center.x
        lable.text = "所有维修店"
        lable.textColor = UIColor.white
        lable.font = UIFont.boldSystemFont(ofSize: 12)
        lable.textAlignment = .center
        allShopView.addSubview(lable)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapclik))
        tap.ExpTagInt = 1
        allShopView.addGestureRecognizer(tap)
        return allShopView
    }()
    //查看所有需求
    fileprivate lazy var allDemandView: UIView = {
        let allDemandView = UIView.init(frame: CGRect.init(x: self.allShopView.frame.maxX + 5, y: 155, width: (CommonFunction.kScreenWidth - 15) * 0.618, height: 90))
        allDemandView.backgroundColor = CommonFunction.RGBA(149, g: 168, b: 245)
        
        let rightImage = UIImageView.init(frame: CGRect.init(x: allDemandView.frame.width - 23, y: 3, width: 18, height: 20))
        rightImage.image = UIImage.init(named: "rockets")
        
        let xuqiu1 = UIImageView.init(frame: CGRect.init(x: 20, y: 27.5, width: 35, height: 35))
        xuqiu1.image = UIImage.init(named: "xuqiu")
        
        let lable1 = UILabel.init(frame: CGRect.init(x: xuqiu1.frame.maxX + 5 , y: 30, width: 150, height: 15))
        lable1.font = UIFont.boldSystemFont(ofSize: 12)
        lable1.text = "车主需求"
        lable1.textColor = UIColor.white
        
        let lable2 = UILabel.init(frame: CGRect.init(x: xuqiu1.frame.maxX + 5 , y: lable1.frame.maxY + 5, width: 150, height: 15))
        lable2.font = UIFont.systemFont(ofSize: 11)
        lable2.text = "随时掌握车主需求信息"
        lable2.textColor = UIColor.white
        
        allDemandView.addSubview(lable1)
        allDemandView.addSubview(lable2)
        allDemandView.addSubview(xuqiu1)
        allDemandView.addSubview(rightImage)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapclik))
        tap.ExpTagInt = 2
        allDemandView.addGestureRecognizer(tap)
        return allDemandView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        
        let leftView = UIView.init(frame: CGRect.init(x: 7, y: allShopView.frame.maxY + 10, width: 4, height: 25))
        leftView.backgroundColor = CommonFunction.SystemColor()
        
        let lable = UILabel.init(frame: CGRect.init(x: leftView.frame.maxX + 5, y: 0, width: 100, height: 15))
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.center.y = leftView.center.y
        lable.text = "热门推荐"
        
        self.addSubview(leftView)
        self.addSubview(lable)
        self.addSubview(allShopView)
        self.addSubview(allDemandView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tapclik( tap: UITapGestureRecognizer) -> Void {
        if myCallbackValue != nil {
            myCallbackValue!(tap.ExpTagInt)
        }
    }
}
