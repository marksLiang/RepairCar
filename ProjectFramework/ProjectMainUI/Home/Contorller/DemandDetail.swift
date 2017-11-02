//
//  DemandDetail.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/31.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemandDetail: CustomTemplateViewController {
    fileprivate lazy var releaseBtn: UIButton = {
        let release = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 30))
        release.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        release.setTitle("完结", for: .normal)
        release.setTitleColor(UIColor.white, for: .normal)
        release.addTarget(self, action: #selector(DemandDetail.buttonClick), for: .touchUpInside)
        return release
    }()
    fileprivate lazy var stateBtn: UIButton = {
        let stateBtn = UIButton.init(frame: CGRect.init(x: 0, y: self.view.frame.height - 50, width:self.view.frame.width, height: 50))
        stateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        stateBtn.backgroundColor = CommonFunction.SystemColor()
        stateBtn.setTitle("正在进行中", for: .normal)
        stateBtn.setTitleColor(UIColor.white, for: .normal)
        stateBtn.isUserInteractionEnabled = false
        return stateBtn
    }()
    @IBOutlet weak var tableView: UITableView!
    fileprivate let sectionTextArray = ["需求信息","需求描述","需求图片"]
    fileprivate let ownerInfoArray = ["发布标题","联系人","联系号码","维修类型","查看位置"]
    fileprivate var ownerArray = Array<String>()
    fileprivate var viewModel = DemandViewModel()
    fileprivate var contentHeight:CGFloat=0
    fileprivate var isfirstLoad = false
    fileprivate var imageList = [Any]()
    var isMyrelese = false
    var ReleaseType = 1
    var DemandID = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "需求详情"
        self.initUI()
        self.getHttps()
    }
    private func getHttps()->Void{
        
        viewModel.GetDemandInfoInfoSingle(DemandID: DemandID) { (result) in
            if result == true {
                self.isfirstLoad = false
                self.ownerArray.append(self.viewModel.model.Title)
                self.ownerArray.append(self.viewModel.model.Contact)
                self.ownerArray.append(self.viewModel.model.Phone)
                self.ownerArray.append(self.viewModel.model.TypeNames)
                self.ownerArray.append("")
                self.contentHeight = self.viewModel.model.Describe.ContentSize(font: UIFont.systemFont(ofSize: 13), maxSize: CGSize.init(width: self.view.frame.width - 50, height: 0)).height
                if self.viewModel.model.Images != nil {
                    self.imageList.removeAll()
                    var i = 0
                    for imageModel in self.viewModel.model.Images! {
                        let imageView = UIImageView.init(frame: CGRect.init(x: 25, y: 10, width: self.view.frame.width - 50, height: 200))
                        imageView.ImageLoad(PostUrl: HttpsUrlImage+imageModel.ImgPath)
                        let pohtoView = JLPhoto.init()
                        pohtoView.sourceImageView = imageView
                        pohtoView.bigImgUrl = HttpsUrlImage+imageModel.ImgPath
                        pohtoView.tag = i
                        i = i + 1
                        self.imageList.append(pohtoView)
                    }
                }
                self.RefreshRequest(isLoading: false, isHiddenFooter: true)
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    override func Error_Click() {
        self.ownerArray.removeAll()
        self.RefreshRequest(isLoading: true, isHiddenFooter: true)
        self.getHttps()
    }
    //MARK: tableView代理
    //组数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTextArray.count
    }
    //组头
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        return self.viewModel.model.DemandID != 0 ? UIView().setIntroduceView(height: 40, title: sectionTextArray[section]) : UIView()
    }
    //组头高
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    //组个数
    var _numberOfRowsInSection = [0,0,0]
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.viewModel.model.DemandID != 0 {
            _numberOfRowsInSection[0] = ownerInfoArray.count
            _numberOfRowsInSection[1] = 1
            _numberOfRowsInSection[2] = self.viewModel.model.Images?.count ?? 0
        }
        return _numberOfRowsInSection[section]
    }
    var _heightForRowAt = [CGFloat(50),CGFloat(0),CGFloat(200)]
    //行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewModel.model.DemandID != 0 {
            _heightForRowAt[1] = contentHeight > 0 ? contentHeight + 20 : 0
        }
        return _heightForRowAt[indexPath.section]
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DemanInfoCell", for: indexPath) as! DemanInfoCell
            cell.celltitle.text = ownerInfoArray[indexPath.row]
            cell.cellContent.text = ownerArray[indexPath.row]
            if indexPath.row == 2 || indexPath.row == 4 {
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DemandCententCell", for: indexPath) as! DemandCententCell
            cell.content.text = self.viewModel.model.Describe
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DemandImageCell", for: indexPath) as! DemandImageCell
            cell.demandImage.ImageLoad(PostUrl: HttpsUrlImage+self.viewModel.model.Images![indexPath.row].ImgPath)
            
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 2 {
                CommonFunction.CallPhone(self, number: self.viewModel.model.Phone)
            }
            if indexPath.row == 4 {
                //跳转到地图
                let vc = ShopMapView()
                vc.Lat = Double(self.viewModel.model.Lat)!
                vc.lng = Double(self.viewModel.model.Lng)!
                vc.annotationTitle = "车主位置"
                vc.title = "车主位置"
                self.navigationController?.show(vc, sender: self)
            }
            break;
        case 2:
            //查看图片
            let photoBrowser = JLPhotoBrowser.init()
            photoBrowser.photos = self.imageList
            photoBrowser.currentIndex = Int32(indexPath.row)
            photoBrowser.show()
            break;
        default:
            break;
        }
    }
    //MARK: initUI
    private func initUI() -> Void {
        self.InitCongif(tableView)
        if isMyrelese == true {
            self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight - CommonFunction.NavigationControllerHeight - 50)
            if ReleaseType == 1 {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: releaseBtn)
                self.view.addSubview(self.stateBtn)
            }else{
                self.view.addSubview(self.stateBtn)
                self.stateBtn.setTitle("已完结", for: .normal)
            }
        }else{
            self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight - CommonFunction.NavigationControllerHeight)
        }
        self.header.isHidden = true
        
    }
    func buttonClick() -> Void {
        viewModel.SetDemandStatus(DemandID: DemandID) { (result) in
            if result == true {
                CommonFunction.HUD("修改成功", type: .success)
                self.releaseBtn.isHidden = true
                self.stateBtn.setTitle("已完结", for: .normal)
            }else{
                CommonFunction.HUD("修改失败", type: .error)
            }
        }
    }
}

