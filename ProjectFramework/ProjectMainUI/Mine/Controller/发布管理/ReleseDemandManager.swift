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
    
    fileprivate lazy var buttonBar: LYFButtonBar = {
        let buttonBar = LYFButtonBar.init(frame: CGRect.init(x: 0, y: 64, width: CommonFunction.kScreenWidth, height: 40), textArray:["全部","进行中","已完结"], Callback_SelectedValue: { [weak self](buttontag) in
            
        })
        return buttonBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布管理"
        self.initUI()
    }
    //MARK: tableviewdelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ReleseDemandListCell
        if indexPath.row < 2 {
            cell.detailLeading.constant = 15
            cell.mainImage.isHidden = true
            cell.state.text = "已完结"
            cell.state.textColor = UIColor.red
        }else{
            cell.state.text = "正在进行中"
            cell.state.textColor = UIColor.green
        }
        return cell
    }
    //MARK: initUI
    private func initUI() -> Void{
        self.view.addSubview(buttonBar)
        self.InitCongif(tableView)
        self.numberOfSections = 1
        self.numberOfRowsInSection = 10
        self.tableViewheightForRowAt = 85
    }
    


}
