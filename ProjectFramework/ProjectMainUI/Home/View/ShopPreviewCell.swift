//
//  ShopPreviewCell.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/26.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class ShopPreviewCell: UITableViewCell {

    @IBOutlet weak var weixiuType: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var shopName: UILabel!
    
    //服务星级
    fileprivate lazy var startView: XHStarRateView = {
        let startView = XHStarRateView.init(frame: CommonFunction.CGRect_fram(self.start.frame.maxX , y: self.start.frame.origin.y + 3, w: 80, h: 12), numberOfStars: 5, rateStyle: .HalfStar, isAnination: true, delegate: self)
        startView?.isUserInteractionEnabled = false
        return startView!
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.selectionStyle = .none
        self.contentView.addSubview(startView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func InitConfig(_ cell: Any) {
        let model = cell as! RepairShopModel
        shopName.text = model.TitleName
        startView.setscore(CGFloat(model.StarRating))
        weixiuType.text = model.TypeNames
    }
}
