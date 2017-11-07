//
//  ShopBackgroundCell.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopBackgroundCell: UITableViewCell {

    @IBOutlet weak var shopTitle: UILabel!
    @IBOutlet weak var createTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func InitConfig(_ cell: Any) {
        let model = cell as! MaintenanceModel
        shopTitle.text = model.TitleName
        createTime.text = model.CreateTime
    }
}
