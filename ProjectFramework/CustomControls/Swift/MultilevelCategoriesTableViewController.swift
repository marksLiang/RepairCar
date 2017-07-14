//
//  Multilevel+Categories+ViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/9/18.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import MJRefresh

class MultilevelCategoriesController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //类似于OC中的typedef
    typealias CallbackSelectedValue=(_ SelectedValue:Any)->Void
    //声明一个闭包
    var myCallbackValue:CallbackSelectedValue?
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    
    fileprivate var collection:UICollectionView? = nil
    fileprivate var SelectedRow = -1                //选中的行
    fileprivate var MenutableView:UITableView? = nil//定义菜单tableview
    fileprivate let MenuIdentifier="MenuCell"       //Indentifier标识
    fileprivate let ContentIdentifier="ContentCell"  //Indentifier标识
    // 数据集合  第一个[主标识,显示值]  如：[1,"我是菜单1"][2,"我是菜单1"]
    internal var MenuItemData=[[]]
    
    /// 菜单栏宽度   (默认100)
    internal var MenuViewWidth:CGFloat=100
    /// 菜单栏高度   (默认获取屏幕高度)
    internal var MenuViewHeight:CGFloat=UIScreen.main.bounds.size.height
    /// 行高  （默认50）
    internal var HeightRow:CGFloat=50
    /// 默认选中行   (默认0)
    internal var DefaultRow=0
    /// 显示文本颜色  (默认白色)
    internal var TextColor=UIColor.white
    /// 左边选中颜色样式条颜色设置   (默认青色)
    internal var LeftShowColor=UIColor.green
    /// 菜单颜色     (默认浅蓝)
    internal var MenuBackgroundColor=UIColor(red: 56/255, green: 181/255, blue: 254/255, alpha: 1)
    /// 选中的颜色   (默认白色)
    internal var SelectedBackgroundColor=UIColor.white
    /// 选中的文本颜色 (默认黑色)
    internal var SelectedTextColor=UIColor.black
    /// 是否显示线条 (默认不显示)
    internal var IsShowLine=false
    /// 线条颜色    (默认偏灰色)
    internal var LineColor=UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
    
    /**
     初始化配置
     */
    func InitCongif(frame:CGRect){ 
        //菜单tableview
        self.MenutableView=UITableView(frame:frame)
        self.MenutableView!.dataSource=self   //设置数据源
        self.MenutableView!.delegate=self
        self.MenutableView!.tableFooterView=UIView() //去除多余底部线条
        if(IsShowLine==false){   //如果不显示线条
            self.MenutableView!.separatorStyle = .none  //去除线条
        }
        self.MenutableView!.showsVerticalScrollIndicator=false //不显示滚动条
        self.MenutableView!.register(MultilevelCategoriesTableViewCell.self, forCellReuseIdentifier: MenuIdentifier)
        self.view.addSubview(MenutableView!) //添加tableView
        
        if(MenuItemData.count>0){
            //默认选中第一行
                self.tableView(self.MenutableView!, didSelectRowAt: IndexPath.init(row: DefaultRow, section: 0))
            
        }
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MenuItemData.removeAll()
        self.view.backgroundColor=UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeightRow
    }
    //返回Tableview节的个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //返回Tableview某个节中的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItemData.count
    }
    //为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.MenutableView!.register(MultilevelCategoriesTableViewCell.self, forCellReuseIdentifier: MenuIdentifier)
        let  cell = tableView.dequeueReusableCell(withIdentifier: MenuIdentifier, for: indexPath) as! MultilevelCategoriesTableViewCell
        var IsLeftShowColor=false
        if(SelectedRow==(indexPath as NSIndexPath).row){ //选中显示
            IsLeftShowColor=true    //显示
        }
        let text = MenuItemData[(indexPath as NSIndexPath).row][1] as! String
        cell.Initconfig(text,textColor: TextColor,isLeftShowColor: IsLeftShowColor,leftShowColor: LeftShowColor,MenuBackgroundColor: MenuBackgroundColor,SelectedBackgroundColor: SelectedBackgroundColor,SelectedTextColor: SelectedTextColor,isshowLine: IsShowLine,LineColor: LineColor)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(SelectedRow==(indexPath as NSIndexPath).row){ //判断是否重复按相同的行
            return
        }
        SelectedRow=(indexPath as NSIndexPath).row
        self.MenutableView!.reloadData()
        if(myCallbackValue != nil){
            myCallbackValue!(SelectedValue:MenuItemData[indexPath.row])
        }
    }
    
     
}

class MultilevelCategoriesTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /**
     
     
     - parameter text:                    显示的菜单文本
     - parameter textColor:               显示的菜单文本颜色
     - parameter isLeftShowColor:         是否显示选中的左边样式条
     - parameter leftShowColor:           显示选中的左边样式条颜色
     - parameter MenuBackgroundColor:     菜单背景颜色
     - parameter SelectedBackgroundColor: 选中的背景颜色
     - parameter SelectedTextColor:       选中的文本颜色
     - parameter isshowLine:              是否显示线条
     - parameter LineColor:               线条颜色
     */
    func Initconfig(_ text:String,textColor:UIColor,isLeftShowColor:Bool,leftShowColor:UIColor,  MenuBackgroundColor:UIColor,SelectedBackgroundColor:UIColor,SelectedTextColor:UIColor,isshowLine:Bool,LineColor:UIColor) {
        
        self.selectionStyle = .none
        //        self.backgroundColor=MenuBackgroundColor
        self.backgroundColor=MenuBackgroundColor
        
        for i in self.contentView.subviews {
            i.removeFromSuperview()
        }
        //选中的颜色快
        let ColorLab=UILabel(frame: CGRect(x: 2, y: self.contentView.frame.height/4, width: 5 ,height: self.contentView.frame.height/2 ))
        
        ColorLab.backgroundColor=leftShowColor
        //内容
        let lab=UILabel(frame: CGRect(x: ColorLab.frame.maxX, y: 0, width: self.contentView.frame.width-ColorLab.frame.maxX-1,height: self.contentView.frame.height ))
        lab.text=text
        lab.textAlignment = .center
        lab.font=UIFont.systemFont(ofSize: 13)
        lab.textColor=textColor
        //右边线条
        let rightLine=UILabel(frame: CGRect(x: lab.frame.maxX, y: 0, width: 1 ,height: self.contentView.frame.height))
        rightLine.backgroundColor=LineColor
        rightLine.isHidden=false
        if(isLeftShowColor==true){  //选中的状态
            self.contentView.addSubview(ColorLab)
            rightLine.isHidden=true
            lab.textColor=SelectedTextColor
            self.backgroundColor=SelectedBackgroundColor   //更改当前选择的颜色
        }
        //添加文本内容
        self.contentView.addSubview(lab)
        
        if(isshowLine==true){   //如果显示线条
            self.contentView.addSubview(rightLine)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
