//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit



extension UIImage{
    ///设置图片透明度
    func ImageByApplyingAlpha(_ alpha: CGFloat, image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        let area: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -area.size.height)
        ctx.setBlendMode(.multiply)
        ctx.setAlpha(alpha)
        ctx.draw(image.cgImage!, in: area)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    ///改变图片大小
    func ImageCompressForWidth(_ sourceImage: UIImage, targetWidth defineWidth: CGFloat) -> UIImage {
        let imageSize: CGSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = defineWidth
        let targetHeight: CGFloat = (targetWidth / width) * height
        UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    ///通过颜色来转换uiimage  
    func ImageWithColor(color:UIColor,size:CGSize)->UIImage{
     let   rect =  CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    
    ///传入图片image回传对应的base64字符串,默认不带有data标识,
    func imageToBase64String(headerSign:Bool = false)->String?{
        
        ///根据图片得到对应的二进制编码
        guard let imageData = UIImagePNGRepresentation(self) else {
            return nil
        }
        
        ///根据二进制编码得到对应的base64字符串
        var base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue:0))
        ///判断是否带有头部base64标识信息
        if headerSign {
            ///根据格式拼接数据头 添加header信息，扩展名信息
            base64String = "data:image/png;base64," + base64String
        }
        return base64String
    }
    
 
    
}


                                            
