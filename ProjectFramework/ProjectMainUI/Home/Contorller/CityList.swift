//
//  CityList.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/7/21.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit


class CityList: UIViewController ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    //类似于OC中的typedef
    typealias CallbackSelectedValue=(_ cityString:String)->Void
    //声明一个闭包
    var myCallbackValue:CallbackSelectedValue?
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    /*******************属性*********************/
    var textArray   = [String]()
    var dataArray   = [[String]]()
    var searchArray = [String]()
    /*******************懒加载*********************/
    fileprivate lazy var searchBase: UIView = {
        let searchBase = UIView.init(frame: CGRect.init(x: 0, y: 64, width: CommonFunction.kScreenWidth, height: 45))
        searchBase.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return searchBase
    }()
    fileprivate lazy var searchTextFiled: UITextField = {
        let searchTextFiled = UITextField.init(frame: CGRect.init(x: 10, y: 7.5, width: CommonFunction.kScreenWidth - 20, height: 30))
        searchTextFiled.backgroundColor = UIColor.white
        searchTextFiled.placeholder = "请输入城市名"
        searchTextFiled.font = UIFont.systemFont(ofSize: 13)
        searchTextFiled.tintColor = UIColor.gray
        searchTextFiled.layer.cornerRadius = 5
        searchTextFiled.textColor = UIColor.black
        searchTextFiled.delegate = self
        let imageview = UIImageView.init(frame: CGRect.init(x: 12.5, y: 0, width: 18, height: 18))
        imageview.image = UIImage.init(named: "搜索")
        imageview.contentMode = .scaleAspectFill
        let searchview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 18))
        searchview.addSubview(imageview)
        searchTextFiled.leftView = searchview
        searchTextFiled.leftViewMode = .always
        searchTextFiled.addTarget(self, action: #selector(textChange), for: .editingChanged)
        return searchTextFiled
    }()
    //取消按钮
    fileprivate lazy var cancleBtn: UIButton = {
        let cancleBtn = UIButton.init(type: .system)
        cancleBtn.frame = CGRect.init(x: CommonFunction.kScreenWidth - 50, y: 7.5, width: 50, height: 30)
        cancleBtn.isHidden = true
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancleBtn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return cancleBtn
    }()
    //tableview
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 64 + 45, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight - 64 - 45), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择城市"
        // Do any additional setup after loading the view.
        textArray = ["定","A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","W","X","Y","Z"]
        self.initUI()
        self.getCityData()
        
    }
    //屏幕点击
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func buttonClick() -> Void {
        self.view.endEditing(true)
    }
    //MARK: UI效果
    private func changeUI() -> Void{
        searchTextFiled.frame = CGRect.init(x: searchTextFiled.frame.minX, y: searchTextFiled.frame.minY, width: CommonFunction.kScreenWidth - 60, height: 30)
        cancleBtn.isHidden = false
    }
    private func restoreUI() -> Void{
        UIView.animate(withDuration: 0.3, animations: {
            self.searchTextFiled.frame = CGRect.init(x: self.searchTextFiled.frame.minX, y: self.searchTextFiled.frame.minY, width: CommonFunction.kScreenWidth - 20, height: 30)
            self.cancleBtn.isHidden = true
        })
    }
    func textChange(_ textFeild: UITextField) -> Void {
        print(textFeild.text!)
        searchArray.removeAll()
        let preicate = NSPredicate(format: "SELF CONTAINS[c] %@", textFeild.text!)
        var array = [String]()
        for cityarray  in dataArray {
            for cityString in cityarray {
                array.append(cityString)
            }
        }
        searchArray = CityData.getAarry(array, preicate: preicate) as! Array
        print(searchArray.count)
        tableView.reloadData()
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.changeUI()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.restoreUI()
        return true
    }
    //MARK: tableviewdelegate
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return (searchTextFiled.text?.characters.count)! > 0 ? nil : textArray
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "定位城市" : textArray[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchTextFiled.text?.characters.count != 0 ? 1 : (dataArray.count != 0 ? dataArray.count : 0)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTextFiled.text?.characters.count != 0 ? searchArray.count : dataArray[section].count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if myCallbackValue != nil {
            searchTextFiled.text?.characters.count != 0 ? myCallbackValue!(searchArray[indexPath.row]) : myCallbackValue!(dataArray[indexPath.section][indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        if searchTextFiled.text?.characters.count != 0 {
            cell.textLabel?.text = searchArray[indexPath.row]
        }else{
            cell.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        }
        cell.selectionStyle = .none
        return cell
    }
    //MARK: initUI
    private func initUI() -> Void{
        self.view.addSubview(searchBase)
        self.searchBase.addSubview(searchTextFiled)
        self.searchBase.addSubview(cancleBtn)
        self.view.addSubview(tableView)
    }
    //MARK: 获取城市数据
    private func getCityData() -> Void{
        let array = ["南宁市"]
        
        if((UserDefaults.standard.bool(forKey: "city") as Bool!) == false || (UserDefaults.standard.bool(forKey: "city") as Bool!)==nil ){
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                self.dataArray = CityData.loadFile() as! Array
                self.dataArray.insert(array, at: 0)
                //异步线程加载结束回到主线程渲染UI
                DispatchQueue.main.async(execute: {() -> Void in
                    self.tableView.reloadData()
                })
            })
        }
        else{
            self.dataArray = CityData.getCityData() as! Array
            self.dataArray.insert(array, at: 0)
            //            print(array.count)
        }
    }
}


