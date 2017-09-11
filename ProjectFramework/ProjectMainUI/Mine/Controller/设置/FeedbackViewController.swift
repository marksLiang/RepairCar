//
//  FeedbackViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/16.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import RxSwift

class FeedbackViewController: UIViewController,UITextFieldDelegate ,UITextViewDelegate {

    fileprivate let disposeBag   = DisposeBag() //创建一个处理包（通道）
    let _FeedbackViewModel = FeedbackViewModel()   //数据处理 (VM)
    
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var promptLable: UILabel!//textview文本提示文本
    @IBOutlet weak var contactLable: UITextField!//联系文本
    @IBOutlet weak var showCount: UILabel!
    @IBOutlet weak var submit: UIButton!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        _FeedbackViewModel.delegate = self
        self.initUI()
        
        commentTextView.rx.text.orEmpty
            .bind(to: _FeedbackViewModel.Description) //绑定
            .addDisposableTo(disposeBag)
        
        contactLable.rx.text.orEmpty
            .bind(to: _FeedbackViewModel.QQPhone) //绑定
            .addDisposableTo(disposeBag)
        
        submit.rx.tap
            .bind(to: self._FeedbackViewModel.Event)  //绑定事件 (点击)
            .addDisposableTo(self.disposeBag)
        
         Result()   //点击按钮后接收的数据返回
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initUI() -> Void {
        self.title="意见反馈"
        
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被
        self.view.backgroundColor = UIColor.white
        commentTextView.layer.cornerRadius = 5
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        contactLable.layer.cornerRadius = 4
        contactLable.layer.borderWidth = 0.5
        contactLable.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        commentTextView.delegate = self
        contactLable.delegate = self
        
    }
    //MARK: UITextViewDelegate
    //检测到textView为空时，隐藏键盘
    func textViewDidChange(_ textView: UITextView) {
        if (commentTextView.text == "") {
            commentTextView.resignFirstResponder()
            promptLable.isHidden = false
        }
        else{
//            commentTextView.text.characters.count
            let num = 500 - commentTextView.text.characters.count
            showCount.text = "\(num)/500"
        }
    }
    //开始编辑，隐藏lable
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        promptLable.isHidden = true
        return true
    }
    //取消键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if (commentTextView.text.characters.count == 0) {
            promptLable.isHidden = false
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location >= 500 {
            return false
        }
        else {
            return true
        }
    }
    
    //返回数据
    func Result(){
        _ = self._FeedbackViewModel.Result?.subscribe(onNext: {(result) in
            
        }).addDisposableTo(self.disposeBag)
    }
    
    deinit {
        debugPrint("释放了 ")
    }

}
