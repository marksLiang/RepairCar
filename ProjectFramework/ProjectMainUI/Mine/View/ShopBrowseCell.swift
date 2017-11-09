//
//  ShopBrowseCell.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/11/9.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopBrowseCell: UITableViewCell {
    var myCallbackValue:(()->Void)? // 闭包
    @IBOutlet weak var createDateLable: UILabel!
    @IBOutlet weak var shopTypeLable: UILabel!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopTitle: UILabel!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var priceLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stateBtn.layer.borderWidth = 0.5
        stateBtn.layer.borderColor = UIColor().TransferStringToColor(CommonFunction.SystemColor()).cgColor
        stateBtn.addTarget(self, action: #selector(ShopBrowseCell.buttonClick), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func buttonClick() -> Void {
        if myCallbackValue != nil {
            myCallbackValue!()
        }
    }
}
