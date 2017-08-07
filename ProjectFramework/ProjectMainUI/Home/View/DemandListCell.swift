//
//  DemandListCell.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemandListCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detailLeading: NSLayoutConstraint!//左边约束
    
    @IBOutlet weak var detailTraling: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
