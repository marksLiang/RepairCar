//
//  DemandImageCell.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/31.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemandImageCell: UITableViewCell {

    @IBOutlet weak var demandImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
//        demandImage.layer.cornerRadius = 12
        demandImage.clipsToBounds = true
        demandImage.contentMode = .scaleAspectFill
    }
    
}
                
