//
//  BackgroudCityList.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/11/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class BackgroudCityList: CustomTemplateViewController {
    
    //类似于OC中的typedef
    typealias CallbackSelectedValue=(_ cityString:String)->Void
    //声明一个闭包
    var myCallbackValue:CallbackSelectedValue?
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    
    
    fileprivate lazy var tableView: UITableView = {
       let tableView = UITableView.init()
        tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: self.view.frame.width, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight)
        return tableView
    }()
    fileprivate var viewModel = BackgroudCityViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "城市选择"
        self.initUI()
        self.getHttpData()
    }
    override func Error_Click() {
        self.getHttpData()
    }
    private func getHttpData() -> Void{
        viewModel.GetAuthorizationCityListAdmin { (result) in
            if result == true {
                self.numberOfSections = 1
                self.numberOfRowsInSection = self.viewModel.ListData.count
                self.RefreshRequest(isLoading: false, isHiddenFooter: true)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.text = self.viewModel.ListData[indexPath.row].CityName
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if myCallbackValue != nil {
            myCallbackValue!(self.viewModel.ListData[indexPath.row].CityName)
        }
        self.navigationController?.popViewController(animated: true)
    }
    private func initUI()->Void{
        self.view.addSubview(tableView)
        self.InitCongif(tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableViewheightForRowAt = 44
        self.header.isHidden = true
    }
    
}
