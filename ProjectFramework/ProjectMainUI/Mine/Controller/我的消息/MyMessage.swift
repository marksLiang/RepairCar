//
//  MyMessage.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/9/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class MyMessage: CustomTemplateViewController {
    /********************  XIB  ********************/
    @IBOutlet weak var tableView: UITableView!
    /********************  属性  ********************/
    fileprivate let identifier    = "MyMessageCell"
    fileprivate var viewModel     = MessageViewModel()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的消息"
        self.getHttpData()
        self.initUI()
        
    }
    override func headerRefresh() {
        self.numberOfSections = 0
        self.numberOfRowsInSection = 0
        self.RefreshRequest(isLoading: true)
        self.getHttpData()
    }
    override func Error_Click() {
        self.RefreshRequest(isLoading: true)
        self.getHttpData()
    }
    //MARK: 获取数据
    private func getHttpData()->Void{
        viewModel.GetSystemNotification(UserID: Global_UserInfo.UserID) { (result) in
            self.header.endRefreshing()
            self.footer.endRefreshing()
            if result == true {
                self.numberOfSections = 1
                self.numberOfRowsInSection = 10
                self.RefreshRequest(isLoading: false, isHiddenFooter: true)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    //MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyMessageCell
        //cell.InitConfig(model)
        return cell
    }
    //MARK: initUI
    private func initUI()->Void{
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: self.view.frame.width, height: CommonFunction.kScreenHeight - CommonFunction.NavigationControllerHeight)
        self.tableViewheightForRowAt = 50
    }
}
