//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit


//字符串拓展属性
extension  String {
  
    /// 移除字符串最后一位字符
    ///
    /// - returns: NewString
    func RemoveLastChar()->String{
        let index = self.index(self.startIndex, offsetBy:self.characters.count-1)
        return  self.substring(to: index)
    }
   
    /**
     获取当前字符串的高度
     
     - parameter font:    字体
     - parameter maxSize: CGSize
     
     - returns: 高度CGSize
     */
    func ContentSize(font:UIFont,maxSize:CGSize) -> CGSize {
        return self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
    }
    
    /// 获取当前字符串的宽度
    ///
    /// - Parameter font: 字体
    /// - Returns: 宽度
    func getContenSizeWidth(font:UIFont) -> CGFloat {
        return self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size.width
    }
    ///字符串时间转换（返回 x分钟前/x小时前/昨天/x天前/x个月前/x年前
    ///注意，格式必须正确 只接受 yyyy-MM-dd HH:mm:ss 类型字符 否则转换出错
    func CompareCurretTime()->String{
        //把字符串转为NSdate
        let dateFormatter =   DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let date:Date=dateFormatter.date(from: self)!
        
        let curDate = Date()
        let  time:TimeInterval  = -date.timeIntervalSince(curDate)
        
        let year:Int = (Int)(curDate.currentYear - date.currentYear);
        let month:Int = (Int)( curDate.currentMonth - date.currentMonth);
        let day:Int = (Int)(curDate.currentDay - date.currentDay);
        
        var  retTime:TimeInterval = 1.0;
        
        // 小于一小时
        if (time < 3600) {
            retTime = time / 60
            retTime = retTime <= 0.0 ? 1.0 : retTime
            if(retTime.format(".0")=="0"){
                return "刚刚"
            }
            else{
                return retTime.format(".0")+"分钟前"
            }
        }
            // 小于一天，也就是今天
        else if (time < 3600 * 24) {
            retTime = time / 3600
            retTime = retTime <= 0.0 ? 1.0 : retTime
            return retTime.format(".0")+"小时前"
        }
            // 昨天
        else if (time < 3600 * 24 * 2) {
            return "昨天"
        }
            
            // 第一个条件是同年，且相隔时间在一个月内
            // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
        else if ((abs(year) == 0 && abs(month) <= 1)
            || (abs(year) == 1 &&  curDate.currentMonth == 1 && date.currentMonth == 12)) {
            var   retDay:Int = 0;
            // 同年
            if (year == 0) {
                // 同月
                if (month == 0) {
                    retDay = day;
                }
            }
            
            if (retDay <= 0) {
                // 这里按月最大值来计算
                // 获取发布日期中，该月总共有多少天
                let totalDays:Int = date.TotaldaysInThisMonth()
                
                // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
                retDay = curDate.currentDay + (totalDays - date.currentDay)
                
                if (retDay >= totalDays) {
                    let value = abs(max(retDay / date.TotaldaysInThisMonth(), 1))
                    return  value.description + "个月前"
                }
            }
            return abs(retDay).description + "天前"
        }
        else  {
            if (abs(year) <= 1) {
                if (year == 0) { // 同年
                    return abs(month).description+"个月前"
                }
                
                // 相差一年
                let month:Int =  curDate.currentMonth
                let preMonth:Int = date.currentMonth
                
                // 隔年，但同月，就作为满一年来计算
                if (month == 12 && preMonth == 12) {
                    return  "1年前"
                }
                // 也不看，但非同月
                return abs(12 - preMonth + month).description + "个月前"
                
            }
            return abs(year).description + "年前"
        }
        
    }
    
    ///base64string 字符转换UIImage  返回UIImage
    func ToImage()->UIImage?{
        let base64String = self  //base64转换图片
        let data =  Data(base64Encoded: base64String, options:   NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        if( data != nil){
            let img = UIImage(data: data!)
            if(img != nil){
                return img!
            }
        }
        return nil
    }
    
    
    ///传入base64的字符串，可以是没有经过修改的转换成的以data开头的，也可以是base64的内容字符串，然后转换成UIImage
    func base64StringToUIImage()->UIImage? {
        var str = self
        
        // 1、判断用户传过来的base64的字符串是否是以data开口的，如果是以data开头的，那么就获取字符串中的base代码，然后在转换，如果不是以data开头的，那么就直接转换
        if str.hasPrefix("data:image") {
            
            guard let newBase64String = str.components(separatedBy: ",").last else {
                return nil
            }
            str = newBase64String
        }
        // 2、将处理好的base64String代码转换成NSData
        guard let imgNSData = NSData(base64Encoded: str, options: NSData.Base64DecodingOptions()) else {
            return nil
        }
        // 3、将NSData的图片，转换成UIImage
        guard let codeImage = UIImage(data: imgNSData as Data) else {
            return nil
        }
        
        return codeImage
    }
    
    
    
}
