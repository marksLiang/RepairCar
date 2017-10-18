//
//  PostedDemand.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/10/17.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class PostedDemand: CustomTemplateViewController {
    //发布按钮
    fileprivate lazy var savaBtn: UIButton = {
        let savaBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 30))
        savaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        savaBtn.setTitle("保存", for: .normal)
        savaBtn.setTitleColor(UIColor.white, for: .normal)
        savaBtn.rx.tap.subscribe(
            onNext:{ [weak self] value in
                print("保存")
                
        }).addDisposableTo(self.disposeBag)
        return savaBtn
    }()
    /********************  属性  ********************/
    fileprivate let identifier    = "DemanEditCell"
    fileprivate let disposeBag   = DisposeBag()//处理包通道
    fileprivate let ketArray = ["发布标题","联系人","联系号码","维修类型"]
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "需求列表"
        // Do any additional setup after loading the view.
        self.setNavhationBar()
        self.initUI()
    }
    //MARK: tableViewdelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DemanEditCell
            return cell
        }else{
            return UITableViewCell()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row < 4 ? 50 : 70
    }
    //设置导航栏
    private func setNavhationBar()->Void{
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: savaBtn)
    }
    //MARK: initUI
    private func initUI() -> Void{
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight)
        self.header.isHidden = true
        self.numberOfSections = 1
        self.numberOfRowsInSection = ketArray.count + 1
        self.RefreshRequest(isLoading: false, isHiddenFooter: true)
    }
}
