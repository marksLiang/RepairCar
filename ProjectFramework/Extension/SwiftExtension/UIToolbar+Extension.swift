//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit


extension UIToolbar {
    
    ///隐藏线条
    func hideHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(view: self)
        navigationBarImageView!.isHidden = true
    }
    ///显示线条
    func showHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(view: self)
        navigationBarImageView!.isHidden = false
    }
    
    private func hairlineImageViewInToolbar(view: UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.classForCoder()) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInToolbar(view: subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}


                                            
