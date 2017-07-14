//
//  ScreeningView.swift
//  ProjectFramework
//
//  Created by hcy on 2017/3/12.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

import DOPDropDownMenu_Enhanced


class MenuView: UIView,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate {
    
    typealias CallbackSelectedValue=(_ name:String,_ value:String, _ type:Int)->Void
    
    //声明一个闭包
    fileprivate  var myCallbackValue:CallbackSelectedValue?
    //下面这个方法需要传入上个界面的函数指针
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    
    var menu = DOPDropDownMenu()    // 菜单
    
    fileprivate var index=0 //第一次加载数据的索引
    fileprivate  var isLoadMenu=false    //是否加载菜单完成？
    
    fileprivate var  _MenuValue = [MenuModel]() //菜单数据模型
    
    func AddMenuData(_ model:MenuModel){
        _MenuValue.append(model)
    }
    
    fileprivate weak var delegate:UIViewController?=nil
    
    init(delegate:UIViewController ,frame: CGRect) {
        let _frame = CGRect(x: 0, y: frame.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.delegate=delegate
        super.init(frame: _frame)
        self.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        menu = DOPDropDownMenu(origin: CGPoint(x: 0,y:0), andHeight: frame.height)
        menu.isClickHaveItemValid=true
        menu.delegate=self
        menu.dataSource=self
        menu.fontSize=12
        self.addSubview(menu)
    }
    
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func menureloadData()  {
        menu.reloadData()
    }
    
    //返回当前显示的MenuTitle列总数
    func numberOfColumns(in menu: DOPDropDownMenu!) -> Int {
        return  _MenuValue.count
    }
    
    // 返回 menu 第column列有多少行  （一级
    func menu(_ menu: DOPDropDownMenu!, numberOfRowsInColumn column: Int) -> Int {
        if(column>=0){
            let value  = _MenuValue[column]
            return value.OneMenu.count
        }
        
        return 0
    }
    // 返回 menu 第column列有多少行  （二级
    func menu(_ menu: DOPDropDownMenu!, numberOfItemsInRow row: Int, column: Int) -> Int {
        
        let value  = _MenuValue[column]
        if(value.OneMenu[row].TowMenu.count==0){
            return -1
        }
        return  value.OneMenu[row].TowMenu.count
        
    }
    
    
    // 返回 menu 第column列 每行title （一级
    func menu(_ menu: DOPDropDownMenu!, titleForRowAt indexPath: DOPIndexPath!) -> String! {
        if(isLoadMenu){
            //每当点击菜单的时候
            let title = _MenuValue[indexPath.column]
            if(title.OneMenu[indexPath.row].name=="" ||
                title.OneMenu[indexPath.row].name==nil){
                return "无数据"
            }
            else{
                return title.OneMenu[indexPath.row].name    //把点击菜单的OneMenu全部显示出来
            }
            
        }
        //第一次加载菜单的时候
        let title = _MenuValue[index]
        index+=1
        if(index==_MenuValue.count){
            isLoadMenu=true
        }
        return title.OneMenu[0].name    //添加数据显示 (显示第一个onemenu)
    }
    
    // 返回 menu 第column列 每行title （二级
    func menu(_ menu: DOPDropDownMenu!, titleForItemsInRowAt indexPath: DOPIndexPath!) -> String! {
        
        let title = _MenuValue[indexPath.column]
        if(title.OneMenu[indexPath.row].TowMenu[indexPath.row].name=="" ||
            title.OneMenu[indexPath.row].TowMenu[indexPath.row].name==nil){
            
            return "无数据"
        }
        else{
            let value = title.OneMenu[indexPath.row].TowMenu[indexPath.item].name   //把点击菜单的TowMenu全部显示出来
            return value
        }
        
    }
    //一级菜单图片(文字左边logo
    func menu(_ menu: DOPDropDownMenu!, imageNameForRowAt indexPath: DOPIndexPath!) -> String! {
        let title = _MenuValue[indexPath.column]
        if(title.OneMenu[indexPath.row].image=="" ||
            title.OneMenu[indexPath.row].image==nil){
            return ""
        }
        return title.OneMenu[indexPath.row].image
    }
    //二级菜单图片(文字左边logo
    func menu(_ menu: DOPDropDownMenu!, imageNameForItemsInRowAt indexPath: DOPIndexPath!) -> String! {
        let title = _MenuValue[indexPath.column]
        if(title.OneMenu[indexPath.row].TowMenu[indexPath.row].image=="" ||
            title.OneMenu[indexPath.row].TowMenu[indexPath.row].image==nil){
            
            return "无数据"
        }
        
        return title.OneMenu[indexPath.row].TowMenu[indexPath.item].image
        
    }
    
    //一级菜单 右边带有数字
    func menu(_ menu: DOPDropDownMenu!, detailTextForRowAt indexPath: DOPIndexPath!) -> String! {
       // let value  = _MenuValue[indexPath.column]
//        return  value.OneMenu[indexPath.row].TowMenu.count.description  //获取二级列表的总数
        return ""
    }
    //二级菜单 右边带有数字
    func menu(_ menu: DOPDropDownMenu!, detailTextForItemsInRowAt indexPath: DOPIndexPath!) -> String! {
        
        return ""
    }
    //选择
    func menu(_ menu: DOPDropDownMenu!, didSelectRowAt indexPath: DOPIndexPath!) {
         
        let title = _MenuValue[indexPath.column]
        if(title.OneMenu[indexPath.row].TowMenu.count==0){
            //一级菜单
            //            print(title.OneMenu[indexPath.row].name)
            if(myCallbackValue != nil){
                myCallbackValue!(title.OneMenu[indexPath.row].name!,title.OneMenu[indexPath.row].value!,title.OneMenu[indexPath.row].type!)
            }
        }
        else{//选中二级
            if(indexPath.item>=0){
                myCallbackValue!(title.OneMenu[indexPath.row].TowMenu[indexPath.item].name!,title.OneMenu[indexPath.row].TowMenu[indexPath.item].value!,title.OneMenu[indexPath.row].TowMenu[indexPath.item].type!)
            }
        }
    }
    
    func menu(_ IsOpenItmes: Bool) {
        if(IsOpenItmes==true){
            delegate?.view.bringSubview(toFront: self)
        }else{
            
            delegate?.view.sendSubview(toBack:self )
        }
    }
    
    
    
}
