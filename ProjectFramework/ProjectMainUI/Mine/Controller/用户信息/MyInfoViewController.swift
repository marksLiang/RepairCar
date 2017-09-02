//
//  MyInfoViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/16.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import SDWebImage
import AFNetworking

class MyInfoViewController: UITableViewController {
    
    @IBOutlet weak var pic: UIImageView!    //图片
    @IBOutlet weak var name: UILabel!       //姓名
    @IBOutlet weak var sex: UILabel!        //性别
    @IBOutlet weak var phone: UILabel!      //电话
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="个人信息"
        self.tableView.tableFooterView=UIView() //去除多余底部线条
        self.pic.layer.cornerRadius = self.pic.frame.width / 2
        self.pic.clipsToBounds = true
        //添加保存按钮
        let item = UIBarButtonItem(title: "保存 ", style: .plain, target: self, action: #selector(MyInfoViewController.Save))
        self.navigationItem.rightBarButtonItem=item
        let image = UIImage.init(named: "userIcon_defualt")
        self.pic.image = image
        if(Global_UserInfo.IsLogin==true){
            
            self.pic.sd_setImage(with:URL(string:HttpsUrlImage+Global_UserInfo.ImagePath), placeholderImage:  UIImage(named: placeholderImage) ,options:  SDWebImageOptions.retryFailed) { (UIImage, NSError, SDImageCacheType, NSURL) -> Void in
                if(UIImage != nil){
                    self.pic.image=UIImage
                }
                else{
                    
                    
                }
                
            }
            name.text=Global_UserInfo.UserName
            sex.text=Global_UserInfo.Sex
            phone.text=Global_UserInfo.Phone
        }else{
            
            name.text=""
            sex.text=""
            phone.text=""
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //选择时
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch((indexPath as NSIndexPath).row){
        case 0 :    //头像
            CommonFunction.CameraPhotoAlertController(self, Camera_Callback: { (img) in
                self.pic.image=img
            })
            break
        case 1 :    //姓名
            ShowModifyValue(name.text!, Callback_Value: { (value) in
                self.name.text=value
            })
            break
        case 2 :    //性别
            SexSelected(sex)
            break
        case 3 :    //联系号码
            ShowModifyValue(phone.text!, Callback_Value: { (value) in
                self.phone.text=value
            })
            break
        default:break
        }
        
    }
    
    
    fileprivate func ShowModifyValue(_ DataSource:String, Callback_Value: ((_ value:String)->Void)?){
        
        //封装好的修改界面
        let vc = ModifyViewController(DataSource: DataSource) { (value) in
            Callback_Value!(value)
        }
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    //性别选择
    fileprivate func SexSelected(_ sex:UILabel){
        let alertController = UIAlertController(title: "性别选择", message: "", preferredStyle: .actionSheet)
        let CameraAction = UIAlertAction(title: "男", style: .default) { (UIAlertAction) in
            sex.text="男"
        }
        alertController.addAction(CameraAction)
        let PhotoAction = UIAlertAction(title: "女", style: .destructive) { (UIAlertAction) in
            sex.text="女"
        }
        alertController.addAction(PhotoAction)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (UIAlertAction) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //保存
    func Save(){
//        let data = UIImageJPEGRepresentation(pic.image!, 0.9)!
//        let http = MyinfoHttps()
//        CommonFunction.HUD("数据保存中...", type: .load)
//        http.UpUserInfo(data: data, parameters: ["UserID":Global_UserInfo.userid,"RealName":name.text! ,"Sex":sex.text!,"Phone":phone.text!] ) { (model) in
//            CommonFunction.HUDHide()
//            if(model?.Success==true){
//                Global_UserInfo.RealName=self.name.text!
//                Global_UserInfo.Sex=self.sex.text!
//                Global_UserInfo.HeadImgPath=model?.Content! as! String
//                Global_UserInfo.PhoneNo=self.phone.text!
//                CommonFunction.ExecuteUpdate("update MemberInfo  set RealName=(?),Sex=(?),HeadImgPath=(?),PhoneNo=(?)  ", [
//                    Global_UserInfo.RealName as AnyObject,
//                    Global_UserInfo.Sex as AnyObject,
//                    Global_UserInfo.HeadImgPath as AnyObject,
//                    Global_UserInfo.PhoneNo as AnyObject,
//                    ], callback: nil)
//                
//                CommonFunction.HUD("保存成功", type: .success)
//            }else{
//                CommonFunction.HUD("保存失败", type: .error) 
//            }
//        }
        
    }
    
}
