//
//  BackgroundManagement.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/6.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class BackgroundManagement: CustomTemplateViewController {
    fileprivate lazy var sectionView: UIView = {
       let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 35))
        sectionView.backgroundColor = UIColor.white
        return sectionView
    }()
    fileprivate lazy var lable: UILabel = {
        let lable = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: 200, height: 20))
        lable.center.y = self.sectionView.center.y
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        lable.textColor = CommonFunction.SystemColor()
        return lable
    }()
    @IBOutlet weak var tableView: UITableView!
    var isProvinceSelece = false
    fileprivate var viewModel = BackgroundViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "后台管理"
        self.initUI()
        self.getHttpData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopBackgroundCell", for: indexPath) as! ShopBackgroundCell
        cell.InitConfig(self.viewModel.ListData.MaintenanceInfoList![indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.viewModel.ListData.MaintenanceInfoList!.count > 0 {
            return sectionView
        }else{
            return UIView()
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.viewModel.ListData.MaintenanceInfoList!.count > 0 {
            return 35
        }else{
            return 0
        }
    }
    private func getHttpData()->Void{
        
        viewModel.GetAdminHome(CityName: Global_UserInfo.cityName, UserID: Global_UserInfo.UserID, isProvinceSelece: isProvinceSelece) { (result) in
            if result == true {
                self.numberOfSections = 1
                self.numberOfRowsInSection = self.viewModel.ListData.MaintenanceInfoList?.count ?? 0
                self.lable.text = "新增店主申请店铺列表(\(self.viewModel.ListData.AddMaintenanceCount)个)"
                self.RefreshRequest(isLoading: false, isHiddenFooter: true)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    private func initUI()->Void{
        self.sectionView.addSubview(lable)
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight)
        self.tableViewheightForRowAt = 44
        
    }

}
