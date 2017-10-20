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
import SnapKit
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
    fileprivate lazy var demanView: DemanContenView = {
        let sectionConment = Bundle.main.loadNibNamed("DemanContenView", owner: self, options: nil)?.last
        return sectionConment as! DemanContenView
    }()
    
    /********************  属性  ********************/
    fileprivate let identifier    = "DemanEditCell"
    fileprivate let identifier1    = "CurrenAdressCell"
    fileprivate let disposeBag   = DisposeBag()//处理包通道
    fileprivate let ketArray = ["发布标题","联系人","联系号码","维修类型"]
    fileprivate var currenAdress = ""//当前地址
    fileprivate var currenImageList = [UIImage]()//当前图片数组
    fileprivate var currenType = ""
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布需求"
        // Do any additional setup after loading the view.
        self.setNavhationBar()
        self.initUI()
        self.RXbind()
    }
    //取消键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    //MARK: tableViewdelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DemanEditCell
            cell.keyTitle.text = ketArray[indexPath.row]
            switch indexPath.row {
            case 2:
                cell.textfield.keyboardType = .numberPad
                break;
            case 3:
                cell.textfield.isUserInteractionEnabled = false
                cell.textfield.placeholder = "请选择"
                cell.textfield.text = self.currenType
                cell.littleImage.isHidden = false
                break;
            default:
                break;
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier1, for: indexPath) as! CurrenAdressCell
            if currenAdress != "" {
                cell.currenAdress.text = currenAdress
            }
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row < 4 ? 50 : 70
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            CommonFunction.ActionSheet(ShowTitle: Global_MaintenanceType, sheetWithTitle: "请选择维修的类型", ItemsTextColor: UIColor.black, ReturnSelectedIndex: { (inedx, value) in
                self.currenType = value
                self.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: indexPath.section)], with: .automatic)
            })
        }
        if indexPath.row == 4 {
            let vc = MyMapView()
            self.navigationController?.show(vc, sender: self)
        }
    }
    //设置导航栏
    private func setNavhationBar()->Void{
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: savaBtn)
    }
    //MARK: initUI
    private func initUI() -> Void{
        
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight)
        self.tableView.backgroundColor = UIColor().TransferStringToColor("#EEEEEE")
        self.header.isHidden = true
        self.numberOfSections = 1
        self.numberOfRowsInSection = ketArray.count + 1
        self.RefreshRequest(isLoading: false, isHiddenFooter: true)
        
        let footView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 500))
        self.tableView.tableFooterView = footView
        demanView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 200)
        footView.addSubview(demanView)

        let viw = UIView.init(frame: CGRect.init(x: 0, y: 208, width: self.view.frame.width, height:350))
        viw.backgroundColor = UIColor.white
        footView.addSubview(viw)
        
        let lable = UILabel.init(frame: CGRect.init(x: 15, y: 5, width: 100, height: 20))
        lable.text = "请选择图片"
        lable.font = UIFont.systemFont(ofSize: 13)
        viw.addSubview(lable)
        
        let pohtoView = UpLoadPicManagerView.init(frame: CGRect.init(x: 0, y: 30, width: self.view.frame.width, height: 250), delegate: self, ShowRowsItem: 3, SelectedImgMaxCount: 4) {[weak self] (imageList) in
            self?.currenImageList = imageList
            debugPrint(imageList.count)
        }
        viw.addSubview(pohtoView)

    }
    //MARK: 控件绑定
    private func RXbind()->Void{
        //需求描述绑定
        let IsValid: Observable = demanView.demanContent.rx.text.orEmpty
            .map { text in text.characters.count > 0 }
        IsValid
            .bind(to: demanView.tishiLable.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
