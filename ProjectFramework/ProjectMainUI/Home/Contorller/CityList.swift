//
//  CityList.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/7/21.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CityList: CustomTemplateViewController , UICollectionViewDelegateFlowLayout{
    //类似于OC中的typedef
    typealias CallbackSelectedValue=(_ cityString:String)->Void
    //声明一个闭包
    var myCallbackValue:CallbackSelectedValue?
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    
    @IBOutlet weak var colletionView: UICollectionView!
    /********************  属性  ********************/
    fileprivate let disposeBag   = DisposeBag()//处理包通道
    fileprivate let reuseIdentifier = "CityListCell"
    fileprivate var isEndRefresh    = false
    fileprivate let imagearray      = ["dingwei","open"]
    fileprivate let textArray       = ["定位城市","开放城市"]
    fileprivate let viewModel       = CityListViewModel()
    var currentCityName = ""
    
    //MARK: viewload
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择城市"
        // Do any additional setup after loading the view.
        self.initUI()
        self.getHttpData()
    }
    override func Error_Click() {
        self.getHttpData()
    }
    private func getHttpData() -> Void{
        viewModel.GetCityList { (result, errorString) in
            
            if result == true {
                if errorString == "" {
                    self.isEndRefresh = true // 是否加载完了
                    self.RefreshRequest(isLoading: false, isHiddenFooter: true)
                }else{
                    CommonFunction.HUD(errorString!, type: .error)
                }
            }else{
                self.RefreshRequest(isLoading: false, isHiddenFooter: true, isLoadError: true)
            }
        }
    }
    // MARK: UILayoutDelegate,iOS 10之后需要在代理方法里实现
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    // size大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let showrowsitem:CGFloat=3  //竖屏显示的数目 （暂时未做横屏手机item  间距直接也存在点差异 ipad 没事 iPhone需要修改
        return self.viewModel.ListData.count != 0 ? CGSize(width: self.view.bounds.size.width/showrowsitem, height: 45) : CGSize.init(width: 0, height: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader && isEndRefresh == true{
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)as! CityListHeader
            head.setData(image: imagearray[indexPath.section], text: textArray[indexPath.section])
            return head
        }
        else{
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return isEndRefresh ? CGSize(width: CommonFunction.kScreenWidth, height: 30) : CGSize(width: 0, height: 0)
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isEndRefresh ? imagearray.count : 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEndRefresh == false {
            return 0
        }else{
            return section == 0 ? 1 : self.viewModel.ListData.count
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CityListCell
        indexPath.section == 0 ? cell.button.setTitle(currentCityName, for: .normal) :cell.button.setTitle(self.viewModel.ListData[indexPath.row].CityName, for: .normal)
        cell.button.rx.tap.subscribe(
            onNext:{ [weak self] value in
                if self?.myCallbackValue != nil {
                    indexPath.section == 0 ? self?.myCallbackValue!((self?.currentCityName)!) : self?.myCallbackValue!((self?.viewModel.ListData[indexPath.row].CityName)!)
                    self?.navigationController?.popViewController(animated: true)
                }
        }).addDisposableTo(self.disposeBag)
        return cell
    }

    //MARK: initUI
    private func initUI() -> Void {
        self.InitCongifCollection(colletionView, nil)
        self.colletionView.register(CityListHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        self.colletionView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: self.view.frame.width, height: CommonFunction.kScreenHeight - CommonFunction.NavigationControllerHeight)
        self.header.isHidden = true
        self.footer.isHidden = true
    }
    
}


