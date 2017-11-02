//
//  MyShop.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/2.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit


class MyShop: CustomTemplateViewController {
    var isHaveShop = false      //是否有店铺  否就填数据  是就请求数据填充
    fileprivate  var isEndRefresh = false  //是否结束刷新  刷新数据
    fileprivate let ketArray = ["店面名称","店面地址","联系号码","店面面积","所属城市","维修类型"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "申请店铺"
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isHaveShop ? (isEndRefresh ? 1 : 0) : 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isHaveShop ? (isEndRefresh ? ketArray.count + 2 : 0) : ketArray.count + 2
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 5 {
            return 50
        }
        if indexPath.row == 6 {
            return 70
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 5 {
            
        }
        if indexPath.row == 6 {
            
        }
        return UITableViewCell()
    }
    private func initUI()->Void{
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight)
        self.tableView.backgroundColor = UIColor().TransferStringToColor("#EEEEEE")
        self.header.isHidden = true
        //还不是店铺的情况
        if isHaveShop == false {
            self.RefreshRequest(isLoading: false, isHiddenFooter: true)
        }
    }
}
