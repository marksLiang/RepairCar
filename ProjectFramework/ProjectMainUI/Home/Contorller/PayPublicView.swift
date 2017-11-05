//
//  PayPublicView.swift
//  ProjectFramework_Tourism
//
//  Created by 住朋购友 on 2017/5/5.
//  Copyright © 2017年 HCY. All rights reserved.
//

import Foundation

enum payResultTepy{
    case success//支付成功
    case felid//支付失败
    case error//支付错误
}

class PayClass:UIViewController {
    
    typealias CallbackValue=( _ result:payResultTepy)->Void //类似于OC中的typedef
    var myCallbackValue:CallbackValue?  //声明一个闭包 类似OC的Block属性
    func  FuncCallbackValue(value:CallbackValue?){
        myCallbackValue = value //返回值
    }
    
    fileprivate  var menu:HcdPopMenuView?
    fileprivate weak var delegate:UIViewController?=nil
    fileprivate var OrderType = 0//1查看店铺2查看需求3发布需求
    var OtherID = 0
    var model:RepairShopModel?=nil
    init(OrderType:Int,delegate:UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.delegate=delegate
        self.OrderType = OrderType
        view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.01)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .custom
        //添加通知  支付完成\未完成等的通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.PayResultStatus), name: NSNotification.Name(rawValue: ZFBPayNoticeResultStatus), object: nil)
        let items: [Any] = [[kHcdPopMenuItemAttributeTitle: "微信支付", kHcdPopMenuItemAttributeIconImageName: "WXlogo"],
                            [kHcdPopMenuItemAttributeTitle: "支付宝", kHcdPopMenuItemAttributeIconImageName: "ZFBlogo"]]
        
        menu = HcdPopMenuView(items: items)
        menu?.setSelectCompletionBlock({[weak self]  (index) in //点击按钮Item
            //index 0微信 1支付宝
            self?.pay(payTepy: index)
        })
        menu?.setSelectbgCompletionBlock({ [weak self](index) in    //点击X 或者背景
            self?.dismiss(animated: false, completion: nil)
        })
        
        menu?.setTipsLblByTipsStr("支付声明，本次支付只收取信息服务费，具体维修费用则由车主与店家私下协商")
        menu?.setExitViewImage("center_exit")
    }
    
    func pay(payTepy:Int) -> Void {
        var parameters=["OrderType":self.OrderType,"OtherID":self.OtherID,"CityName":CurrentCity,"UserID":Global_UserInfo.UserID] as [String : Any]
        if payTepy == 0 {
           parameters["PayType"]=2
        }
        else if payTepy == 1 {
           parameters["PayType"]=1
        }
        CommonFunction.Global_Post(entity: nil, IsListData: false, url: HttpsUrl + "api/Pay/SetPay", isHUD: true, HUDMsg: "正在请求", isHUDMake: false, parameters: parameters as NSDictionary) { (resultData) in
            if(resultData?.Success==true){
                print(resultData?.Content as Any)
                if resultData?.Content != nil {
                    self.AliplayFunc(OrderString: resultData?.Content as! String)
                }else{
                    CommonFunction.HUD(resultData!.Result, type: .error)
                }
            }else{
                CommonFunction.HUD(resultData!.Result, type: .error)                
                self.menu?.menuItemdismiss()
                self.dismiss(animated: false, completion: nil)
            }
        }

    }
    //跳转支付宝
    func AliplayFunc(OrderString:String){
        
        if(  OrderString != "" ){
            AlipaySDK.defaultService().payOrder(OrderString, fromScheme: ZFBAppScheme, callback: { (resultDic) -> Void in
                print("aaa:\(String(describing: resultDic))")
            })
        }
        
    }
    
    //利用KVO来改变该属性的值   ---支付宝
    @objc internal func  PayResultStatus(notification:NSNotification){
        let dic = notification.userInfo as! [String:Any]
        let resultStatus =  dic["resultStatus"] as! String
        var paytype:payResultTepy!=nil
        if resultStatus == "9000"{
            print("OK,支付完成")
//            self.delegate?.navigationController?.popToRootViewController(animated: true)
            
            switch self.OrderType {
            case 1:
                let vc = CommonFunction.ViewControllerWithStoryboardName("ShopDetail", Identifier: "ShopDetail") as! ShopDetail
                vc.model = self.model
                self.delegate?.navigationController?.show(vc, sender: self)
                break;
            case 3,4:
                paytype = payResultTepy.success
                break;
            default:
                break;
            }
            CommonFunction.MessageNotification("您已支付成功", interval: 2, msgtype: .success)
        }else if resultStatus == "8000" {
            print("正在处理中")
        }else if resultStatus == "4000" {
            paytype = payResultTepy.felid
            print("订单支付失败")
            CommonFunction.MessageNotification("支付失败，订单已生成，请到我的订单查看", interval: 3, msgtype: .error)
        }else if resultStatus == "6001" {
            paytype = payResultTepy.error
            print("用户中途取消")
//            self.delegate?.navigationController?.popToRootViewController(animated: true)
            // self.delegate?.navigationController.pop
            CommonFunction.MessageNotification("您已取消支付", interval: 2, msgtype: .error)
        }else if resultStatus == "6002" {
            paytype = payResultTepy.error
            print("网络连接出错")
        }
        if myCallbackValue != nil {
            myCallbackValue!(paytype)
        }
        self.menu?.menuItemdismiss()
        self.dismiss(animated: false, completion: nil)
        
    }
    
    deinit {    //销毁当前通知 通道
        print("deinit 进入了")
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
}
