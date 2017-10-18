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
    
    @IBOutlet weak var topLayoutConstrant: NSLayoutConstraint!
    @IBOutlet weak var topButton: UIButton!//置顶按钮
    fileprivate var isFirst = true
    fileprivate var isTop   = true
    //服务星级
    fileprivate lazy var startView: XHStarRateView = {
        let startView = XHStarRateView.init(frame: CommonFunction.CGRect_fram(self.fuwuxingji.frame.maxX , y: self.fuwuxingji.frame.origin.y + 3, w: 80, h: 12), numberOfStars: 5, rateStyle: .HalfStar, isAnination: true, delegate: self)
        startView?.isUserInteractionEnabled = false
        return startView!
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.selectionStyle = .none
        self.contentView.addSubview(startView)
        self.topButton.layer.cornerRadius = topButton.frame.width / 2
        self.topButton.isHidden = true
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
    override func InitConfig(_ cell: Any) {
        self.topButton.isHidden = true
        let model = cell as! RepairShopModel
        startView.setscore(CGFloat(model.StarRating))
        if (model.Images?.count)! > 0 {
            mainImageView.ImageLoad(PostUrl: HttpsUrlImage+model.Images![0].ImgPath)
        }
        titleLabel.text = model.TitleName
        let km = model.KM as NSString
        if km.substring(from: km.length-2) == "公里" {
            distanceLabel.text = km.substring(to: km.length-2)+"km"
        }else{
            distanceLabel.text = model.KM
        }
        //设置标签，isFirst避免重复设置
        var frame_x = weixiuleixing.frame.maxX
        var frame_X = mainImageView.frame.minX
        
        if isFirst == true {
            //let magin_x = (CommonFunction.kScreenWidth - weixiuleixing.frame.maxX - 185)/3
            var tepyArray = [String]()
            if model.TypeNames != "" {
                tepyArray = model.TypeNames.components(separatedBy: ",")
                tepyArray.removeLast()
            }
            for i in 0..<tepyArray.count {
                let lable = UILabel.init()
                lable.layer.borderWidth = 0.6
                lable.layer.borderColor = UIColor.clear.cgColor
                lable.layer.cornerRadius = 4
                lable.clipsToBounds = true
                lable.font = UIFont.systemFont(ofSize: 12)
                lable.backgroundColor = CommonFunction.SystemColor().withAlphaComponent(0.7)
                lable.text = tepyArray[i]
                lable.textColor = UIColor.white
                lable.textAlignment = .center
                let view_width = tepyArray[i].getContenSizeWidth(font: UIFont.systemFont(ofSize: 12)) + 10//获取标签宽度
                if i < 3 {
                    lable.frame = CGRect.init(x: frame_x, y: weixiuleixing.frame.minY + 1, width: view_width , height: 20)
                    frame_x = frame_x + view_width + 10
                }else{
                    lable.frame = CGRect.init(x: frame_X, y: mainImageView.frame.maxY + 10, width: view_width, height: 20)
                    frame_X = frame_X + view_width + 10
                }
                self.contentView.addSubview(lable)
            }
            isFirst = false
        }
    }
    //置顶的时候修改约束
    func atTop() -> Void {
        topLayoutConstrant.constant = 10
        topButton.isHidden = false
        distanceLabel.isHidden = true
    }
}
