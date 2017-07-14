//
//  MCWebViewController.swift
//  MCWebVIew
//
//  Created by 马超 on 16/3/3.
//  Copyright © 2016年 @qq:714080794 (交流qq). All rights reserved.
//

import UIKit
import WebKit


class MCWebViewController: UIViewController,WKNavigationDelegate {

    
    var url: String?
    var ProcesscColor = UIColor.white   //进度条的颜色  (默认白色)
    var haveNavBar: Bool = true
    
    fileprivate var webView: UIWebView?  ///ios8 一下的支持
    fileprivate var wwebView: WKWebView! /// ios8 + 的支持
    fileprivate var errorLabel: UILabel?
    fileprivate var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        //关闭系统自动缩进
        if self.responds(to: #selector(setter: UIViewController.automaticallyAdjustsScrollViewInsets)) {
            
            self.automaticallyAdjustsScrollViewInsets = false
        } 
        
        if let _ = url {

            if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0)) {
                
                self.initWkWebView()
                
            }else {
                
                self.webView = UIWebView(frame: self.view.bounds)
                self.view.addSubview(self.webView!)
            }
        }else {
            
            self.showError("Please enter a url string")
        }

        
         self.initNavBar()
         self.initProgressView()
    }
    
    
    init(url: String,ProcesscColor:UIColor) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.url = url
        self.ProcesscColor = ProcesscColor
        
    }

     required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
     }


    //MARK: ----------- 私有方法 ----------
    func showError(_ message: String?) {
        
        hideError()
        errorLabel = UILabel()
        errorLabel!.font = UIFont.systemFont(ofSize: 17)
        errorLabel!.textAlignment = NSTextAlignment.center
        errorLabel!.textColor = UIColor.red
        errorLabel!.text = message
        self.view.addSubview(errorLabel!)
        
        errorLabel!.frame = CGRect(x: 0, y: self.view.bounds.height / 2 - 10, width: self.view.bounds.width, height: 20)
    }
    
    func hideError() {
        
        if let _ = errorLabel {
           errorLabel!.removeFromSuperview()
        }
        
    }
    
    func setMyTitle(_ title: String?) {
        
        self.title = title;
    }
    
    
    //MARK: ---------- 初始话wk -----------
    func initWkWebView() {
        
        self.wwebView = WKWebView(frame: self.view.bounds)

        self.wwebView.navigationDelegate = self
        self.view.addSubview(self.wwebView!)
        
        self.wwebView.allowsBackForwardNavigationGestures = true
        
        if self.haveNavBar {
            self.wwebView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        }else {
            self.wwebView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        }
        self.wwebView!.load(URLRequest(url: URL(string: self.url!)!))
        
        //监听进度
        self.wwebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        //监听标题
        self.wwebView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    //MARK: ---------- 初始化progressView ----------
    func initProgressView() {
        
        self.progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        self.progressView.frame = CGRect(x: 0, y: haveNavBar ? 64 : 20 , width: self.view.bounds.width, height: 5.0)
        self.view.addSubview(self.progressView)
        
        self.progressView.isHidden = true
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.progressTintColor = self.ProcesscColor
    }
    
    //MARK: ---------- 初始化导航 ----------
    //隐藏系统的,替换成自定义的导航，这个日后再扩展，目前先使用系统自带的
    func initNavBar() {
        
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.leftBarButtonItem = nil
        
       let leftback = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(self.backAction))
        
        let leftclose = UIBarButtonItem(title: "关闭", style: .done, target: self, action: #selector(self.closeAction))
        
        
        if self.wwebView != nil && self.wwebView.canGoBack {
            self.navigationItem.leftBarButtonItems = [leftback,leftclose]
        }else { 
            self.navigationItem.leftBarButtonItem = leftback
        }
        
    }
    
    //MARK: ---------- wkdelegate ----------
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        self.progressView.isHidden = false
        self.progressView.setProgress(0.2, animated: true)
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       

    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        self.progressView.isHidden = true
    }
    
    
    //MARK:----------进度的监听方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            
            if object as! NSObject == self.wwebView {
                if self.wwebView.estimatedProgress > 0.2 {
                  
                    self.progressView.setProgress(Float(self.wwebView.estimatedProgress), animated: true)
                    
                    if self.wwebView.estimatedProgress >= 1.0 {
                      
                        self.progressView.setProgress(0.99999, animated: true)
                        UIView.animate(withDuration: 0.3, delay: 0.3, options: UIViewAnimationOptions.autoreverse, animations: { () -> Void in
                                self.progressView.isHidden = true
                                self.progressView.setProgress(0.0, animated: false)
                            }) { (finish) -> Void in

                        }
                    }
                    
                }
                
                
            }else {
                
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }else if keyPath == "title" {
            
             if object as! NSObject == self.wwebView {
                
                self.setMyTitle(self.wwebView.title)
                
                if self.wwebView != nil && self.wwebView.canGoForward {
                    
                    self.initNavBar()
                }
                
             }else{
                
               super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                
            }
        }else {
            
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    //MARK: --------- private func ----------
    func closeAction() {
        
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    func backAction() {
        
        if self.wwebView.canGoBack {
            
            self.wwebView.goBack()
        }else {
            
            self.closeAction()
        }
        
    }
    
    deinit {
        
        if let _ = self.wwebView {
            
            self.wwebView.removeObserver(self, forKeyPath: "estimatedProgress")
            self.wwebView.removeObserver(self, forKeyPath: "title")
        }
    }
}
