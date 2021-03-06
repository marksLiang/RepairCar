//
//  DemandListCell.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class DemandListCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var date: UILabel!
//    @IBOutlet weak var detailLeading: NSLayoutConstraint!//左边约束
//    @IBOutlet weak var detailTraling: NSLayoutConstraint!
    
    @IBOutlet weak var titleLeading: NSLayoutConstraint!
    @IBOutlet weak var titleTraling: NSLayoutConstraint!
    fileprivate var isFirst = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func InitConfig(_ cell: Any) {
        let model = cell as! DemandListModel
        if (model.Images?.count)! > 0 {
            titleLeading.constant = 108
            mainImage.isHidden = false
            mainImage.ImageLoad(PostUrl: HttpsUrlImage+model.Images![0].ImgPath)
        }else{
            titleLeading.constant = 15
            mainImage.isHidden = true
        }
        titleLable.text = model.Title
        detail.text = model.Describe
        date.text = model.CreateTime
        
        
    }
}
