//
//  PulickWebCell.swift
//  ProjectFramework_Tourism
//
//  Created by 住朋购友 on 2017/4/19.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class PulickWebCell: UITableViewCell,UIWebViewDelegate {

    typealias CallbackValue=(_ value:CGFloat)->Void //类似于OC中的typedef
    var myCallbackValue:CallbackValue?  //声明一个闭包 类似OC的Block属性
    func  FuncCallbackValue(value:CallbackValue?){
        myCallbackValue = value //返回值
    }
    
    lazy var costomWebView:UIWebView={
        let costomWebView = UIWebView.init(frame: CommonFunction.CGRect_fram(0, y: 0, w: CommonFunction.kScreenWidth, h: 10))
        costomWebView.scrollView.bounces = false
        costomWebView.scrollView.isScrollEnabled = false
        costomWebView.delegate = self
        costomWebView.backgroundColor = UIColor.white
        costomWebView.isUserInteractionEnabled = false
        costomWebView.scrollView.showsVerticalScrollIndicator = false
        costomWebView.scrollView.showsHorizontalScrollIndicator = false
        return costomWebView
    }()
    override func layoutSubviews() {
        self.selectionStyle = .none
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        self.contentView.addSubview(self.costomWebView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: webViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView){
        print("开始加载")
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        
        let height = webView.scrollView.contentSize.height
        costomWebView.frame = CommonFunction.CGRect_fram(0, y: 0, w: CommonFunction.kScreenWidth, h: height)
        if (myCallbackValue != nil) {
            myCallbackValue!(height )
        }
    }
    func loadHtmlString(html:String, isFirst:Bool) -> Void {
        if isFirst == false {
            costomWebView.loadHTMLString(html, baseURL: nil)
        }
    }
    
}
