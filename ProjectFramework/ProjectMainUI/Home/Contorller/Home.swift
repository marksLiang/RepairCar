//
//  Home.swift
//  RepairCar
//
//  Created by 住朋购友 on 2017/7/14.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class Home: UIViewController {
    /********************  属性  ********************/
    fileprivate let disposeBag   = DisposeBag()//处理包通道
    
    /********************  懒加载  ********************/
    //自定义导航栏
    fileprivate lazy var navgationBar: UIView = {
        let navgationBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: CommonFunction.NavigationControllerHeight))
        navgationBar.backgroundColor = CommonFunction.SystemColor()
        let lable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 20))
        lable.center.x = navgationBar.center.x
        lable.center.y = navgationBar.center.y + 10
        lable.text = "首页"
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textColor = UIColor.white
        navgationBar.addSubview(lable)
        navgationBar.layer.insertSublayer(CommonFunction.gradientLayer(), at: 0)
        return navgationBar
    }()
    //城市选择按钮
    fileprivate lazy var cityBtn: ZPButton = {
        let cityBtn = ZPButton.init(type: .custom)
        cityBtn.frame = CGRect.init(x: 0, y: 30, width: 80, height: 30)
        cityBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cityBtn.setImage(UIImage.init(named: "arrow_down"), for: .normal)
        cityBtn.setTitle("南宁市", for: .normal)
        cityBtn.rx.tap.subscribe(
            onNext:{ [weak self] value in
            print("选择城市")
        }).addDisposableTo(self.disposeBag)
        return cityBtn
    }()
    fileprivate lazy var releaseBtn: UIButton = {
        let release = UIButton.init(frame: CGRect.init(x: CommonFunction.kScreenWidth - 70, y: 30, width: 60, height: 30))
        release.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        release.setTitle("发布需求", for: .normal)
        release.setTitleColor(UIColor.white, for: .normal)
        release.rx.tap.subscribe(
            onNext:{ [weak self] value in
             print("发布需求")
        }).addDisposableTo(self.disposeBag)
        return release
    }()
    //MARK: viewload
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavgationBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: setNavgationBar
    private func setNavgationBar() -> Void {
        self.view.addSubview(navgationBar)
        self.navgationBar.addSubview(cityBtn)
        self.navgationBar.addSubview(releaseBtn)
        
    }

}
