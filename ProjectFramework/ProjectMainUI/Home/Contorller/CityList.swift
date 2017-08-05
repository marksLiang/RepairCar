//
//  CityList.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/7/21.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit


class CityList: UIViewController ,UITextFieldDelegate{
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择城市"
        // Do any additional setup after loading the view.
        self.initUI()
        self.getCityData()
    }
    
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
    //MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.changeUI()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.restoreUI()
        return true
    }
    //MARK: initUI
    private func initUI() -> Void{
        self.view.addSubview(searchBase)
        self.searchBase.addSubview(searchTextFiled)
        self.searchBase.addSubview(cancleBtn)
    }
    //MARK: 获取城市数据
    private func getCityData() -> Void{
        let str = UserDefaults.standard.value(forKey: "city") as? String
        if  str?.characters.count == 0 {
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                let array = CityData.loadFile() as Array
                //异步线程加载结束回到主线程渲染UI
                DispatchQueue.main.async(execute: {() -> Void in
                    
                })
            })
        }else{
            let array = CityData.getCityData() as Array
            //            print(array.count)
        }
    }
}


