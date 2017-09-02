//
//  CityListHeader.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/19.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class CityListHeader: UICollectionReusableView {
    
    fileprivate lazy var image: UIImageView = {
        let image = UIImageView.init(frame: CGRect.init(x: 5, y: 7, width: 18, height: 18))
        return image
    }()
    fileprivate lazy var lable: UILabel = {
        let lable = UILabel.init(frame: CGRect.init(x: 28, y: 5, width: 200, height: 20))
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.textColor = UIColor().TransferStringToColor("#7CD3BD")
        return lable
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor().TransferStringToColor("#F9F9F9")
        self.addSubview(image)
        self.addSubview(lable)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setData(image:String, text:String) -> Void {
        self.image.image = UIImage.init(named: image)
        self.lable.text = text
    }
}
