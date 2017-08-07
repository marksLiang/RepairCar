//
//  DemandList.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/6.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemandList: CustomTemplateViewController,PYSearchViewControllerDelegate {
    /*******************XIB属性*********************/
    @IBOutlet weak var tableView: UITableView!
    fileprivate let identifier   = "DemandListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavbar()
        self.initUI()
    }
    //MARK: tableviewdelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DemandListCell
        if indexPath.row < 2 {
            cell.detailLeading.constant = 15
            cell.detailTraling.constant+=0.5
            cell.mainImage.isHidden = true
        }
        return cell
    }
    private func initUI() -> Void{
        self.InitCongif(tableView)
        self.numberOfSections = 1
        self.numberOfRowsInSection = 10
        self.tableViewheightForRowAt = 85
    }
    //MARK: 设置导航栏
    private func setNavbar() -> Void{
        let CustomNavItem                = self.navigationItem
        CustomNavItem.titleView          = UIButton().SearchBtn(target: self,actionEvent: #selector(SearchEvent), placeholder: "搜索车主需求")
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
