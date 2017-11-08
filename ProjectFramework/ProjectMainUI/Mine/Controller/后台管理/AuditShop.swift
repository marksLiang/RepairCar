//
//  AuditShop.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class AuditShop: CustomTemplateViewController {
    fileprivate lazy var demanView: MyShopIntroduceView = {
        let demanView = Bundle.main.loadNibNamed("MyShopIntroduceView", owner: self, options: nil)?.last
        return demanView as! MyShopIntroduceView
    }()
    @IBOutlet weak var tableView: UITableView!
    
    var MaintenanceID = 0 //店铺ID
    fileprivate var isEndRefresh = false  //是否结束刷新  刷新数据
    fileprivate let ketArray = ["店面名称","联系号码","店面面积","所属城市","维修类型"]
    fileprivate var viewModel = MyShopViewModel()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "审核店铺"
        self.initUI()
        self.getData()
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
//        demanView.defultImage.ImageLoad(PostUrl: HttpsUrlImage+viewModel.model.LicenseImgs![0].ImgPath)
//        var imageList = [String]()
//        for model in viewModel.model.Images! {
//            imageList.append(model.ImgPath)
//        }
//        pohtoView.SetImageUrl(imageList)
//        viewModel.isHave = true
//        viewModel.MaintenanceID = self.MaintenanceID
//        viewModel.permitString = [viewModel.model.LicenseImgs![0].ImgPath]
//        viewModel.imageListString = imageList
    }
    //MARK: tableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isEndRefresh ? 1 : 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEndRefresh ? ketArray.count + 2 : 0
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
                cell.shopTextfield.text = shopName
                break;
            case 1:
                cell.shopTextfield.text = phone
                cell.shopTextfield.keyboardType = .numberPad
                
                break;
            case 2:
                cell.shopTextfield.text = area
                
                break;
            case 3:
                cell.shopTextfield.placeholder = "请选择"
                cell.accessoryType = .disclosureIndicator
                cell.shopTextfield.text = cityName
                cell.shopTextfield.isUserInteractionEnabled = false
                
                break;
            case 4:
                cell.shopTextfield.isUserInteractionEnabled = false
                cell.shopTextfield.placeholder = "请选择"
                cell.accessoryType = .disclosureIndicator
                cell.shopTextfield.text = currenType
                
                break;
            default:
                break;
            }
            return cell
        }
        if indexPath.row == ketArray.count  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyShopAdressCell", for: indexPath) as! MyShopAdressCell
            cell.accessoryType = .disclosureIndicator
            cell.shopAdress.text = currenAdress == "" ? "请选择店铺位置" : currenAdress
            return cell
        }
        return UITableViewCell()
    }
    private func initUI()->Void{
        let button = UIButton.init(frame: CGRect.init(x: 0, y: CommonFunction.kScreenHeight-50, width:  CommonFunction.kScreenWidth, height: 50))
        button.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("驳回", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(AuditShop.rejectEvent), for: .touchUpInside)
        self.view.addSubview(button)
        
        self.InitCongif(tableView)
        tableView.register(UINib(nibName: "MyShopCell", bundle: nil), forCellReuseIdentifier: "MyShopCell")
        tableView.register(UINib(nibName: "MyShopAdressCell", bundle: nil), forCellReuseIdentifier: "MyShopAdressCell")
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-CommonFunction.NavigationControllerHeight-50)
        self.tableView.backgroundColor = UIColor().TransferStringToColor("#EEEEEE")
        self.header.isHidden = true
    }
    //尾部视图
    private func initFootView() -> Void{
        let footView = UIView.init()
        footView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 650)
        demanView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 300)
        self.tableView.tableFooterView = footView
        footView.addSubview(demanView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MyShop.chooseImage))
        demanView.defultImage.addGestureRecognizer(tap)
        
        let viw = UIView.init()
        viw.frame = CGRect.init(x: 0, y: 308, width: self.view.frame.width, height:350)
        viw.backgroundColor = UIColor.white
        footView.addSubview(viw)
        
        let lable = UILabel.init(frame: CGRect.init(x: 15, y: 5, width: 300, height: 20))
        lable.text = "店铺图片 (第一张为店铺封面)"
        lable.font = UIFont.systemFont(ofSize: 13)
        viw.addSubview(lable)
        
        self.pohtoView = UpLoadPicManagerView.init(frame: CGRect.init(x: 0, y: 30, width: self.view.frame.width, height: 250), delegate: self, ShowRowsItem: 3, SelectedImgMaxCount: 4) {[weak self] (imageList) in
            self?.currenImageList = imageList
            
        }
        viw.addSubview(pohtoView)
        
    }
    func rejectEvent() -> Void {
        debugPrint("驳回")
    }
}
