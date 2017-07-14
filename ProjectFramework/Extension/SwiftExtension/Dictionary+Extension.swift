//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
    
    /**
     字典转换字符串
     
     - parameter dict: 字典类型<String,AnyObject>
     
     - returns: 返回字符串
     */
    static func ToDictionaryString(_ dict:Dictionary<String,AnyObject>)->String{
        
        var strJson:String=""
        do {
            
            let data =  try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            strJson=NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            
        }
        
        return strJson
        
    }
}
 
