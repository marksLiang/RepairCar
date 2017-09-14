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
class Home: CustomTemplateViewController ,SDCycleScrollViewDelegate , CLLocationManagerDelegate{
    /********************  xib控件  ********************/
    @IBOutlet weak var tableView: UITableView!
    
    /********************  属性  ********************/
    fileprivate let identifier   = "RepairShopCell"
    fileprivate var mgr: CLLocationManager?=nil
    fileprivate let disposeBag   = DisposeBag()//处理包通道
    fileprivate var viewModel    = HomeViewModel()
    fileprivate var aViewModel   = AdvertisingViewModel()
    fileprivate var imagesURLStrings = [String]()
    fileprivate var currenModel: RepairShopModel?=nil
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
        cityBtn.rx.tap.subscribe(
            onNext:{ [weak self] value in
                let vc = CommonFunction.ViewControllerWithStoryboardName("CityList", Identifier: "CityList") as! CityList
                vc.currentCityName = CurrentCity
                vc.Callback_SelectedValue {[weak self] (selectCity) in
                    CurrentCity = selectCity
                    cityBtn.setTitle(selectCity, for: .normal)
                }
                self?.navigationController?.show(vc, sender: self)
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
                CommonFunction.HUD("此功能程序员正在编写，请耐心等待。。。。", type: .error)
        }).addDisposableTo(self.disposeBag)
        return release
    }()
    //tableView头部
    fileprivate lazy var headerView: HomeHeaderView = {
        let headerView = HomeHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 290))
        headerView.isHidden = true
        headerView.FuncCallbackValue {[weak self] (tag) in
            if tag == 1 {
                let vc = ShopList()
                self?.navigationController?.show(vc, sender: self)
            }else{
                let vc = CommonFunction.ViewControllerWithStoryboardName("DemandList", Identifier: "DemandList") as! DemandList
                self?.navigationController?.show(vc, sender: self)
            }
        }
        return headerView
    }()
    //轮播图
    fileprivate lazy var shuffling: SDCycleScrollView = {
        let shuffling = SDCycleScrollView(frame:CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 150),delegate:self ,placeholderImage:UIImage.init(named: "placeholder"))
        shuffling?.currentPageDotImage = UIImage.init(named: "pageControlCurrentDot")
        shuffling?.pageDotImage = UIImage.init(named: "pageControlDot")
        return shuffling!
    }()
    //店铺预览
    fileprivate lazy var pview: ShopPreview = {
        let pview = ShopPreview.init(frame: CGRect.init(x: 0, y:  0, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight), model: self.currenModel!)
        return pview
    }()
    //MARK: viewload
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.position()
        self.setNavgationBar()
        self.initUI()
        pview.FuncCallbackValue {[weak self] (tag) in
            CommonFunction.isLogin(taget: self!, loginResult: { (result) in
                
            }, normal: {
                self?.GetMaintenanceDetailsIsPay()
            })
        }
        
    }
    private func push() -> Void{
        
    }
    //MARK: 支付----》查看店铺
    private func GetMaintenanceDetailsIsPay() -> Void{
        print(self.currenModel!.MaintenanceID)
        viewModel.GetMaintenanceDetailsIsPay(MaintenanceID: self.currenModel!.MaintenanceID, UserID: Global_UserInfo.UserID) { (result) in
            if result == true {
                self.payFor()
            }else{
                self.hiddenPview()
                let vc = CommonFunction.ViewControllerWithStoryboardName("ShopDetail", Identifier: "ShopDetail") as! ShopDetail
                vc.model = self.currenModel
                self.navigationController?.show(vc, sender: self)
            }
        }
    }
    private func payFor() -> Void{
        CommonFunction.AlertController(self, title: "查看店铺详情", message: "需要支付3元，是否支付？", ok_name: "确定", cancel_name: "取消", OK_Callback: {
//            let vc = PayClass.init(OrderType:1,delegate: self)
//            vc.OtherID = self.currenModel!.MaintenanceID
//            self.present(vc, animated: true, completion: {
//                self.hiddenPview()
//            })
//            self.hiddenPview()
//            let vc = CommonFunction.ViewControllerWithStoryboardName("ShopDetail", Identifier: "ShopDetail") as! ShopDetail
//            vc.model = self.currenModel
//            self.show(vc, sender: self)
            if self.currenModel!.MaintenanceID == 2 {
                let vc = PayClass.init(OrderType:1,delegate: self)
                vc.OtherID = self.currenModel!.MaintenanceID
                vc.model = self.currenModel
                self.present(vc, animated: true, completion: {
                    self.hiddenPview()
                })
            }else{
                self.hiddenPview()
                let vc = CommonFunction.ViewControllerWithStoryboardName("ShopDetail", Identifier: "ShopDetail") as! ShopDetail
                vc.model = self.currenModel
                self.navigationController?.show(vc, sender: self)
            }
        }, Cancel_Callback: {
            
        })
    }
    override func headerRefresh() {
        self.imagesURLStrings.removeAll()
        self.GetAdvertising()
    }
    override func Error_Click() {
        self.imagesURLStrings.removeAll()
        self.GetAdvertising()
    }
    private func GetAdvertising() -> Void{
        aViewModel.GetAdvList(CityName: CurrentCity, AdvType: 0) { (result) in
            if result == true {
                for i in 0..<self.aViewModel.ListData.count{
                    self.imagesURLStrings.append(self.aViewModel.ListData[i].ImgPath)
                }
                self.GetHttp()
            }else{
                CommonFunction.HUD("网络异常", type: .error)
            }
        }
    }
    private func GetHttp() -> Void{
        viewModel.GetHomeMaintenanceInfo(CityName: CurrentCity, Longitude: "", Latitude: "") { (result) in
            self.header.endRefreshing()
            self.footer.endRefreshing()
            if result == true {
                self.shuffling.imageURLStringsGroup = self.imagesURLStrings
                self.numberOfSections = 1
                self.numberOfRowsInSection = self.viewModel.ListData.count
                self.headerView.isHidden = false
                self.RefreshRequest(isLoading: false, isHiddenFooter: true)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    //MARK: 获取地理位置信息
    private func position() -> Void{
        mgr = CLLocationManager()
        mgr?.delegate = self
        mgr?.startUpdatingLocation()
        if (mgr?.responds(to: #selector(mgr?.requestWhenInUseAuthorization)))! {
            mgr?.requestWhenInUseAuthorization()
        }
        
    }
    var isFrist = true //只允许执行一次
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(locations.last!) { (placemarks, error) in
            if placemarks?.count == 0 || (error != nil) {
                return
            }
            let pm = placemarks?.first!
            if ((pm?.locality) != nil) {
                if self.isFrist == true {
                    print(locations.last!.coordinate.latitude , locations.last!.coordinate.longitude ,(pm?.locality)!)
                    CurrentCity = (pm?.locality)!
                    self.cityBtn.setTitle((pm?.locality)!, for: .normal)
                    self.isFrist = false
                    
                    //MARK: 定位完获取数据
                    self.GetAdvertising()
                }
            }
        }
        
    }
    //MARK: 轮播图代理
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        //点击跳转到广告详情、是h5地址
        let vc = AdvertisingWeb()
        vc.urlString = self.aViewModel.ListData[index].JumpURL
        self.navigationController?.show(vc, sender: self)
    }
    //MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var tepyArray = [String]()
        if self.viewModel.ListData[indexPath.row].TypeNames != "" {
            tepyArray = self.viewModel.ListData[indexPath.row].TypeNames.components(separatedBy: ",")
            tepyArray.removeLast()
        }
        return  tepyArray.count > 3 ? 130 : 90
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RepairShopCell
        cell.InitConfig(self.viewModel.ListData[indexPath.row])
        if self.viewModel.ListData[indexPath.row].IsTop == true {
//            cell.atTop()
        }
        return cell
    }
    var isfirstClick = true
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.currenModel = self.viewModel.ListData[indexPath.row]
            self.pview.setModel(self.viewModel.ListData[indexPath.row])
            if self.isfirstClick == true {
                CommonFunction.RootView?.addSubview(self.pview)
                self.isfirstClick = false
            }else{
                self.shouPview()
            }

    }
    private func shouPview() -> Void{
        UIView.animate(withDuration: 0.5, animations: {
            self.pview.frame = CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight)
        })
    }
    private func hiddenPview() -> Void{
        UIView.animate(withDuration: 0.5, animations: {
            self.pview.frame = CGRect.init(x: 0, y: CommonFunction.kScreenHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight)
        })
    }
    //MARK: initUI
    private func initUI() -> Void {
        self.headerView.addSubview(shuffling)
        
        let requesterNib = UINib(nibName: "RepairShopCell", bundle: nil)
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight - 64 - 49)
        self.tableView.register(requesterNib, forCellReuseIdentifier: identifier)
        self.tableView.tableHeaderView = headerView
        
    }
    //MARK: setNavgationBar
    private func setNavgationBar() -> Void {
        self.view.addSubview(navgationBar)
        self.navgationBar.addSubview(cityBtn)
        self.navgationBar.addSubview(releaseBtn)
        
    }
    
    
}
