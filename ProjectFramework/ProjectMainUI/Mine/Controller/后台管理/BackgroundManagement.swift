//
//  BackgroundManagement.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/6.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BackgroundManagement: CustomTemplateViewController {
    //城市选择按钮
    fileprivate lazy var cityBtn: ZPButton = {
        let cityBtn = ZPButton.init(type: .custom)
        cityBtn.frame = CGRect.init(x: 0, y: 0, width: 80, height: 30)
        cityBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cityBtn.setImage(UIImage.init(named: "arrow_down"), for: .normal)
        cityBtn.setTitle(self.cityName, for: .normal)
        cityBtn.rx.tap.subscribe(
            onNext:{ [weak self] value in
                self?.pushCityList()
        }).addDisposableTo(self.disposeBag)
        return cityBtn
    }()
    fileprivate lazy var sectionView: UIView = {
       let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 35))
        sectionView.backgroundColor = UIColor.white
        return sectionView
    }()
    fileprivate lazy var lable: UILabel = {
        let lable = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: 280, height: 20))
        lable.center.y = self.sectionView.center.y
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        lable.textColor = CommonFunction.SystemColor()
        return lable
    }()
    @IBOutlet weak var tableView: UITableView!
    var isProvinceSelece = false
    fileprivate var cityName = Global_UserInfo.cityName
    fileprivate var viewModel = BackgroundViewModel()
    fileprivate let disposeBag   = DisposeBag()//处理包通道
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getHttpData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "后台管理"
        self.initUI()
        //self.getHttpData()
    }
    override func headerRefresh() {
        self.getHttpData()
    }
    override func Error_Click() {
        self.getHttpData()
    }
    //MARK: 跳转开通城市
    private func pushCityList() -> Void{
        switch Global_UserInfo.UserType {
        case 5:
            let vc = CommonFunction.ViewControllerWithStoryboardName("CityList", Identifier: "CityList") as! CityList
            vc.currentCityName = Global_UserInfo.cityName
            vc.Callback_SelectedValue {[weak self] (selectCity) in
                self?.cityName = selectCity
                self?.cityBtn.setTitle(selectCity, for: .normal)
                self?.RefreshRequest(isLoading: true, isHiddenFooter: true, isLoadError: true)
                self?.getHttpData()
            }
            self.navigationController?.show(vc, sender: self)
            break;
        case 4:
            let vc = BackgroudCityList()
            vc.Callback_SelectedValue({[weak self] (selectCity) in
                self?.cityName = selectCity
                self?.cityBtn.setTitle(selectCity, for: .normal)
                self?.RefreshRequest(isLoading: true, isHiddenFooter: true, isLoadError: true)
                self?.getHttpData()
            })
            self.navigationController?.show(vc, sender: self)
            break;
        default:
            break;
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopBackgroundCell", for: indexPath) as! ShopBackgroundCell
        cell.InitConfig(self.viewModel.ListData.MaintenanceInfoList![indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CommonFunction.ViewControllerWithStoryboardName("AuditShop", Identifier: "AuditShop") as! AuditShop
        vc.MaintenanceID = self.viewModel.ListData.MaintenanceInfoList![indexPath.row].MaintenanceID
        self.navigationController?.show(vc, sender: self)
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
        
        viewModel.GetAdminHome(CityName: cityName, UserID: Global_UserInfo.UserID, isProvinceSelece: isProvinceSelece) { (result) in
            self.header.endRefreshing()
            if result == true {
                self.numberOfSections = 1
                self.numberOfRowsInSection = self.viewModel.ListData.MaintenanceInfoList?.count ?? 0
                self.lable.text = "\(self.cityName)  新增店铺申请列表(\(self.viewModel.ListData.AddMaintenanceCount)个)"
                self.RefreshRequest(isLoading: false, isHiddenFooter: true)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    private func initUI()->Void{
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.cityBtn)
        self.sectionView.addSubview(lable)
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight)
        self.tableViewheightForRowAt = 44
        
    }

}
