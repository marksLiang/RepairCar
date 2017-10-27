//
//  LYFMKPinAnnotationView.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/10/26.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class LYFMKPinAnnotationView: MKPinAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

