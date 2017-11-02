//
//  MyShopReminder.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/2.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class MyShopReminder: UIViewController {
    fileprivate lazy var imageView: UIImageView = {
       let imageView = UIImageView.init(frame: CGRect.init(x: 50 * CommonFunction.kScreenWidth / 320, y: CommonFunction.NavigationControllerHeight + 60, width: 55, height: 55))
        return imageView
    }()
    fileprivate lazy var lable: UILabel = {
        let lable = UILabel.init(frame: CGRect.init(x: self.imageView.frame.maxX + 20, y: 0, width: 200, height: 60))
        lable.numberOfLines = 2
        lable.center.y = self.imageView.center.y
        lable.font = UIFont.systemFont(ofSize: 17)
        return lable
    }()
    fileprivate lazy var applyForBtn: UIButton = {
        let applyForBtn = UIButton.init(type: .system)
        applyForBtn.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight + 150, width: 150, height: 45)
        applyForBtn.layer.cornerRadius = 5
        applyForBtn.center.x = self.view.center.x
        applyForBtn.backgroundColor = CommonFunction.SystemColor()
        applyForBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        applyForBtn.setTitle("申请店铺", for: .normal)
        applyForBtn.setTitleColor(UIColor.white, for: .normal)
        applyForBtn.addTarget(self, action: #selector(MyShopReminder.buttonClick), for: .touchUpInside)
        return applyForBtn
    }()
    var type = 0
    fileprivate let imageArray = ["shopDeleta","notapply","auditing"]
    fileprivate let textArray = ["您的店铺因为违规已被后台删除！","您暂未申请店铺！","您的店铺正在审核...请耐心等待"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的店铺"
        self.view.backgroundColor = UIColor.white
        //1//被后台删除  2//未申请入驻   3//正在审核   0 //存在店铺
        if type != 0 {
            imageView.image = UIImage.init(named: imageArray[type-1])
            lable.text = textArray[type-1]
        }
        if type == 2 {
            self.view.addSubview(applyForBtn)
        }
        self.view.addSubview(imageView)
        self.view.addSubview(lable)
    }
    func buttonClick() -> Void {
        
    }
}
