//
//  News.swift
//  RepairCar
//
//  Created by 住朋购友 on 2017/7/14.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class News: CustomTemplateViewController {
    
    /********************  XIB  ********************/
    @IBOutlet weak var tableView: UITableView!
    /********************  属性  ********************/
    fileprivate let identifier    = "NewsCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NewsCell
        //cell.InitConfig(model)
        return cell
    }
    //MARK: initUI
    private func initUI()->Void{
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: 64, width: self.view.frame.width, height: CommonFunction.kScreenHeight - 64)
        self.tableViewheightForRowAt = 80
        self.numberOfSections = 1
        self.numberOfRowsInSection = 10
    }

}
