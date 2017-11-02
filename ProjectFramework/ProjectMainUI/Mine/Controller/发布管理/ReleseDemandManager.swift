//
//  ReleseDemandManager.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/16.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ReleseDemandManager: CustomTemplateViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate let identifier   = "ReleseDemandListCell"
    fileprivate var viewModel = MyReleseViewModel()
    fileprivate var PageIndex = 1
    fileprivate var PageSize = 10
    fileprivate var DemandType = 0
    fileprivate lazy var buttonBar: LYFButtonBar = {
        let buttonBar = LYFButtonBar.init(frame: CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: 40), textArray:["全部","进行中","已完结"], Callback_SelectedValue: { [weak self](buttontag) in
            
            if self?.DemandType != buttontag {
                self?.PageIndex = 1
                self?.DemandType = buttontag
                self?.numberOfRowsInSection = 0
                self?.viewModel.ListData.removeAll()
                self?.RefreshRequest(isLoading: true, isHiddenFooter: true)
                self?.getHttpData()
            }
        })
        return buttonBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布管理"
        self.getHttpData()
        self.initUI()
        
    }
    override func headerRefresh() {
        PageIndex = 1
        self.footer.resetNoMoreData()
        self.getHttpData()
    }
    override func footerRefresh() {
        PageIndex = PageIndex + 1
        self.getHttpData()
    }
    private func getHttpData()->Void{
        viewModel.GetMyDemandInfoList(PageIndex: PageIndex, PageSize: PageSize, UserID: Global_UserInfo.UserID, DemandType: DemandType) { (result, NoMore, Nodata) in
            self.header.endRefreshing()
            self.footer.endRefreshing()
            if result == true {
                if (Nodata==true){
                    debugPrint("没有数据")
                    self.numberOfSections = 0
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
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ReleseDemandListCell
        cell.InitConfig(self.viewModel.ListData[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CommonFunction.ViewControllerWithStoryboardName("DemandDetail", Identifier: "DemandDetail") as! DemandDetail
        vc.DemandID = self.viewModel.ListData[indexPath.row].DemandID
        vc.isMyrelese = true
        vc.ReleaseType = self.viewModel.ListData[indexPath.row].ReleaseType
        self.navigationController?.show(vc, sender: self)
    }
    //MARK: initUI
    private func initUI() -> Void{
        self.view.addSubview(buttonBar)
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight+40, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight-40)
        self.tableViewheightForRowAt = 85
    }
    


}
