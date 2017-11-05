//
//  MyShop.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/2.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MyShop: CustomTemplateViewController {
    //提交&&保存
    fileprivate lazy var savaBtn: UIButton = {
        let savaBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 30))
        savaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        savaBtn.setTitleColor(UIColor.white, for: .normal)
        savaBtn.rx.tap.subscribe(
            onNext:{ [weak self] value in
                
                self?.viewModel.currenLocation = self?.currenLocation
                self?.viewModel.adress =  (self?.currenAdress)!
                self?.viewModel.permit = (self?.demanView.defultImage.image)!
                self?.viewModel.currenImageList = (self?.currenImageList)!
        }).addDisposableTo(self.disposeBag)
        savaBtn.rx.tap
            .bind(to: self.viewModel.saveEvent)  //绑定事件 (点击注册)
            .addDisposableTo(self.disposeBag)
        return savaBtn
    }()
    fileprivate lazy var demanView: MyShopIntroduceView = {
        let demanView = Bundle.main.loadNibNamed("MyShopIntroduceView", owner: self, options: nil)?.last
        return demanView as! MyShopIntroduceView
    }()
    /********************  属性  ********************/
    var isHaveShop = false      //是否有店铺  否就填数据  是就请求数据填充
    fileprivate  var isEndRefresh = false  //是否结束刷新  刷新数据
    fileprivate let ketArray = ["店面名称","联系号码","店面面积","所属城市","维修类型"]
    fileprivate var viewModel = MyShopViewModel()
    fileprivate let disposeBag   = DisposeBag()//处理包通道
    fileprivate var cityName = ""
    fileprivate var currenType = ""
    fileprivate var currenTypeArray = Array<String>()//选择的维修类型
    fileprivate var currenAdress="" //当前店铺地址
    fileprivate var currenLocation:CLLocation!=nil//当前坐标
    fileprivate var currenImageList = [UIImage]()//当前图片数组
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isHaveShop == true {
            self.title = "我的店铺"
            
        }else{
            self.title = "申请店铺"
        }
        self.initUI()
    }
    //MARK: tableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isHaveShop ? (isEndRefresh ? 1 : 0) : 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isHaveShop ? (isEndRefresh ? ketArray.count + 2 : 0) : ketArray.count + 2
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < ketArray.count {
            return 50
        }
        if indexPath.row == ketArray.count {
            return 70
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < ketArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyShopCell", for: indexPath) as! MyShopCell
            cell.keyLable.text = ketArray[indexPath.row]
            switch indexPath.row {
            case 0:
                //绑定店名
                cell.shopTextfield.rx.text.orEmpty
                    .bind(to: viewModel.shopName)
                    .addDisposableTo(disposeBag)
                break;
            case 1:
                cell.shopTextfield.keyboardType = .numberPad
                //绑定电话
                cell.shopTextfield.rx.text.orEmpty
                    .bind(to: viewModel.phoneNumber)
                    .addDisposableTo(disposeBag)
                break;
            case 2:
                //绑定面积
                cell.shopTextfield.rx.text.orEmpty
                    .bind(to: viewModel.arae)
                    .addDisposableTo(disposeBag)
                break;
            case 3:
                cell.shopTextfield.placeholder = "请选择"
                cell.accessoryType = .disclosureIndicator
                cell.shopTextfield.text = cityName
                cell.shopTextfield.isUserInteractionEnabled = false
                
                //绑定城市
                cell.shopTextfield.rx.text.orEmpty
                    .bind(to: viewModel.city)
                    .addDisposableTo(disposeBag)
                break;
            case 4:
                cell.shopTextfield.isUserInteractionEnabled = false
                cell.shopTextfield.placeholder = "请选择"
                cell.accessoryType = .disclosureIndicator
                cell.shopTextfield.text = currenType
                
                //绑定类型
                cell.shopTextfield.rx.text.orEmpty
                    .bind(to: viewModel.typeName)
                    .addDisposableTo(disposeBag)
                break;
            default:
                break;
            }
            return cell
        }
        if indexPath.row == ketArray.count  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyShopAdressCell", for: indexPath) as! MyShopAdressCell
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        //选择城市
        case 3:
            self.view.endEditing(true)
            let vc = CommonFunction.ViewControllerWithStoryboardName("CityList", Identifier: "CityList") as! CityList
            vc.currentCityName = CurrentCity
            vc.Callback_SelectedValue {[weak self] (selectCity) in
                self?.cityName = selectCity
                self?.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: indexPath.section)], with: .automatic)
            }
            self.navigationController?.show(vc, sender: self)
            break;
        //选择维修类型
        case 4:
            self.view.endEditing(true)
            CommonFunction.ActionSheet(ShowTitle: Global_MaintenanceType, sheetWithTitle: "请选择维修的类型", ItemsTextColor: UIColor.black, ReturnSelectedIndex: { (inedx, value) in
                //获取输入框的值  如果没有值就直接拼接  有值就加逗号
                let cell = tableView.cellForRow(at: indexPath) as! MyShopCell
                if cell.shopTextfield.text == "" {
                    self.currenType = ""
                    self.currenType = value
                    self.currenTypeArray.append(value)
                }else{
                    if self.currenTypeArray.contains(value) {
                        CommonFunction.HUD("请不要重复选择同一种维修类型！", type: .error)
                    }else{
                        self.currenType = self.currenType + "," + value
                        self.currenTypeArray.append(value)
                    }
                }
                self.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: indexPath.section)], with: .automatic)
            })
            break;
        //选择地址
        case 5:
            self.view.endEditing(true)
            let vc = MyMapView()
            vc.FuncCallbackValue(value: {[weak self](location,adress) in
                let cell = self?.tableView.cellForRow(at: indexPath) as! CurrenAdressCell
                self?.currenAdress = adress
                cell.currenAdress.text = adress
                self?.currenLocation = location
            })
            self.navigationController?.show(vc, sender: self)
            break;
        default:
            break;
        }
    }
    //MARK: 初始化视图
    private func initUI()->Void{
        if isHaveShop {
            savaBtn.setTitle("保存", for: .normal)
        }else{
            savaBtn.setTitle("提交", for: .normal)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: savaBtn)
        //init  Tableview
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight)
        self.tableView.backgroundColor = UIColor().TransferStringToColor("#EEEEEE")
        self.header.isHidden = true
        
        //还不是店铺的情况
        if isHaveShop == false {
            self.initFootView()
            self.RefreshRequest(isLoading: false, isHiddenFooter: true)
        }
    }
    private func initFootView() -> Void{
        let footView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 650))
        self.tableView.tableFooterView = footView
        demanView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 300)
        footView.addSubview(demanView)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MyShop.chooseImage))
        demanView.defultImage.addGestureRecognizer(tap)
        
        let viw = UIView.init(frame: CGRect.init(x: 0, y: 308, width: self.view.frame.width, height:350))
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
        
        //绑定控件
        self.RXbind()
        self.getResult()
    }
    //MARK: 控件绑定
    private func RXbind()->Void{
        //需求描述绑定
        let IsValid: Observable = demanView.shopContent.rx.text.orEmpty
            .map { text in text.characters.count > 0 }
        IsValid
            .bind(to: demanView.shopLabel.rx.isHidden)
            .disposed(by: disposeBag)
        //内容绑定
        demanView.shopContent.rx.text.orEmpty
            .bind(to: viewModel.content)
            .addDisposableTo(disposeBag)
        
    }
    //选择营业执照
    func chooseImage() -> Void {
        CommonFunction.CameraPhotoAlertController(self) { (image) in
            self.demanView.defultImage.image = image
        }
    }
    //MARK: 收到消息回调
    private func getResult()->Void{
        //收到ViewModel逻辑校验的消息回调
        _ = self.viewModel.saveResult?.subscribe(onNext: {[weak self] (result) in
            switch result {
            case   .ok: //处理成功的业务
                debugPrint("OK")
                self?.viewModel.delegate = self
                self?.viewModel.upLoadImage()
                break
            case   .empty:
                
                break
            case   .error:
                
                break
            }
        }).addDisposableTo(self.disposeBag)
    }
}
