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
    var setion1    = ["设置"]
    let setion2    = ["后台管理"]
    var titleArray = [[String]]()
    var isfirt     = true
    /*******************懒加载*********************/
    fileprivate lazy var headerView: MineHeaderView = {
        let headerView = Bundle.main.loadNibNamed("MineHeaderView", owner: self, options: nil)?.last as! MineHeaderView
        headerView.frame = CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: 150)
        headerView.FuncCallbackValue {[weak self] (text) in
            print("我点击了")
            CommonFunction.isLogin(taget: self!, loginResult: { (login) in
                if login == true {
                    self!.getData()
                }
            }) {
                let vc = CommonFunction.ViewControllerWithStoryboardName("Myinfo", Identifier: "Myinfo") as! MyInfoViewController
                self?.navigationController?.show(vc, sender: nil)
            }
        }
        return headerView
    }()
    //MARK: viewload
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        headerView.setData()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getData()
        self.initUI()
    }
    private func getData() -> Void{
        if Global_UserInfo.IsLogin == false {
            titleArray.append(setion0)
            titleArray.append(setion1)
        }else{
            setion1.append("安全退出")
            titleArray.append(setion0)
            titleArray.append(setion1)
            if Global_UserInfo.UserType == 2 || Global_UserInfo.UserType == 3 {
                titleArray.append(setion2)
            }
        }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = titleArray[indexPath.section][indexPath.row]
        switch str {
        case "发布管理":
            let vc = CommonFunction.ViewControllerWithStoryboardName("ReleseDemandManager", Identifier: "ReleseDemandManager") as! ReleseDemandManager
            self.navigationController?.show(vc, sender: nil)
            break
        case "我是店主":
            break
        case "安全退出":
            CommonFunction.AlertController(self, title: "注销", message: "确定注销该账户吗？", ok_name: "确定", cancel_name: "取消", style: .alert, OK_Callback: {
                
                self.tableView.reloadData()
            }, Cancel_Callback: {
                
            })
            break
        default:
            break
        }
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
