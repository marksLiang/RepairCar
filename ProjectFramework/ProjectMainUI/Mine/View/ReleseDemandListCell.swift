//
//  ReleseDemandListCell.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/16.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ReleseDemandListCell: UITableViewCell {

    @IBOutlet weak var detailLeading: NSLayoutConstraint!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
