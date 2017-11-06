//
//  MyMessageCell.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/9/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var messageTime: UILabel!
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
        leftImageView.layer.cornerRadius = 4
        leftImageView.clipsToBounds = true
    }
    override func InitConfig(_ cell: Any) {
        let model = cell as! MessageModel
        messageContent.text = model.Msg
        messageTime.text = model.CreateTime
    }
}
