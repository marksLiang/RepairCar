//
//  ShopDetail.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/27.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopDetail: CustomTemplateViewController {
    
    lazy var lable: UILabel = {
        let lable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 30))
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textAlignment = .center
        lable.text = "店铺详情"
        lable.textColor = UIColor.white
        lable.alpha = 0.0
        return lable
    }()
    fileprivate lazy var navgationBar: UIView = {
        let navgationBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: CommonFunction.NavigationControllerHeight))
        navgationBar.backgroundColor = UIColor().TransferStringToColor(CommonFunction.SystemColor()).withAlphaComponent(0)
        self.lable.center.x = navgationBar.center.x
        self.lable.center.y = navgationBar.center.y + 10
        self.lable.text = "店铺详情"
        navgationBar.addSubview(self.lable)
        return navgationBar
    }()
    
    /*******************XIB*********************/
    @IBOutlet weak var tableViewHead: UIView!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    /*******************属性*********************/
    var model:RepairShopModel?=nil
    fileprivate var backBtn:UIButton!=nil
    fileprivate var alph: CGFloat = 0
    fileprivate var CustomNavBar:UINavigationBar!=nil
    fileprivate let identiFier  = "ShopDetailCell"
    fileprivate let titleKey = ["店铺名称：","店面地址：","联系电话：","店铺面积："]
    fileprivate let imageArray = ["","ionicons","phone",""]
    fileprivate var titleValue = [String]()
    fileprivate var imageList = [Any]()
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.setNavBar()
        self.initUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        shopImage.contentMode = .scaleAspectFill
        shopImage.clipsToBounds = true
        if model?.Images?.count == 0 {
            shopName.text = "暂无图片"
        }else{
            shopImage.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(ShopDetail.tap))
            shopImage.addGestureRecognizer(tap)
            shopName.text = "1/\((model?.Images?.count)!)"
            shopImage.ImageLoad(PostUrl: HttpsUrlImage+(model?.Images![0].ImgPath)!)
                self.imageList.removeAll()
                var i = 0
                for imageModel in (model?.Images)! {
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
        
    }
    func tap() -> Void {
        //查看图片
        let photoBrowser = JLPhotoBrowser.init()
        photoBrowser.photos = self.imageList
        photoBrowser.currentIndex = Int32(0)
        photoBrowser.show()
    }
    //MARK: getData
    private func getData() -> Void{
        titleValue.append(model!.TitleName)
        titleValue.append(model!.Address)
        titleValue.append(model!.Phone)
        titleValue.append(model!.Area)
    }
    //MARK: tableViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offset: CGFloat = scrollView.contentOffset.y
        if (offset <= CommonFunction.NavigationControllerHeight) {
            navgationBar.backgroundColor = UIColor().TransferStringToColor(CommonFunction.SystemColor()).withAlphaComponent(0)
            backBtn.backgroundColor = UIColor.gray
            UIView.animate(withDuration: 0.2, animations: {
                self.lable.alpha = 0.0
            })
        }
        else{
            alph = 1-((200 - offset)/200)
            navgationBar.backgroundColor = UIColor().TransferStringToColor(CommonFunction.SystemColor()).withAlphaComponent(alph)
            backBtn.backgroundColor = UIColor.gray.withAlphaComponent(1-alph)
            lable.alpha = alph
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identiFier, for: indexPath) as! ShopDetailCell
        cell.setData(titleKey: titleKey[indexPath.row], titleValue: titleValue[indexPath.row], imageList:imageArray[indexPath.row] )
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let vc = ShopMapView()
            vc.Lat = self.model?.Lat ?? 0.0
            vc.lng = self.model?.Lng ?? 0.0
            vc.annotationTitle = (self.model?.TitleName)!
            vc.title = "店铺地址"
            self.navigationController?.show(vc, sender: self)
            break;
        case 2:
            CommonFunction.CallPhone(self, number: (model?.Phone)!)
            break;
        default:
            break;
        }
    }
    //MARK: 设置导航栏
    func setNavBar() -> Void{
        
        //返回按钮
        backBtn = UIButton(type: .custom)
        backBtn.frame = CommonFunction.CGRect_fram(15, y: CommonFunction.StauteBarHeight, w: 30, h: 30)
        backBtn.tag = 100
        backBtn.backgroundColor = UIColor.gray
        backBtn.layer.cornerRadius = 15
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        backBtn.addTarget(self, action:#selector(buttonClick) , for: .touchUpInside)
        self.view.addSubview(navgationBar)
        self.navgationBar.addSubview(backBtn)
        
        
    }
    //导航栏按钮方法
    func buttonClick(_ button: UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    //MARK: initUI
    private func initUI() -> Void {
        self.InitCongif(tableView)
        if CommonFunction.isIphoneX {
            self.tableView.frame = CGRect.init(x: 0, y: -CommonFunction.StauteBarHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight)
        }else{
            self.tableView.frame = CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight)
        }
        
        self.numberOfSections=1//显示行数
        self.numberOfRowsInSection=4
        self.tableViewheightForRowAt=50//行高
        self.tableView.tableHeaderView = tableViewHead
        self.header.isHidden=true
        self.RefreshRequest(isLoading: false, isHiddenFooter: true)
        
        //尾部视图
        self.setFootView()
    }
    //MARK: 设置尾部
    private func setFootView() -> Void{
        var tepyArray = [String]()
        if model?.TypeNames != "" {
            tepyArray = (model?.TypeNames.components(separatedBy: ","))!
            tepyArray.removeLast()
        }
        let textHeight = model?.Introduce.ContentSize(font: UIFont.systemFont(ofSize: 13), maxSize: CGSize.init(width: CommonFunction.kScreenWidth - 25, height: 0)).height
        var height:CGFloat=0
        height = tepyArray.count > 3 ? 90 + textHeight! : 130 + textHeight!
        let footView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: height))
        footView.layer.borderWidth = 0.5
        footView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        footView.backgroundColor = UIColor.white
        
        let weixiuleixing = UILabel.init(frame: CGRect.init(x: 15, y: 10, width: 70, height: 20))
        weixiuleixing.text = "维修类型："
        weixiuleixing.font = UIFont.systemFont(ofSize: 13)
        footView.addSubview(weixiuleixing)
        
        var frame_x = weixiuleixing.frame.maxX
        var frame_X = weixiuleixing.frame.minX + 5
        var frame_Y = weixiuleixing.frame.maxY + 15
        for i in 0..<tepyArray.count {
            let lable = UILabel.init()
            lable.layer.borderWidth = 0.6
            lable.layer.borderColor = UIColor.clear.cgColor
            lable.layer.cornerRadius = 4
            lable.clipsToBounds = true
            lable.font = UIFont.systemFont(ofSize: 12)
            lable.backgroundColor = CommonFunction.SystemColor().withAlphaComponent(0.7)
            lable.text = tepyArray[i]
            lable.textColor = UIColor.white
            lable.textAlignment = .center
            let view_width = tepyArray[i].getContenSizeWidth(font: UIFont.systemFont(ofSize: 12)) + 10//获取标签宽度
            if i < 3 {
                lable.frame = CGRect.init(x: frame_x, y: weixiuleixing.frame.minY + 1, width: view_width , height: 20)
                frame_x = frame_x + view_width + 10
            }else{
                lable.frame = CGRect.init(x: frame_X, y: weixiuleixing.frame.maxY + 10, width: view_width, height: 20)
                frame_X = frame_X + view_width + 10
                frame_Y = weixiuleixing.frame.maxY + 45
            }
            footView.addSubview(lable)
        }
        
        let dianpujieshao = UILabel.init(frame: CGRect.init(x: 15, y: frame_Y, width: 70, height: 20))
        dianpujieshao.text = "店铺介绍："
        dianpujieshao.font = UIFont.systemFont(ofSize: 13)
        footView.addSubview(dianpujieshao)
        
        let introduce = UILabel.init(frame: CGRect.init(x: dianpujieshao.frame.minX, y: dianpujieshao.frame.maxY + 3, width: CommonFunction.kScreenWidth - 25, height: textHeight! + 3))
        introduce.text = model?.Introduce
        introduce.font = UIFont.systemFont(ofSize: 13)
        introduce.textColor = UIColor.lightGray
        footView.addSubview(introduce)
        
        self.tableView.tableFooterView = footView
    }
}
