//
//  CustomTableViewViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/4.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import MJRefresh
import DZNEmptyDataSet

class CustomTemplateViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
     ///是否加载中
    internal var isLoading:Bool=true
     ///是否加载失败
    internal var isLoadError:Bool=false
    ///返回节的个数 默认0
    internal var numberOfSections:Int = 0
    ///返回某个节中的行数 默认0
    internal var numberOfRowsInSection:Int = 0
    ///tableview控件的行高 默认60
    internal var tableViewheightForRowAt:CGFloat=60
    ///heightForFooterInSection
    internal var heightForFooterInSection:CGFloat=0.01
    ///heightForHeaderInSection
    internal var heightForHeaderInSection:CGFloat=0.01
    ///tableView
    fileprivate var tableView:UITableView? = nil
    ///collection
    fileprivate var collection:UICollectionView? = nil
    ///自定义UICollectionView控件的头部视图 默认是为空的
    let CollectionHeadReusableIdentifier = "Curhead"
    
    // 顶部刷新
    var header = MJRefreshNormalHeader()
    // 底部刷新
    var footer = MJRefreshAutoNormalFooter()
    // 需要手动滑动的（自己处理事件)
    var Backfooter = MJRefreshBackNormalFooter()
    
    ///Tableview
    internal func InitCongif(_ tableView:UITableView){
        self.tableView=tableView
        tableView.delegate=self //设置代理
        tableView.dataSource=self   //设置数据源
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        self.tableView?.tableFooterView=UIView() //去除多余底部线条
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被NavigationController管理的自动留白
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction:#selector(CustomTemplateViewController.headerRefresh))
        self.tableView?.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction:#selector(CustomTemplateViewController.footerRefresh))
        self.tableView?.mj_footer = footer
        
        self.footer.isAutomaticallyHidden=true    //隐藏当前footer 会自动根据数据来隐藏和显示
    }
    
    ///Collection
    internal func InitCongifCollection(_ Collection:UICollectionView,_ viewClass: Swift.AnyClass?){
        self.collection=Collection
      
        Collection.delegate=self //设置代理
        Collection.dataSource=self   //设置数据源
        Collection.emptyDataSetSource = self;
        Collection.emptyDataSetDelegate = self;
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被NavigationController管理的自动留白
        //注册头
        Collection.register(viewClass == nil ? UICollectionReusableView.self : viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CollectionHeadReusableIdentifier)
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction:#selector(CustomTemplateViewController.headerRefresh))
        self.collection?.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction:#selector(CustomTemplateViewController.footerRefresh))
        self.collection?.mj_footer = footer
        
        self.footer.isAutomaticallyHidden=true    //隐藏当前footer 会自动根据数据来隐藏和显示
  
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被
        self.navigationController?.navigationBar.isTranslucent=true
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage().ImageWithColor(color: CommonFunction.SystemColor(), size: CGSize.init(width: CommonFunction.kScreenWidth, height: CommonFunction.NavigationControllerHeight)),for: UIBarMetrics.default)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {    //销毁页面
        debugPrint("CustomTemplateViewController 页面已经销毁")
    }
    
//    //视图即将消失
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage().ImageWithColor(color: CommonFunction.SystemColor(), size: CGSize.init(width: CommonFunction.kScreenWidth, height: CommonFunction.NavigationControllerHeight)),for: UIBarMetrics.default)
//    }
    // MARK: - 刷新、网络请求失败等函数
    ///刷新请求  参数1：isLoading 是否加载中 参数1：isLoadError 是否加载失败
    func RefreshRequest(isLoading:Bool,isHiddenFooter:Bool=false,isLoadError:Bool=false){
        self.isLoading=isLoading
        self.isLoadError=isLoadError
        if(tableView != nil ){
            self.tableView?.reloadEmptyDataSet()
            self.tableView?.reloadData() 
            self.footer.isHidden=isHiddenFooter
        }
        if(collection != nil ){
            self.collection?.reloadEmptyDataSet()
            self.collection?.reloadData()
            self.footer.isHidden=isHiddenFooter
        }
//        if(isLoading==false && isLoadError==false){
//            self.tableView?.mj_footer.isHidden=true
//            self.collection?.mj_footer.isHidden=true
//        }else if(isLoading==true && isLoading==false){
//            self.tableView?.mj_footer.isHidden=false
//            self.collection?.mj_footer.isHidden=false
//        } 
    }
    
    ///出错了点击事件
    func Error_Click(){
        
    }
    
    ///网络连接失败点击事件
    func NetWord_Click(){
        
    }
    
    
    // MARK: - 上拉下拉 刷新
    
    /// 顶部刷新
    func headerRefresh(){
        header.endRefreshing()
    }
    
    /// 底部刷新
    func footerRefresh(){
        footer.endRefreshing()
    }
    
    //-------------------------Tableview------------------------
    // MARK: - UITableViewDelegate,UITableViewDataSources 需要实现的函数
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewheightForRowAt
    }
    
    //返回节的个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    //返回某个节中的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    //为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        
    }
    //选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //-------------------------Coll------------------------
    // MARK: - UICollectionViewDelegate,UICollectionViewDataSource 需要实现的函数
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var   reusableview:UICollectionReusableView? = nil
        
        if (kind == UICollectionElementKindSectionHeader) { //头
            reusableview = self.collection?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CollectionHeadReusableIdentifier, for: indexPath)
        }
        
        return reusableview!
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        return UICollectionReusableView()
//    }
    
    //-------------------------emptyDataSet-------------------------
    // MARK: - UICollectionViewDelegate,UICollectionViewDataSource
    
    
    var Title_isLoadError_NetErrorTrue="好像连不上网络了"   ///加载出错时并且网络是失败时
    var Title_isLoadError_NetErrorFalse="我找不到数据了!"  ///加载出错时并且网络成功时
    var Title_isLoading_NetErrorTrue="好像连不上网络了"    ///加载时并且网络失败时
    var Title_isLoading_NetErrorFalse="努力加载中..."     ///加载时并且网络成功时
    var Title_text="我什么也没找到"                        ///显示标题文本
    var Title_NetErrorFalse="网络出现状况了"               ///正常访问断网时
    
    /**
     *  返回标题文字
     */
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let paragraph=NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let dic = [NSFontAttributeName:UIFont.systemFont(ofSize:14),
                   NSForegroundColorAttributeName:CommonFunction.RGBA(145, g: 148, b: 153),
                   NSParagraphStyleAttributeName:paragraph]
        if(self.isLoadError){   //加载出错时
            if(NetWordStatus==false){    //断网时
                return NSMutableAttributedString(string: Title_isLoadError_NetErrorTrue, attributes: dic)
            }
            return NSMutableAttributedString(string:Title_isLoadError_NetErrorFalse, attributes: dic)
        }
        if(isLoading){      //加载时
            if(NetWordStatus==false){    //断网时
                return NSMutableAttributedString(string: Title_isLoading_NetErrorTrue, attributes: dic)
            }
            return NSMutableAttributedString(string: Title_isLoading_NetErrorFalse, attributes: dic)
        }
        var text=Title_text
        if(NetWordStatus==false){    //断网时
            text=Title_NetErrorFalse
        }
        
        let attributes = NSMutableAttributedString(string: text, attributes: dic)
        
        return attributes
    }
    
    var Description_isLoadError_NetErrorTrue="网络好像有点跑不动了，查看下您的网络吧"   ///加载出错时并且网络是失败时
    var Description_isLoadError_NetErrorFalse="加载好像出错了!"  ///加载出错时并且网络成功时
    var Description_isLoading_NetErrorTrue="网络好像有点跑不动了，查看下您的网络吧"    ///加载时并且网络失败时
    var Description_isLoading_NetErrorFalse=""     ///加载时并且网络成功时
    var Description_text="我很努力加载数据了，但是还是没找到数据"                        ///显示标题文本
    var Description_NetErrorFalse="请检查网络是否正常连接"               ///正常访问断网时
    
    /**
     *  标题明细文字
     */
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let paragraph=NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let dic = [NSFontAttributeName:UIFont.systemFont(ofSize:12),
                   NSForegroundColorAttributeName:CommonFunction.RGBA(145, g: 148, b: 153),
                   NSParagraphStyleAttributeName:paragraph]
        
        if(self.isLoadError){   //加载出错时
            if(NetWordStatus==false){    //断网时
                return NSMutableAttributedString(string: Description_isLoadError_NetErrorTrue, attributes: dic)
            }
            return NSMutableAttributedString(string: Description_isLoadError_NetErrorFalse, attributes: dic)
        }
        if(isLoading){      //加载时
            if(NetWordStatus==false){    //断网时
                return NSMutableAttributedString(string: Description_isLoading_NetErrorTrue, attributes: dic)
            }
            return NSMutableAttributedString(string: Description_isLoading_NetErrorFalse, attributes: dic)
        }
        var text=Description_text
        if(NetWordStatus==false){    //断网时
            text=Description_NetErrorFalse
        }
        
        let attributes = NSMutableAttributedString(string: text, attributes: dic)
        
        return attributes
    }
    
    var ButtonTitle_isLoadError_NetErrorTrue="重新加载,点我试试？"   ///加载出错时并且网络是失败时
    var ButtonTitle_isLoadError_NetErrorFalse="重新加载,点我试试？"  ///加载出错时并且网络成功时
    var ButtonTitle_isLoading_NetErrorTrue="重新加载,点我试试？"    ///加载时并且网络失败时
    var ButtonTitle_isLoading_NetErrorFalse=""     ///加载时并且网络成功时
    var ButtonTitle_text=" "                        ///显示标题文本
    var ButtonTitle_NetErrorFalse="点击我重新刷新数据"               ///正常访问断网时
    /**
     *  按钮图标标题
     */
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let dic = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),
                   NSForegroundColorAttributeName:CommonFunction.RGBA(0, g: 185, b: 249)]
        if(self.isLoadError){  //加载出错时
            if(NetWordStatus==false){    //断网时
                return NSMutableAttributedString(string: ButtonTitle_isLoadError_NetErrorTrue, attributes: dic)
            }
            return NSMutableAttributedString(string: ButtonTitle_isLoadError_NetErrorFalse, attributes: dic)
        }
        if(isLoading){      //加载时
            if(NetWordStatus==false){    //断网时
                return NSMutableAttributedString(string: ButtonTitle_isLoading_NetErrorTrue, attributes: dic)
            }
            return NSMutableAttributedString(string: ButtonTitle_isLoading_NetErrorFalse, attributes: dic)
        }
        var text=ButtonTitle_text //我什么也没有,点我也没用
        if(NetWordStatus==false){    //断网时
            text=ButtonTitle_NetErrorFalse
        }
        
        let attributes = NSMutableAttributedString(string: text, attributes: dic)
        
        return attributes
    }
    
    /**
     *  按钮图标LOGO
     */
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        var imgname=""
        if(state == .normal){
            imgname=""
        }
        if(state == .highlighted){
            imgname=""
        }
        
        let capInsets:UIEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        let rectInsets:UIEdgeInsets  = UIEdgeInsets.zero
        
        let uiimage=UIImage(named: imgname)
        uiimage?.resizableImage(withCapInsets:capInsets, resizingMode:  .stretch)
        
        uiimage?.withAlignmentRectInsets(rectInsets)
        
        return  uiimage
    }
    
    var image_isLoadError_NetErrorTrue="placeholder_remote"   ///加载出错时并且网络是失败时
    var image_isLoadError_NetErrorFalse="placeholder_error"  ///加载出错时并且网络成功时
    var image_isLoading_NetErrorTrue="placeholder_remote"    ///加载时并且网络失败时
    var image_isLoading_NetErrorFalse="loading"     ///加载时并且网络成功时
    var image_text="placeholder_vesper"                        ///没有数据时图片
    /**
     *  返回图标LOGO
     */
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if(self.isLoadError){   //加载出错时
            if(NetWordStatus==false){    //断网时
                return UIImage(named: image_isLoadError_NetErrorTrue)     //断网
            }
            return UIImage(named: image_isLoadError_NetErrorFalse)
        }
        if(isLoading){      //加载时 
            if(NetWordStatus==false){    //断网时
                return UIImage(named: image_isLoading_NetErrorTrue)     //断网
            }
            return UIImage.gif(name: image_isLoading_NetErrorFalse)
        }
        let imgname=image_text //没有数据
        
        return UIImage(named: imgname)
    }
    /**
     *  返回垂直偏移量
     */
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0.0
    }    /**
     *  返回背景颜色
     */
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
    
    /**
     *  返回高度的间隙(空间)
     */
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 10.0
    }
    
    
    /**
     *  数据源为空时是否渲染和显示
     */
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    /**
     *  是否允许点击
     */
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    /**
     *  是否允许滚动
     */
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    /**
     *  空白处区域点击事件
     */
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        
        debugPrint("别点我,我是空白view点我干嘛？,我是在Deubg状态下才出来的哟")
        DispatchQueue.main.async(execute: {
            
        })
    }
    /**
     *  按钮点击事件
     */
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        debugPrint("点击到了按钮!,我是在Deubg状态下才出来的哟")
        if(isLoadError){    //网络出错时 
            Error_Click()
        }
        
    }
    
}
