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
import SDWebImage

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
    var isBohui = false
    var MaintenanceID = 0 //店铺ID
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
    /********************  店铺存在时候的数据  ********************/
    fileprivate var pohtoView:UpLoadPicManagerView!=nil
    fileprivate var shopName = ""
    fileprivate var phone = ""
    fileprivate var area = ""
    fileprivate var content = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isHaveShop == true {
            self.title = "我的店铺"
            debugPrint("我的店铺ID===\(MaintenanceID)")
            self.getData()
        }else{
            self.title = "申请店铺"
        }
        self.initUI()
    }
    //MARK: 获取数据
    private func getData()->Void{
        viewModel.GetMaintenanceInfoSingle(MaintenanceID: MaintenanceID) { (result) in
            if result == true {
                self.isEndRefresh = true // 结束刷新
                self.initFootView()
                self.setData()
                self.RefreshRequest(isLoading: false, isHiddenFooter: true)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    //重新赋值数据
    private func setData()->Void{
        shopName = viewModel.model.TitleName
        phone = viewModel.model.Phone
        area = viewModel.model.Area
        cityName = viewModel.model.CityName
        currenType = viewModel.model.TypeNames
        demanView.shopContent.text = viewModel.model.Introduce
//        //地址
        currenAdress = viewModel.model.Address
        //百度坐标转火星坐标
        let center = MapTool.transformFromBaidu(toGCJ: CLLocationCoordinate2D.init(latitude: viewModel.model.Lat, longitude: viewModel.model.Lng))
        //火星坐标转高德坐标
        let coor = MapTool.marsGS2WorldGS(center)
        self.currenLocation = CLLocation.init(latitude: coor.latitude, longitude: coor.longitude)
        demanView.defultImage.ImageLoad(PostUrl: HttpsUrlImage+viewModel.model.LicenseImgs![0].ImgPath)
        var imageList = [String]()
        for model in viewModel.model.Images! {
            imageList.append(model.ImgPath)
        }
        pohtoView.SetImageUrl(imageList)
        viewModel.isHave = true
        viewModel.MaintenanceID = self.MaintenanceID
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
                if isHaveShop {
                    cell.shopTextfield.isUserInteractionEnabled = false //不能随意修改店铺名
                }
                if isBohui {
                    cell.shopTextfield.isUserInteractionEnabled = true //驳回的店铺可以修改店名
                }
                cell.shopTextfield.text = shopName
                //绑定店名
                cell.shopTextfield.rx.text.orEmpty
                    .bind(to: viewModel.shopName)
                    .addDisposableTo(disposeBag)
                break;
            case 1:
                cell.shopTextfield.text = phone
                cell.shopTextfield.keyboardType = .numberPad
                //绑定电话
                cell.shopTextfield.rx.text.orEmpty
                    .bind(to: viewModel.phoneNumber)
                    .addDisposableTo(disposeBag)
                break;
            case 2:
                cell.shopTextfield.text = area
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
            cell.shopAdress.text = currenAdress
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
                let cell = self?.tableView.cellForRow(at: indexPath) as! MyShopAdressCell
                self?.currenAdress = adress
                cell.shopAdress.text = adress
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
        let footView = UIView.init()
        if isHaveShop == true {
            demanView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 180)//过审核不用显示营业执照
            demanView.defultImage.isHidden = true
            demanView.lable.isHidden = true
            footView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 530)
        }else{
            footView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 650)
            demanView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 300)
        }
        self.tableView.tableFooterView = footView
        footView.addSubview(demanView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MyShop.chooseImage))
        demanView.defultImage.addGestureRecognizer(tap)
        
        let viw = UIView.init()
        if isHaveShop == true {
            viw.frame = CGRect.init(x: 0, y: 188, width: self.view.frame.width, height:350)
        }else{
            viw.frame = CGRect.init(x: 0, y: 308, width: self.view.frame.width, height:350)
        }
        viw.backgroundColor = UIColor.white
        footView.addSubview(viw)
        
        let lable = UILabel.init(frame: CGRect.init(x: 15, y: 5, width: 100, height: 20))
        lable.text = "店铺图片"
        lable.font = UIFont.systemFont(ofSize: 13)
        viw.addSubview(lable)
        
        self.pohtoView = UpLoadPicManagerView.init(frame: CGRect.init(x: 0, y: 30, width: self.view.frame.width, height: 250), delegate: self, ShowRowsItem: 3, SelectedImgMaxCount: 4) {[weak self] (imageList) in
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
