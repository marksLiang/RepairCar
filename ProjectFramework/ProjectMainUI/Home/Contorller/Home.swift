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
class Home: CustomTemplateViewController ,SDCycleScrollViewDelegate{
    /********************  xib控件  ********************/
    @IBOutlet weak var tableView: UITableView!
    
    /********************  属性  ********************/
    fileprivate let identifier   = "RepairShopCell"
    fileprivate let disposeBag   = DisposeBag()//处理包通道
    fileprivate let imagesURLStrings = ["https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                         "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                          "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"]
    
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
    //发布按钮
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
    //tableView头部
    fileprivate lazy var headerView: HomeHeaderView = {
        let headerView = HomeHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 290))
        return headerView
    }()
    //轮播图
    fileprivate lazy var shuffling: SDCycleScrollView = {
        let shuffling = SDCycleScrollView(frame:CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 150),delegate:self ,placeholderImage:UIImage.init(named: "placeholder"))
        shuffling?.currentPageDotImage = UIImage.init(named: "pageControlCurrentDot")
        shuffling?.pageDotImage = UIImage.init(named: "pageControlDot")
        shuffling?.imageURLStringsGroup = self.imagesURLStrings
        return shuffling!
    }()
    fileprivate lazy var model: RepairShopModel = {
        let model = RepairShopModel()
        model.Score = 5
        model.tabs = ["电器类","机修类","门窗类","轮胎类","冷工类","装饰类","油类","焊类"]
        return model
    }()
    
    //MARK: viewload
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavgationBar()
        self.initUI()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    //MARK: 轮播图代理
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print("我点击了第\(index)张")
    }
    //MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return model.tabs.count > 3 ? 130: 90
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RepairShopCell
        cell.InitConfig(model)
        return cell
    }
    //MARK: initUI
    private func initUI() -> Void {
        self.headerView.addSubview(shuffling)
        
        let requesterNib = UINib(nibName: "RepairShopCell", bundle: nil)
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight - 64 - 49)
        self.tableView.register(requesterNib, forCellReuseIdentifier: identifier)
        self.tableView.tableHeaderView = headerView
        self.numberOfSections = 1
        self.numberOfRowsInSection = 10
        
    }
    //MARK: setNavgationBar
    private func setNavgationBar() -> Void {
        self.view.addSubview(navgationBar)
        self.navgationBar.addSubview(cityBtn)
        self.navgationBar.addSubview(releaseBtn)
        
    }
    
    
}
