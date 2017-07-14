//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit



//日期拓展属性
extension Date {
    /**
     这个月有几天
     
     - parameter date: nsdate
     
     - returns: 天数
     */
    func TotaldaysInThisMonth(_ date : Date   ) -> Int {
        let totaldaysInMonth: NSRange = (Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return totaldaysInMonth.length
    }
    /**
     这个月有几天
     
     - parameter date: nsdate
     
     - returns: 天数
     */
    func TotaldaysInThisMonth() -> Int {
        let totaldaysInMonth: NSRange = (Calendar.current as NSCalendar).range(of: .day, in: .month, for: self)
        return totaldaysInMonth.length
    }
    
    /**
     得到本月的第一天的是第几周
     
     - parameter date: nsdate
     
     - returns: 第几周
     */
    func toMonthOneDayWeek (_ date:Date) ->Int {
        let Week: NSInteger = (Calendar.current as NSCalendar).ordinality(of: .day, in: NSCalendar.Unit.weekOfMonth, for: date)
        return Week-1
    }
    
    
    /// 返回当前日期 年份
    var currentYear:Int{
        
        get{
            
            return GetFormatDate("yyyy")
        }
        
    }
    /// 返回当前日期 月份
    var currentMonth:Int{
        
        get{
            
            return GetFormatDate("MM")
        }
        
    }
    /// 返回当前日期 天
    var currentDay:Int{
        
        get{
            
            return GetFormatDate("dd")
        }
        
    }
    /// 返回当前日期 小时
    var currentHour:Int{
        
        get{
            
            return GetFormatDate("HH")
        }
        
    }
    /// 返回当前日期 分钟
    var currentMinute:Int{
        
        get{
            
            return GetFormatDate("mm")
        }
        
    }
    /// 返回当前日期 秒数
    var currentSecond:Int{
        
        get{
            
            return GetFormatDate("ss")
        }
        
    }
    
    /**
     获取yyyy  MM  dd  HH mm ss
     
     - parameter format: 比如 GetFormatDate(yyyy) 返回当前日期年份
     
     - returns: 返回值
     */
    func GetFormatDate(_ format:String)->Int{
        let dateFormatter:DateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        let dateString:String = dateFormatter.string(from: self);
        var dates:[String] = dateString.components(separatedBy: "")
        let Value  = dates[0]
        if(Value==""){
            return 0
        }
        return Int(Value)!
    }
    
    
}
 

                                            
