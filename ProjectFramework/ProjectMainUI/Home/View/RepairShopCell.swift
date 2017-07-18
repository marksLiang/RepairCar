//
//  RepairShopCell.swift
//  RepairCar
//
//  Created by 住朋购友 on 2017/7/17.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class RepairShopCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!//图片
    @IBOutlet weak var titleLabel: UILabel!//标题
    @IBOutlet weak var distanceLabel: UILabel!//距离
    @IBOutlet weak var fuwuxingji: UILabel!//服务星级
    @IBOutlet weak var weixiuleixing: UILabel!//维修类型
    
    fileprivate var isFirst = true
    
    //服务星级
    fileprivate lazy var startView: XHStarRateView = {
        let startView = XHStarRateView.init(frame: CommonFunction.CGRect_fram(self.fuwuxingji.frame.maxX , y: self.fuwuxingji.frame.origin.y + 3, w: 80, h: 12), numberOfStars: 5, rateStyle: .HalfStar, isAnination: true, delegate: self)
        startView?.isUserInteractionEnabled = false
        return startView!
    }()
    fileprivate lazy var bottomView: UIView = {
        let bottomView = UIView.init(frame: CGRect.init(x: 0, y: self.mainImageView.frame.maxY, width: self.contentView.frame.width, height: 0))
        bottomView.backgroundColor = UIColor.white
        return bottomView
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.addSubview(startView)
        self.addSubview(bottomView)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.distanceLabel.textColor = CommonFunction.SystemColor()
        self.mainImageView.clipsToBounds = true
        self.mainImageView.layer.cornerRadius = 5
    }
    func InitConfig(_ cell: Any , _ tagsFrame:TagsFrame) {
        let model = cell as! RepairShopModel
        startView.setscore(CGFloat(model.Score))
        //设置标签，isFirst避免重复设置
        if isFirst == true {
            bottomView.frame =  CGRect.init(x: 0, y: self.mainImageView.frame.maxY, width: self.contentView.frame.width, height: tagsFrame.tagsHeight)
            for i in 0..<tagsFrame.tagsArray.count {
                let lable = UILabel.init()
                lable.layer.borderWidth = 0.6
                lable.layer.borderColor = UIColor().TransferStringToColor(CommonFunction.SystemColor()).withAlphaComponent(0.6).cgColor
                lable.layer.cornerRadius = 4
                let text = tagsFrame.tagsArray[i] as? String
                lable.text = text
                lable.textColor = CommonFunction.SystemColor()
                lable.textAlignment = .center
                lable.frame = CGRectFromString(text!)
                print(CGRectFromString(text!))
                self.bottomView.addSubview(lable)
            }
            isFirst = false
        }
    }
}
