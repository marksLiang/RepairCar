//
//  ShopBrowse.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/11/9.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopBrowse: CustomTemplateViewController {
    fileprivate lazy var buttonBar: LYFButtonBar = {
        let buttonBar = LYFButtonBar.init(frame: CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: 40), textArray:["全部","已评价","未评价"], Callback_SelectedValue: { [weak self](buttontag) in
            self?.PageIndex = 1
            self?.type = buttontag
            self?.numberOfRowsInSection = 0
            self?.viewModel.ListData.removeAll()
            self?.RefreshRequest(isLoading: true, isHiddenFooter: true)
            self?.getHttpData()
        })
        return buttonBar
    }()
    fileprivate var viewModel = ShopBrowseViewModel()
    fileprivate var PageIndex = 1
    fileprivate var PageSize = 10
    fileprivate var type = 0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "店铺浏览"
        self.initUI()
        self.getHttpData()
    }
    //MARK: 获取数据
    func getHttpData() -> Void {
        viewModel.GetMyOrderInfo(PageIndex: PageIndex, PageSize: PageSize, UserID: Global_UserInfo.UserID, Type: type) { (result, NoMore, Nodata) in
            if result == true {
                if (Nodata==true){
                    debugPrint("没有数据")
                    self.numberOfSections = 0
                    self.numberOfRowsInSection = 0
                    self.RefreshRequest(isLoading: false, isHiddenFooter: true)
                }
                if(NoMore==true){
                    self.footer.endRefreshingWithNoMoreData()
                    self.RefreshRequest(isLoading: false, isHiddenFooter: false)
                }
                self.numberOfRowsInSection = self.viewModel.ListData.count
                self.numberOfSections=1//显示行数
                //数据小于pagesize
                if self.viewModel.ListData.count < self.PageSize{
                    self.footer.endRefreshingWithNoMoreData()
                }
                self.RefreshRequest(isLoading: false, isHiddenFooter: false)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    //MARK: tableviewdelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopBrowseCell", for: indexPath) as! ShopBrowseCell
        cell.shopImageView.ImageLoad(PostUrl: HttpsUrlImage+self.viewModel.ListData[indexPath.row].Images![0].ImgPath)
        cell.shopTitle.text = self.viewModel.ListData[indexPath.row].TitleName
        cell.createDateLable.text = self.viewModel.ListData[indexPath.row].CreateTime
        cell.shopTypeLable.text = self.viewModel.ListData[indexPath.row].TypeNames
        cell.priceLable.text = "¥:"+self.viewModel.ListData[indexPath.row].DealPrice
        if self.viewModel.ListData[indexPath.row].IsScore == false {
            cell.stateBtn.isUserInteractionEnabled = true
            cell.stateBtn.setTitle("未评分", for: .normal)
            cell.myCallbackValue = {
                debugPrint("我去评分了")
            }
        }else{
            cell.stateBtn.isUserInteractionEnabled = false
            cell.stateBtn.setTitle("已评分", for: .normal)
        }
        return cell
    }
    //MARK: initUI
    private func initUI()->Void{
        self.view.addSubview(buttonBar)
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight)
        self.tableViewheightForRowAt = 100
        
    }

}
