//
//  ShopDetailCell.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/27.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopDetailCell: UITableViewCell {

    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var titleValue: UILabel!
    @IBOutlet weak var titleKey: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(titleKey:String,titleValue:String,imageList:String) -> Void {
        self.titleKey.text = titleKey
        self.titleValue.text = titleValue
        self.rightImage.image = UIImage.init(named: imageList)
    }
}
