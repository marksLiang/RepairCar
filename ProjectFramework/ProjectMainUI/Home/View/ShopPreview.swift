//
//  ShopPreview.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/25.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopPreview: UIView ,UITableViewDelegate,UITableViewDataSource{
    typealias CallbackValue=( _ value:Int)->Void //类似于OC中的typedef
    var myCallbackValue:CallbackValue?  //声明一个闭包 类似OC的Block属性
    func  FuncCallbackValue(value:CallbackValue?){
        myCallbackValue = value //返回值
    }
    
    var _model:RepairShopModel?=nil
    fileprivate var headImage: UIImageView = {
        let headImage = UIImageView.init(frame: CGRect.init(x: 0, y: 50, width: CommonFunction.kScreenWidth - 100, height: 150))
        headImage.image = UIImage.init(named: "placeholder")
        return headImage
    }()
    fileprivate var header: UIView = {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth - 100, height: 200))
        header.clipsToBounds = true
        let base = UIView.init(frame: CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth - 100, height: 210))
        base.backgroundColor = UIColor.white
        base.layer.cornerRadius = 5
        header.addSubview(base)
        
        let lable = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: 200, height: 25))
        lable.center.x = base.center.x
        lable.textAlignment = .center
        lable.font = UIFont.boldSystemFont(ofSize: 16)
        lable.textColor = CommonFunction.SystemColor()
        lable.text = "店铺预览"
        header.addSubview(lable)
        return header
    }()
    fileprivate var closeBtn: UIButton = {
        let closeBtn = UIButton.init(type: .custom)
        closeBtn.tag = 1
        closeBtn.frame = CGRect.init(x: CommonFunction.kScreenWidth - 50, y: 35, width: 35, height: 35)
        closeBtn.setBackgroundImage(UIImage.init(named: "closed"), for: .normal)
        closeBtn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return closeBtn
    }()
    fileprivate var lookAllBtn: UIButton = {
        let lookAllBtn = UIButton.init(type: .system)
        lookAllBtn.tag = 2
        lookAllBtn.backgroundColor = UIColor.white
        lookAllBtn.layer.cornerRadius = 5
        lookAllBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        lookAllBtn.setTitleColor(CommonFunction.SystemColor(), for: .normal)
        lookAllBtn.setTitle("查看全部", for: .normal)
        lookAllBtn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return lookAllBtn
    }()
    fileprivate var tableview: UITableView = {
        let tableview = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth - 100, height: 300), style: .plain)
        return tableview
    }()
    init(frame:CGRect,model:RepairShopModel) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let requesterNib = UINib(nibName: "ShopPreviewCell", bundle: nil)
        tableview.register(requesterNib, forCellReuseIdentifier: "ShopPreviewCell")
        tableview.center = self.center
        tableview.delegate = self
        tableview.dataSource = self
        lookAllBtn.frame = CGRect.init(x: 0, y: tableview.frame.maxY + 20, width: 90, height: 35)
        lookAllBtn.center.x = self.center.x
        self.addSubview(tableview)
        self.addSubview(header)
        self.addSubview(closeBtn)
        self.addSubview(lookAllBtn)
        self.header.addSubview(headImage)
        self.tableview.tableHeaderView = header
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func buttonClick( button:UIButton) -> Void {
        if button.tag == 1 {
            UIView.animate(withDuration: 0.5) {
                self.frame = CGRect.init(x: 0, y: CommonFunction.kScreenHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight)
            }
        }
        if button.tag == 2 {
            if myCallbackValue != nil {
                myCallbackValue!(button.tag)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopPreviewCell", for: indexPath) as! ShopPreviewCell
        if self._model != nil {
            cell.InitConfig(self._model as Any)
        }
        return cell
    }
    func setModel(_ model:RepairShopModel) -> Void {
        self._model = model
        self.tableview.reloadData()
    }
}
