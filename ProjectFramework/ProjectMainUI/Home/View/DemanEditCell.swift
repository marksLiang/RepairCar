//
//  DemanEditCell.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/18.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemanEditCell: UITableViewCell {

    @IBOutlet weak var keyTitle: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var littleImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
