//
//  ShopScore.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/11/9.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopScore: UIViewController {
    
    fileprivate lazy var shopLable: UILabel = {
       let shopLable = UILabel.init(frame: CGRect.init(x: 20, y: CommonFunction.NavigationControllerHeight + 20, width: 200, height: 40))
        shopLable.numberOfLines = 2
        shopLable.font = UIFont.boldSystemFont(ofSize: 15)
        shopLable.textColor = UIColor.black
        return shopLable
    }()
    fileprivate lazy var applyForBtn: UIButton = {
        let applyForBtn = UIButton.init(type: .system)
        applyForBtn.frame = CGRect.init(x: 0, y: 250, width: 150, height: 45)
        applyForBtn.layer.cornerRadius = 5
        applyForBtn.center.x = self.view.center.x
        applyForBtn.backgroundColor = CommonFunction.SystemColor()
        applyForBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        applyForBtn.setTitle("确定", for: .normal)
        applyForBtn.setTitleColor(UIColor.white, for: .normal)
        applyForBtn.addTarget(self, action: #selector(ShopScore.buttonClick), for: .touchUpInside)
        return applyForBtn
    }()
    var shopTitle = ""
    var callBack:((_ score:Int)->Void)?
    fileprivate var isFirt = true
    fileprivate var score = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "店铺评分"
        self.view.backgroundColor = UIColor.white
        shopLable.text = shopTitle
        
        let lable = UILabel.init(frame: CGRect.init(x: 20, y: self.shopLable.frame.maxY + 20, width: 60, height: 20))
        lable.text = "店铺评分:"
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.textColor = UIColor.darkGray
        
        let startView = XHStarRateView.init(frame: CGRect.init(x: lable.frame.maxX + 5, y: lable.frame.minY, width: 150, height: 20), numberOfStars: 5, rateStyle: .WholeStar, isAnination: true) { (Xscore) in
            
            debugPrint(Xscore)
            self.isFirt = false
            self.score = Int(Xscore) 
        }
        self.view.addSubview(shopLable)
        self.view.addSubview(lable)
        self.view.addSubview(startView!)
        self.view.addSubview(applyForBtn)
    }
    func buttonClick() -> Void {
        if isFirt == true {
            CommonFunction.HUD("请给店铺一个评分", type: .error)
            return
        }
        if callBack != nil {
            callBack!(score)
            self.navigationController?.popViewController(animated: true)
        }
    }
    deinit {
        debugPrint("我已销毁")
    }

}
