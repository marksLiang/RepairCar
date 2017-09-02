//
//  CityListCell.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/19.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class CityListCell: UICollectionViewCell {
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.borderWidth = 0.6
        button.layer.borderColor = UIColor().TransferStringToColor("#7CD3BD").cgColor
    }
}
