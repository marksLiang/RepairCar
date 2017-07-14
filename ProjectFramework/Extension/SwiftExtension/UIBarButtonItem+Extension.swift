//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit



extension UIBarButtonItem {
    
    func  NavItemWithImageName(imageName: String, highImageName: String, target: Any, action: Selector)->UIButton{
        let tagButton = UIButton(type: .custom)
        tagButton.setBackgroundImage(UIImage(named: imageName), for: .normal)
        tagButton.setBackgroundImage(UIImage(named: highImageName), for: .highlighted)
        tagButton.setEnlargeEdgeWithTop(20, right: 20, bottom: 20, left: 20)
        //tagButton.size(size: tagButton.currentBackgroundImage!.size)
        tagButton.addTarget(target, action: action, for: .touchUpInside)
        return  tagButton
    }
     
}


                                            
