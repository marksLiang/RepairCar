//
//  Mine.swift
//  RepairCar
//
//  Created by 住朋购友 on 2017/7/14.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class Mine: CustomTemplateViewController {
    /********************  xib控件  ********************/
    @IBOutlet weak var tableView: UITableView!
    /********************  属性  ********************/
    fileprivate let identifier   = "MineCell"
    let setion0    = ["发布管理","我是店主","系统通知"]
    let setion1    = ["设置","安全退出"]
    let setion2    = ["后台管理"]
    var titleArray = [[String]]()
    /*******************懒加载*********************/
    fileprivate lazy var headerView: MineHeaderView = {
        let headerView = Bundle.main.loadNibNamed("MineHeaderView", owner: self, options: nil)?.last as! MineHeaderView
        headerView.frame = CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: 150)
        
        return headerView
    }()
    //MARK: viewload
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    override func viewDidLoad() {
        headerView.FuncCallbackValue {[weak self] (text) in
            print("我点击了")
        }
        super.viewDidLoad()
        titleArray.append(setion0)
        titleArray.append(setion1)
        titleArray.append(setion2)
        self.initUI()
    }
    //MARK: tableViewdelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MineCell
        cell.accessoryType = .disclosureIndicator
        cell.mainImage.image = UIImage.init(named: titleArray[indexPath.section][indexPath.row])
        cell.titleLable.text = titleArray[indexPath.section][indexPath.row]
        return cell
    }
    //MARK: initUI
    private func initUI() -> Void {
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight  - 49)
        self.tableView.tableHeaderView = headerView
        self.header.isHidden = true
        self.tableView.backgroundColor = UIColor().TransferStringToColor("#F0EBF0")
        self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: false)
    }
    

}
