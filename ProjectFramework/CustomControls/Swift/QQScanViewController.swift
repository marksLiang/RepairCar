//
//  QQScanViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/10.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import swiftScan

class QQScanViewController: LBXScanViewController {
    
    
    /**
     @brief  扫码区域上方提示文字
     */
    var topTitle:UILabel?
    
    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash:Bool = false
    
    // MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
    
    //底部显示的功能项
    var bottomItemsView:UIView?
    
    //相册
    var btnPhoto:UIButton = UIButton()
    
    //闪光灯
    var btnFlash:UIButton = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)
        
        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
        
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        self.scanStyle = style
        self.title="扫描"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        drawBottomItems()
    }
    
    
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        
        for result:LBXScanResult in arrayResult
        {
            debugPrint("%@",result.strScanned as Any)
        }
        
        let result:LBXScanResult = arrayResult[0] 
        
        debugPrint(result)
//        let vc = MCWebViewController(url:result.strScanned!,ProcesscColor:CommonFunction.RGBA(0, g: 132, b: 235))
//        self.navigationController?.show(vc, sender: true)
    }
    
    
    func drawBottomItems()
    {
        if (bottomItemsView != nil) {
            
            return;
        }
        
        let yMax = self.view.frame.maxY - self.view.frame.minY
        
        bottomItemsView = UIView(frame:CGRect(x: 0.0, y: yMax-100,width: self.view.frame.size.width, height: 100 ) )
        
        
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        self.view .addSubview(bottomItemsView!)
        
        
        let size = CGSize(width: 65, height: 87);
        
        
        self.btnPhoto = UIButton()
        btnPhoto.frame=CGRect(x: (bottomItemsView!.frame.width/2)-(size.width*1), y: 0, width: size.width, height: size.height)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_nor"), for: UIControlState.normal)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_down"), for: UIControlState.highlighted)
        btnPhoto.addTarget(self, action: #selector(LBXScanViewController.openPhotoAlbum), for: UIControlEvents.touchUpInside)
        
        self.btnFlash = UIButton()
        btnFlash.frame=CGRect(x: btnPhoto.frame.maxX+5, y: 0, width: size.width, height: size.height)
        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        btnFlash.addTarget(self, action: #selector(QQScanViewController.openOrCloseFlash), for: UIControlEvents.touchUpInside)
        
        
        
        
        
        bottomItemsView?.addSubview(btnPhoto)
        bottomItemsView?.addSubview(btnFlash)
        self.view .addSubview(bottomItemsView!)
        
    }
    
    //开关闪光灯
    func openOrCloseFlash()
    {
        scanObj?.changeTorch();
        
        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControlState.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        }
    }
    
}


