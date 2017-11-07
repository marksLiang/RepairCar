//
//  ShopImageCell.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/11/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopImageCell: UITableViewCell {

    @IBOutlet weak var shopImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shopImageView.layer.cornerRadius = 10
        shopImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
