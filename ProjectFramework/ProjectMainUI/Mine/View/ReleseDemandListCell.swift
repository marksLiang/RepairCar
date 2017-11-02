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
    @IBOutlet weak var titleLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func InitConfig(_ cell: Any) {
        let model = cell as! DemandModel
        if model.Images!.count > 0 {
            mainImage.ImageLoad(PostUrl: HttpsUrlImage+model.Images![0].ImgPath)
        }else{
            detailLeading.constant = 15
            mainImage.isHidden = true
        }
        if model.ReleaseType == 1 {
            state.text = "正在进行中"
            state.textColor = UIColor.green
        }else{
            state.text = "已完结"
            state.textColor = UIColor.red
        }
        date.text = model.CreateTime
        detailText.text = model.Describe
        titleLable.text = model.Title
    }
}
