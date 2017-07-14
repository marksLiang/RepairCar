//
//  ForgotPasswordController.swift
//  Cloudin
//
//  Created by 住朋购友 on 2017/3/27.
//  Copyright © 2017年 子轩. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa



class ForgotPasswordController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    let  Identifier = "ForgotPasswordViewCell"
    fileprivate let disposeBag   = DisposeBag() //创建一个处理包（通道）
    let _ForgotPasswordViewModel = ForgotPasswordViewModel()   //数据处理 (VM)
    
    ///返回 按钮
    lazy var backbtn:UIButton =
        {
            let btn = UIButton(frame: CGRect(x: 5, y: 22, width: 50, height: 43))
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitle(  "X",   for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.rx.tap.subscribe(
                onNext:{  [weak self] in
                    self?.dismiss(animated: true, completion: nil)
            }
                ).addDisposableTo(self.disposeBag)
            return btn
    }()
    
    ///保存 按钮
    lazy var ForgotPasswordbtn:UIButton =
        {
            let btn = UIButton(frame: CGRect(x: 20, y: 5, width: self.view.bounds.width-40, height: 35))
            btn.backgroundColor=UIColor.red
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitle(  "保  存",   for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.layer.cornerRadius=4
            btn.layer.masksToBounds=true
            btn.rx.tap
                .bind(to: self._ForgotPasswordViewModel.SaveEvent)  //绑定事件 (点击注册)
                .addDisposableTo(self.disposeBag)
            
            return btn
    }()
    
    ///头部view
    lazy var HeaderView:UIView =
        {
            let _HeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64))
            _HeaderView.backgroundColor=CommonFunction.SystemColor()
            
            let imgWh:CGFloat=90
            let title = UILabel(frame: CGRect(x: self.view.bounds.width/2-imgWh/2, y: 22, width:imgWh, height: 44))
            title.text="忘记密码"
            title.font=UIFont.systemFont(ofSize: 16)
            title.textColor = UIColor.white
            _HeaderView.addSubview(title)  //添加标题
            _HeaderView.addSubview(self.backbtn)  //添加返回按钮
            return _HeaderView
    }()
    
    ///tableivew
    lazy var tableView:UITableView =
        {
            let tableview = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height))
            tableview.dataSource=self
            tableview.delegate=self
            tableview.register(ForgotPasswordCell.self, forCellReuseIdentifier: self.Identifier)  //注册tableview
            let footview=UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
            footview.addSubview(self.ForgotPasswordbtn)
            tableview.tableFooterView=footview
            return tableview
    }()
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        self.view.addSubview(HeaderView)    //添加头部view
        self.view.addSubview(tableView) //添加tableview
        //点击背景收起键盘
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .addDisposableTo(  disposeBag)
        self.view.addGestureRecognizer(tapBackground)
        //ForgotPasswordResult()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier, for: indexPath) as! ForgotPasswordCell
        
        cell.selectionStyle = .none
        
        switch indexPath.row
        {
        case 0:
            cell.lab.text="手机号"
            cell.VerificationCode=true
            cell.inpuText.placeholder="请输入手机号码"
            cell.inpuText.rx.text.orEmpty
                .bind(to: _ForgotPasswordViewModel.username) //手机号绑定
                .addDisposableTo(disposeBag) 
            _ =  _ForgotPasswordViewModel.VerificationCodeEvent1=cell
            cell.VerificationCodeBtn.rx.tap
                .bind(to: _ForgotPasswordViewModel.VerificationCodeEvent)
                .addDisposableTo(disposeBag)
            
            break
        case 1:
            cell.lab.text="验证码"
            cell.inpuText.placeholder="请输入验证码"
            cell.inpuText.rx.text.orEmpty
                .bind(to: _ForgotPasswordViewModel.VerificationCode)
                .addDisposableTo(disposeBag)
            break
        case 2:
            cell.lab.text="新密码"
            cell.inpuText.placeholder="请输入新密码"
            cell.inpuText.keyboardType = .phonePad
            cell.inpuText.rx.text.orEmpty
                .bind(to: _ForgotPasswordViewModel.password)
                .addDisposableTo(disposeBag)
       
            break
        case 3:
            cell.inpuText.isEnabled=false
            break
        default:
            break
        }
        
        if(indexPath.row<5){
            cell.initConfig( )
        }
        
        return cell
    }
    
    
    //注册返回数据
    func ForgotPasswordResult(){
        
        _ = self._ForgotPasswordViewModel.SaveResult?.subscribe(onNext: { (result) in
            switch result {
            case   .ok: //处理登录成功的业务
                self._ForgotPasswordViewModel.SetOK()
                break
            case   .empty:
                print("空值判断")
                break
            case   .error:
                print("error")
                break
            }
        }).addDisposableTo(self.disposeBag)
    }
    
    
    deinit {
        debugPrint("忘记密码页面销毁")
    }
    
    
}
