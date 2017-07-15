//
//  ZPButton.swift
//  RepairCar
//
//  Created by 住朋购友 on 2017/7/15.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ZPButton: UIButton {


    override func setTitle(_ title: String?, for state: UIControlState) {
        let width = title?.getContenSizeWidth(font: UIFont.systemFont(ofSize: 14))
        self.frame.size = CGSize.init(width:width! + (self.imageView?.bounds.size.width)! + 15, height: self.frame.height)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(self.imageView?.bounds.size.width)!, bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (width!) + (self.imageView?.bounds.size.width)!, bottom: 0, right: 0)
        super.setTitle(title, for: state)
    }

}
