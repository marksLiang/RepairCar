//
//  AdvertisingWeb.swift
//  RepairCar
//
//  Created by 梁元峰 on 2017/8/23.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import WebKit
class AdvertisingWeb: UIViewController,WKNavigationDelegate {
    
    var urlString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        //创建wkwebview
        let webview = WKWebView(frame: CGRect(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: self.view.frame.height-CommonFunction.NavigationControllerHeight))
        webview.navigationDelegate = self
        webview.load(URLRequest.init(url: URL.init(string: urlString)!))
        self.view.addSubview(webview)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        print("网页加载完成")
    }

}
