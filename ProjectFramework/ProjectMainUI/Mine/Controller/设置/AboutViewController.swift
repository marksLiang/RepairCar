//
//  AboutViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/16.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController   {

    @IBOutlet weak var appiconImage: UIImageView!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var callWithUS: UIView!
    @IBOutlet weak var mianze: UIView!
    @IBOutlet weak var versionHave: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="关于我们"
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        versionHave.sizeToFit()
        appiconImage.layer.cornerRadius = 5
        appiconImage.clipsToBounds = true
        //mianze.isHidden = true
        let currentVersion = CommonFunction.GetVersion()
        version.text = "版本号：V\(String(describing: currentVersion))"
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(tapclick1))
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(tapclick2))
        callWithUS.addGestureRecognizer(tap1)
        mianze.addGestureRecognizer(tap2)
    }
    func tapclick1() -> Void {
        CommonFunction.CallPhone(self, number: "15907740425")
    }
    func tapclick2() -> Void {
        let vc =  CommonFunction.ViewControllerWithStoryboardName("Disclaimer", Identifier: "Disclaimer")
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
}
