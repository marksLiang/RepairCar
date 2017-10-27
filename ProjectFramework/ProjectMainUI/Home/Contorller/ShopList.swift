//
//  ShopList.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/6.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopList: CustomTemplateViewController,PYSearchViewControllerDelegate {
    /********************  属性  ********************/
    fileprivate let identifier    = "RepairShopCell"
    fileprivate var menuview:MenuView?  = nil
    fileprivate var sfitViewModel = SfitViewModel()
    fileprivate var viewModel     = ShopListViewModel()
    fileprivate var HviewModel    = HomeViewModel()
    fileprivate var PageIndex: Int      = 1
    fileprivate var PageSize:  Int      = 10
    fileprivate var SearchName = ""
    fileprivate var MaintenanceTypeName="全部"
    fileprivate var StarRating=0
    fileprivate var Distance=0
    fileprivate var currenModel: RepairShopModel?=nil
    fileprivate var isSearch = false
    /*******************懒加载*********************/
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight + 35, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight-35), style: .plain)
        return tableView
    }()
    //店铺预览
    fileprivate lazy var pview: ShopPreview = {
        let pview = ShopPreview.init(frame: CGRect.init(x: 0, y:  0, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight), model: self.currenModel!)
        return pview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavbar()
        self.initUI()
        self.GetSiftData()
        //MARK: 查看全部
        pview.FuncCallbackValue {[weak self] (tag) in
            CommonFunction.isLogin(taget: self!, loginResult: { (result) in
                
            }, normal: {
                self?.GetMaintenanceDetailsIsPay()
            })
        }
    }
    //MARK: 支付----》查看店铺
    private func GetMaintenanceDetailsIsPay() -> Void{
        print(self.currenModel!.MaintenanceID)
        HviewModel.GetMaintenanceDetailsIsPay(MaintenanceID: self.currenModel!.MaintenanceID, UserID: Global_UserInfo.UserID) { (result) in
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
    //MARK: 上拉&&下拉&&错误
    override func headerRefresh() {
        PageIndex = 0
        self.GetHttp()
    }
    override func footerRefresh() {
        PageIndex += 1
        self.GetHttp()
    }
    override func Error_Click() {
        self.GetHttp()
    }
    //MARK: 重置参数
    private func remexParmeter(isAllRemex:Bool) -> Void{
        if isAllRemex == true {
            PageIndex = 0
            
            MaintenanceTypeName="全部"
            StarRating=0
            Distance=0
            if !isSearch {
                SearchName=""
            }
            isSearch = false
        }
        self.viewModel.ListData.removeAll()
        self.numberOfRowsInSection = 0
        self.RefreshRequest(isLoading: true, isHiddenFooter: true, isLoadError: false)
        self.GetHttp()
    }
    //MARK: 请求数据
    private func GetSiftData() -> Void{
        sfitViewModel.GetScreeningCondition { (result) in
            if result == true {
                self.setMeunView()
                self.GetHttp()
            }else{
                CommonFunction.HUD("请求失败", type: .error)
            }
        }
    }
    private func GetHttp() -> Void{
        viewModel.GetMaintenanceInfo(PageIndex: PageIndex, PageSize: PageSize, CityName: CurrentCity, SearchName: SearchName, MaintenanceTypeName: MaintenanceTypeName, StarRating: StarRating, Longitude: Global_longitude.description, Latitude: Global_latitude.description, Distance: Distance) { (result, noMore, noData) in
            self.header.endRefreshing()
            self.footer.endRefreshing()
            if result == true {
                if noMore == true || self.viewModel.ListData.count < self.PageSize {
                    self.footer.endRefreshingWithNoMoreData()
                }
                self.numberOfSections = 1
                self.numberOfRowsInSection = self.viewModel.ListData.count
                self.RefreshRequest(isLoading: false)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    //MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        //return model.tabs.count > 3 ? 130: 90
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RepairShopCell
        cell.InitConfig(self.viewModel.ListData[indexPath.row])
        if indexPath.row < 2 {
            cell.atTop()
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
    //MARK: 预览View操作
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
    private func initUI() -> Void{
        self.view.addSubview(tableView)
        let requesterNib = UINib(nibName: "RepairShopCell", bundle: nil)
        self.InitCongif(tableView)
        self.tableView.register(requesterNib, forCellReuseIdentifier: identifier)
        self.tableView.layer.borderWidth = 0.5
        self.tableView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor

    }
    private func setMeunView() -> Void{
        menuview=MenuView(delegate: self, frame:  CGRect(x: 0, y: CommonFunction.NavigationControllerHeight, width: self.view.frame.width, height: 35))
        self.view.addSubview(menuview!)
        let model1       = MenuModel()
        for   i:Int in 0  ..< (self.sfitViewModel.ListData.MaintenanceTypeNames?.count)!{
            let onemol   = OneMenuModel()
            onemol.type  = 1
            onemol.name  = self.sfitViewModel.ListData.MaintenanceTypeNames?[i].ShowTitle
            onemol.value = self.sfitViewModel.ListData.MaintenanceTypeNames?[i].ShowTitle
            model1.OneMenu.append(onemol)
        }
        let model2       = MenuModel()
        for   i:Int in 0  ..< (self.sfitViewModel.ListData.StarRating?.count)!{
            let onemol   = OneMenuModel()
            onemol.type  = 2
            onemol.name  = self.sfitViewModel.ListData.StarRating?[i].ShowTitle
            onemol.value = self.sfitViewModel.ListData.StarRating?[i].StarRatingEnum.description
            model2.OneMenu.append(onemol)
        }
        let model3       = MenuModel()
        for   i:Int in 0  ..< (self.sfitViewModel.ListData.Distance?.count)!{
            let onemol   = OneMenuModel()
            onemol.type  = 3
            onemol.name  = self.sfitViewModel.ListData.Distance?[i].ShowTitle
            onemol.value = self.sfitViewModel.ListData.Distance?[i].StarRatingEnum.description
            model3.OneMenu.append(onemol)
        }
        menuview?.AddMenuData(model1)
        menuview?.AddMenuData(model2)
        menuview?.AddMenuData(model3)
        menuview?.Callback_SelectedValue {[weak self] (name, value,type) in
            print(name,value,type)
            switch type {
            case 1:
                self?.MaintenanceTypeName = value
                break;
            case 2:
                self?.StarRating = Int(value)!
                break;
            case 3:
                self?.Distance = Int(value)!
                break;
            default:
                break;
            }
            self?.remexParmeter(isAllRemex: false)
        }
        menuview?.menureloadData()    //刷新菜单 (每次加载完数据后都需要刷新
        
    }
    //MARK: 设置导航栏
    private func setNavbar() -> Void{
        let CustomNavItem                = self.navigationItem
        CustomNavItem.titleView          = UIButton().SearchBtn(target: self,actionEvent: #selector(SearchEvent), placeholder: "搜索维修店")
    }
    //搜索
    func SearchEvent() -> Void{
        let searchViewController                 =   PYSearchViewController(hotSearches: nil, searchBarPlaceholder: "请输入您需要的维修服务")
        searchViewController?.hotSearchStyle     = .default
        searchViewController?.searchHistoryStyle = .normalTag
        searchViewController?.delegate           = self
        let nav =  CYLBaseNavigationController (rootViewController: searchViewController!)
        self.present(nav, animated: false, completion: nil)
    }
    //PYSearchViewControllerDelegate 搜索时调用
    func searchViewController(_ searchViewController: PYSearchViewController!, didSearchWithsearchBar searchBar: UISearchBar!, searchText: String!) {
        print("点击搜索代理")
        self.SearchName = searchText
        self.isSearch = true
        self.remexParmeter(isAllRemex: true)
        searchViewController.dismiss(animated: false, completion: nil)
    }
}
