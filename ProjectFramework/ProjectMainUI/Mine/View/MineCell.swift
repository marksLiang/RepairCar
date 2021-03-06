//
//  MineCell.swift
//  RepairCar
//
//  Created by 住朋购友 on 2017/8/12.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class MineCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var titleLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        mainImage.layer.cornerRadius = mainImage.frame.width / 2
        mainImage.clipsToBounds = true
    }
}
