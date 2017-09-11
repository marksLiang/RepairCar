//
//  NewsCell.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/9/9.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var formName: UILabel!
    @IBOutlet weak var BeginTimes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
