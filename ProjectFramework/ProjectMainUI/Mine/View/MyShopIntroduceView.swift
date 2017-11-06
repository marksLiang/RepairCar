//
//  MyShopIntroduceView.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/11/4.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class MyShopIntroduceView: UIView {
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var shopContent: UITextView!
    @IBOutlet weak var defultImage: UIImageView!
    @IBOutlet weak var lable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shopContent.layer.borderWidth = 0.5
        shopContent.layer.borderColor = UIColor.lightGray.cgColor
        shopContent.layer.cornerRadius = 5
        defultImage.isUserInteractionEnabled = true
    }
    
    func setData(text:String , imageUrl:String) -> Void {
        shopLabel.isHidden = true
        shopContent.text = text
        defultImage.ImageLoad(PostUrl: HttpsUrlImage+imageUrl)
    }
}
