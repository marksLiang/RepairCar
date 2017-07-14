//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit


private var STUIBUTTONPERSON_ID_NUMBER_PROPERTY = ""
//拓展UITextField 1个属性   ExpTagString->String
extension UITextField {
    
    var ExpTagString:String{
        
        get{
            let result = objc_getAssociatedObject(self, &STUIBUTTONPERSON_ID_NUMBER_PROPERTY) as? String
            if result == nil {
                return ""
            }
            
            return result!
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &STUIBUTTONPERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy(rawValue: 3)!)
        }
    }
    
    
}



                                            
