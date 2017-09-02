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
    fileprivate var Menuview:MenuView?  = nil
    fileprivate var sfitViewModel = SfitViewModel()
    fileprivate var viewModel     = ShopListViewModel()
    /*******************懒加载*********************/
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight + 30, width: CommonFunction.kScreenWidth, height: self.view.frame.height-CommonFunction.NavigationControllerHeight-30), style: .plain)
        return tableView
    }()
    fileprivate lazy var model: RepairShopModel = {
        let model = RepairShopModel()
//        model.Score = 5
//        model.tabs = ["电器类","机修类","门窗类","轮胎类","冷工类","装饰类","油类","焊类"]
        return model
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavbar()
        self.initUI()
        self.GetSiftData()
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
        
    }
    //MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        //return model.tabs.count > 3 ? 130: 90
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RepairShopCell
        cell.InitConfig(model)
        if indexPath.row < 2 {
            cell.atTop()
        }
        return cell
    }
    //MARK: initUI
    private func initUI() -> Void{
        self.view.addSubview(tableView)
        let requesterNib = UINib(nibName: "RepairShopCell", bundle: nil)
        self.InitCongif(tableView)
        self.tableView.register(requesterNib, forCellReuseIdentifier: identifier)
        self.numberOfSections = 1
        self.numberOfRowsInSection = 10
    }
    private func setMeunView() -> Void{
        Menuview=MenuView(delegate: self, frame:  CGRect(x: 0, y: 64, width: self.view.frame.width, height: 30))
        self.view.addSubview(Menuview!)
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
        Menuview?.AddMenuData(model1)
        Menuview?.AddMenuData(model2)
        Menuview?.AddMenuData(model3)
        Menuview?.Callback_SelectedValue { [weak self](name, value,type) in
            print(name,value,type)
        }
        Menuview?.menureloadData()    //刷新菜单 (每次加载完数据后都需要刷新
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
    }
}
