//
//  MySetting.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/9/8.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class MySetting: CustomTemplateViewController {
    /********************  XIB  ********************/
    @IBOutlet weak var tableView: UITableView!
    /********************  属性  ********************/
    fileprivate let identifier    = "MySettingCell"
    fileprivate let textArray     = ["意见反馈","关于我们","清除缓存"]
    fileprivate let imageArray    = ["反馈","关于我们","删除"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.initUI()
    }
    //MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MySettingCell
        cell.leftImage.image = UIImage.init(named: imageArray[indexPath.row])
        cell.titleName.text = textArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    private func initUI()->Void{
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: 64, width: self.view.frame.width, height: CommonFunction.kScreenHeight - 64)
        self.tableView.backgroundColor = UIColor().TransferStringToColor("#F0EBF0")
        self.tableViewheightForRowAt = 50
        self.numberOfSections = 1
        self.numberOfRowsInSection = 3
        self.header.isHidden = true
        self.RefreshRequest(isLoading: false, isHiddenFooter: true)
    }

}
