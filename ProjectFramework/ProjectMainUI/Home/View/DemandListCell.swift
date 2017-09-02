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
    func hiddenImage() -> Void {
        if isFirst == true {
            isFirst = false
            titleLeading.constant = 15
            titleTraling.constant-=80
            mainImage.isHidden = true
        }
    }
    override func InitConfig(_ cell: Any) {
        let model = cell as! DemandListModel
//        mainImage.ImageLoad(PostUrl: HttpsUrlImage)
        titleLable.text = model.Title
        detail.text = model.Describe
        date.text = model.CreateTime
    }
}
