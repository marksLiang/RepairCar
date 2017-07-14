//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit


private var _percentage:Float = 0
typealias Callback_CameraPhotoValue=(_ value:UIImage)->Void//相机回调 声明一个闭包
var  CallbackCameraPhotoValue:Callback_CameraPhotoValue?//声明一个闭包
extension UIViewController:SKStoreProductViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,TZImagePickerControllerDelegate   {
    
        
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        //应用跳转到AppStore进来的
        viewController.dismiss(animated: true, completion: nil)
    }
    /**
     相机相册选择
     
     - parameter call: 回调图片
     */
    func ShowCameraPhotoSheet(_ call:@escaping Callback_CameraPhotoValue){
        CallbackCameraPhotoValue=call
        var Method:UIAlertControllerStyle
        Method=UIAlertControllerStyle.actionSheet
        
        let alertController = UIAlertController(title: "选择图片", message: "", preferredStyle: Method)
        
        //相机
        let CameraAction = UIAlertAction(title: "相机", style: UIAlertActionStyle.default) { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()//创建图片控制器
                picker.delegate = self//设置代理
                picker.sourceType = UIImagePickerControllerSourceType.camera//设置来源
                picker.allowsEditing = true //允许编辑
                self.present(picker, animated: true, completion: nil)//打开相机
            }else{
                CommonFunction.HUD("该设备不支持摄像", type: MsgType.error)
            }
        }
        alertController.addAction(CameraAction)
        
        //相册
        let PhotoAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.default) { (UIAlertAction) in
            
            let vc = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: false)
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
        alertController.addAction(PhotoAction)
        
        //取消
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (UIAlertAction) in
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        

    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if(picker.allowsEditing==true){
            //剪切图片
            if(CallbackCameraPhotoValue != nil){
                CallbackCameraPhotoValue!((info[UIImagePickerControllerEditedImage] as? UIImage)!)
                CallbackCameraPhotoValue=nil
            }
            picker.dismiss(animated: true, completion: nil)
        }else{
            //未剪切
            if(CallbackCameraPhotoValue != nil){
                CallbackCameraPhotoValue!((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
                CallbackCameraPhotoValue=nil
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @nonobjc public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        CallbackCameraPhotoValue=nil
    }
    
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        if(CallbackCameraPhotoValue != nil){
            CallbackCameraPhotoValue!(photos[0])
            CallbackCameraPhotoValue=nil
        }
    }
    
    
}

                                            
