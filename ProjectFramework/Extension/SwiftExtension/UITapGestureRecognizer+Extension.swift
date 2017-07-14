//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit


private var UITapGestureRecognizer_TagString = ""
private var UITapGestureRecognizer_TagInt = 0
extension UITapGestureRecognizer {
    var ExpTagString:String{
        
        get{
            let result = objc_getAssociatedObject(self, &UITapGestureRecognizer_TagString) as? String
            if result == nil {
                return ""
            }
            
            return result!
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &UITapGestureRecognizer_TagString, newValue, objc_AssociationPolicy(rawValue: 3)!)
        }
    }
    
    var ExpTagInt:Int{
        
        get{
            let result = objc_getAssociatedObject(self, &UITapGestureRecognizer_TagInt) as? Int
            if result == nil {
                return 0
            }
            
            return result!
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &UITapGestureRecognizer_TagInt, newValue, objc_AssociationPolicy(rawValue: 3)!)
        }
    }
    
}

