//
//  DemanContenView.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/19.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemanContenView: UIView {

    @IBOutlet weak var demanSwich: UISwitch!
    @IBOutlet weak var demanContent: UITextView!
    @IBOutlet weak var tishiLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        demanContent.layer.borderWidth = 0.5
        demanContent.layer.borderColor = UIColor.lightGray.cgColor
        demanContent.layer.cornerRadius = 5
    }

}
