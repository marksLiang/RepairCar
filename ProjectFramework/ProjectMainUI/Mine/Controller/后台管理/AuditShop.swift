//
//  AuditShop.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class AuditShop: CustomTemplateViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var MaintenanceID = 0 //店铺ID
    fileprivate var viewModel = MyShopViewModel()
    fileprivate var isEndRefresh = false  //是否结束刷新  刷新数据
    fileprivate let ketArray = ["店面名称","联系号码","店面面积","所属城市","维修类型","店铺地址","店铺介绍"]
    fileprivate var stringArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "审核店铺"
        self.initUI()
        self.getHttpData()
    }
    private func getHttpData() -> Void{
        viewModel.GetMaintenanceInfoSingle(MaintenanceID: MaintenanceID) { (result) in
            if result == true {
                self.isEndRefresh = true // 结束刷新
                self.stringArray.append(self.viewModel.model.TitleName)
                self.stringArray.append(self.viewModel.model.Phone)
                self.stringArray.append(self.viewModel.model.Area)
                self.stringArray.append(self.viewModel.model.CityName)
                self.stringArray.append(self.viewModel.model.TypeNames)
                self.stringArray.append(self.viewModel.model.Address)
                self.stringArray.append(self.viewModel.model.Introduce)
                self.RefreshRequest(isLoading: false, isHiddenFooter: true)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    private func initUI() -> Void {
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight-50)
        self.tableView.backgroundColor = UIColor().TransferStringToColor("#EEEEEE")
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.header.isHidden = true
        
        for i in 0..<2 {
            let button = UIButton.init(type: .system)
            button.frame = CGRect.init(x: CGFloat(i)*self.view.frame.width/2, y: CommonFunction.kScreenHeight-50, width: self.view.frame.width/2, height: 50)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            button.tag = i
            if i == 0 {
                button.backgroundColor = CommonFunction.SystemColor().withAlphaComponent(0.8)
                button.setTitle("通过", for: .normal)
            }else{
                button.backgroundColor = UIColor.red.withAlphaComponent(0.8)
                button.setTitle("驳回", for: .normal)
            }
            button.addTarget(self, action: #selector(AuditShop.buttonClick(button:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
    }
    func buttonClick(button:UIButton) -> Void {
        debugPrint(button.titleLabel?.text ?? "")
        if button.tag == 0 {
            
        }else{
            
        }
    }
    //MARK: tableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isEndRefresh ? 3 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return stringArray.count
        }
        if section == 1 {
            return self.viewModel.model.LicenseImgs?.count ?? 0
        }else{
            return self.viewModel.model.Images?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 50 : 200
    }
    //组头
    var  sectionTextArray = ["店铺信息","营业执照","店铺图片"]
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if isEndRefresh {
            return UIView().setIntroduceView(height: 40, title: sectionTextArray[section])
        }
        return UIView()
    }
    //组头高
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isEndRefresh ? 40 : 0

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopInfoCell", for: indexPath) as! ShopInfoCell
            cell.titleLable.text = ketArray[indexPath.row]
            cell.detailLable.text = stringArray[indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopImageCell", for: indexPath) as! ShopImageCell
        if indexPath.section == 1 {
            cell.shopImageView.ImageLoad(PostUrl: HttpsUrlImage+self.viewModel.model.LicenseImgs![0].ImgPath)
        }else{
            cell.shopImageView.ImageLoad(PostUrl: HttpsUrlImage+self.viewModel.model.Images![indexPath.row].ImgPath)
        }
        return cell
    }
    
}
