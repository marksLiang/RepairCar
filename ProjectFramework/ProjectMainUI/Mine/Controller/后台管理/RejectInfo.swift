//
//  RejectInfo.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/11/8.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class RejectInfo: UIViewController {
    typealias CallbackValue=(_ value:String)->Void //类似于OC中的typedef
    var myCallbackValue:CallbackValue?  //声明一个闭包 类似OC的Block属性
    func  FuncCallbackValue(value:CallbackValue?){
        myCallbackValue = value //返回值
    }
    @IBOutlet weak var commentTextView: UITextView!
    @IBAction func rejectCallBack(_ sender: Any) {
        if commentTextView.text.characters.count == 0 {
            CommonFunction.HUD("请输入驳回信息", type: .error)
            return
        }else{
            if myCallbackValue != nil {
                myCallbackValue!(commentTextView.text)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBOutlet weak var showLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "驳回原因"
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被
        // Do any additional setup after loading the view.
        commentTextView.layer.cornerRadius = 5
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        commentTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension RejectInfo:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            showLabel.isHidden = true
        }else{
            showLabel.isHidden = false
        }
    }
    //取消键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if (commentTextView.text.characters.count == 0) {
            showLabel.isHidden = false
        }
    }
}
