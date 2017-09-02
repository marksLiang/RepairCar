//
//  DemandList.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/6.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemandList: CustomTemplateViewController {
    /*******************XIB属性*********************/
    @IBOutlet weak var tableView: UITableView!
    /*******************属性*********************/
    fileprivate let identifier          = "DemandListCell"
    fileprivate var PageIndex: Int      = 1
    fileprivate var PageSize:  Int      = 10
    fileprivate var viewModel           = DemandListViewModel()
    //MARK: 视图加载
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "车主需求"
        self.initUI()
        self.GetHtpsData()
    }
    override func headerRefresh() {
        PageIndex = 1
        self.footer.resetNoMoreData()
        self.GetHtpsData()
    }
    override func footerRefresh() {
        PageIndex = PageIndex + 1
        self.GetHtpsData()
    }
    override func Error_Click() {
        self.GetHtpsData()
    }
    //MARK: getData
    private func GetHtpsData() -> Void{
        viewModel.GetDemandInfoList(PageIndex: PageIndex, PageSize: PageSize, CityName: "南宁市") { (result, NoMore, NoData) in
            self.header.endRefreshing()
            self.footer.endRefreshing()
            
            if result == true {
                if (NoData==true){
                    self.numberOfSections = 1
                    self.numberOfRowsInSection = 0
                    self.RefreshRequest(isLoading: false, isHiddenFooter: true)
                }
                if(NoMore==true){
                    self.footer.endRefreshingWithNoMoreData()
                    self.RefreshRequest(isLoading: false, isHiddenFooter: false)
                }
                self.numberOfRowsInSection = self.viewModel.ListData.count
                self.numberOfSections=1//显示行数
                //数据小于pagesize
                if self.viewModel.ListData.count < self.PageSize{
                    self.footer.endRefreshingWithNoMoreData()
                }
                self.RefreshRequest(isLoading: false, isHiddenFooter: false)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    //MARK: tableviewdelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DemandListCell
        if self.viewModel.ListData[indexPath.row].Images?.count == 0 {
            cell.hiddenImage()
        }
        cell.InitConfig(self.viewModel.ListData[indexPath.row])
        return cell
    }
    private func initUI() -> Void{
        self.InitCongif(tableView)
        self.tableViewheightForRowAt = 85
    }
    //MARK: 设置导航栏
    private func setNavbar() -> Void{
//        let CustomNavItem                = self.navigationItem
    }


}
