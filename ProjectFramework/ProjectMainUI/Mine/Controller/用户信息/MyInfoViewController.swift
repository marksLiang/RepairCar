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
    
    var viewModel = MyinfoViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="个人信息"
        self.tableView.tableFooterView=UIView() //去除多余底部线条
        self.pic.layer.cornerRadius = self.pic.frame.width / 2
        self.pic.clipsToBounds = true
        //添加保存按钮
        let item = UIBarButtonItem(title: "保存 ", style: .plain, target: self, action: #selector(MyInfoViewController.Save))
        self.navigationItem.rightBarButtonItem=item
        
        
        let image = UIImage.init(named: "默认头像")
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
                let data = UIImageJPEGRepresentation(self.pic.image!, 0.9)!
                CommonFunction.HUD("上传头像中...", type: .load)
                self.viewModel.SetImageUpload(datas: [data], Model: { (model) in
                    CommonFunction.HUDHide()
                    if model?.Success == true {
                        if model?.Content != nil {
                            let imagePathList = model?.Content as! [String]
                            print(HttpsUrlImage+imagePathList[0])
                            Global_UserInfo.ImagePath = imagePathList[0]
                            CommonFunction.ExecuteUpdate("update MemberInfo set UserID = (?), Phone = (?) , Token = (?), IsLogin = (?) ,UserName=(?),Sex=(?),ImagePath=(?),UserType=(?)",
                                                         [Global_UserInfo.UserID as AnyObject
                                                            ,Global_UserInfo.Phone as AnyObject
                                                            ,"" as AnyObject
                                                            ,true as AnyObject
                                                            ,Global_UserInfo.UserName as AnyObject
                                                            ,Global_UserInfo.Sex as AnyObject
                                                            ,Global_UserInfo.ImagePath as AnyObject
                                                            ,Global_UserInfo.UserType as AnyObject
                                ], callback: nil )
                        }
                        CommonFunction.HUD("上传成功", type: .success)
                    }
                })
                
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
        viewModel.SetUpdateUserInfo(UserID: Global_UserInfo.UserID, UserName: name.text!, ImagePath: Global_UserInfo.ImagePath, Sex: sex.text!, Phone: phone.text!) { (result) in
            if result == true {
                CommonFunction.HUD("保存成功", type: .success)
            }else{
                CommonFunction.HUD("保存失败", type: .error)
            }
        }
        
    }
    
}
