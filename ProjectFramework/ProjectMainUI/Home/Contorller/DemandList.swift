//
//  DemandList.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/6.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DemandList: CustomTemplateViewController {
    //发布按钮
    fileprivate lazy var releaseBtn: UIButton = {
        let release = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 30))
        release.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        release.setTitle("发布需求", for: .normal)
        release.setTitleColor(UIColor.white, for: .normal)
        release.rx.tap.subscribe(
            onNext:{ [weak self] value in
                print("发布需求")
                let vc = CommonFunction.ViewControllerWithStoryboardName("PostedDemand", Identifier: "PostedDemand") as! PostedDemand
                self?.navigationController?.show(vc, sender: self)
        }).addDisposableTo(self.disposeBag)
        return release
    }()
    /*******************XIB属性*********************/
    @IBOutlet weak var tableView: UITableView!
    /*******************属性*********************/
    fileprivate let identifier          = "DemandListCell"
    fileprivate var PageIndex: Int      = 1
    fileprivate var PageSize:  Int      = 10
    fileprivate var viewModel           = DemandListViewModel()
    fileprivate let disposeBag   = DisposeBag()//处理包通道
    //MARK: 视图加载
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "车主需求"
        self.setNavbar()
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CommonFunction.ViewControllerWithStoryboardName("DemandDetail", Identifier: "DemandDetail") as! DemandDetail
        vc.DemandID = self.viewModel.ListData[indexPath.row].DemandID
        self.navigationController?.show(vc, sender: self)
    }
    private func initUI() -> Void{
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight - CommonFunction.NavigationControllerHeight)
        self.tableViewheightForRowAt = 85
    }
    //MARK: 设置导航栏
    private func setNavbar() -> Void{
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: releaseBtn)
    }


}
