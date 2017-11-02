//
//  MyShopCell.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/2.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class MyShopCell: UITableViewCell {

    @IBOutlet weak var keyLable: UILabel!
    @IBOutlet weak var shopTextfield: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
