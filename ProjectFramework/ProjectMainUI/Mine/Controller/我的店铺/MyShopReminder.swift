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
    fileprivate lazy var regejtlable: UILabel = {
        let regejtlable = UILabel.init(frame: CGRect.init(x: 0 , y: self.imageView.frame.maxY + 20, width: 200, height: 60))
        regejtlable.center.x = self.view.center.x
        regejtlable.numberOfLines = 0
        regejtlable.textAlignment = .center
        regejtlable.font = UIFont.systemFont(ofSize: 13)
        return regejtlable
    }()
    fileprivate lazy var applyForBtn: UIButton = {
        let applyForBtn = UIButton.init(type: .system)
        applyForBtn.frame = CGRect.init(x: 0, y: self.regejtlable.frame.maxY + 20, width: 150, height: 45)
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
    var resultString = "" //驳回信息
    var MaintenanceID = 0 //店铺ID
    fileprivate let imageArray = ["shopDeleta","notapply","auditing","shopDeleta"]
    fileprivate let textArray = ["您的店铺未审核通过,请重新提交！","您暂未申请店铺！","您的店铺正在审核...请耐心等待","您的申请暂未通过，请及时修改"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的店铺"
        self.view.backgroundColor = UIColor.white
        //1//被后台删除  2//未申请入驻   3//正在审核  4//被驳回 0 //存在店铺
        if type > 0 {
            imageView.image = UIImage.init(named: imageArray[type-1])
            lable.text = textArray[type-1]
        }
        if type == 2 {
            self.view.addSubview(applyForBtn)
        }
        if type == 4 {
            regejtlable.text = resultString
            applyForBtn.setTitle("重新修改", for: .normal)
            self.view.addSubview(applyForBtn)
        }
        self.view.addSubview(imageView)
        self.view.addSubview(lable)
        self.view.addSubview(regejtlable)
    }
    func buttonClick() -> Void {
        let vc = CommonFunction.ViewControllerWithStoryboardName("MyShop", Identifier: "MyShop") as! MyShop
        if type == 4 {
            vc.isBohui = true
            vc.MaintenanceID = MaintenanceID
        }
        self.navigationController?.show(vc, sender: nil)
        
    }
}
