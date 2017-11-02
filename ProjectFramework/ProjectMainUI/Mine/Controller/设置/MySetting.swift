//
//  MySetting.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/9/8.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit
import SwiftTheme
import SDWebImage

class MySetting: CustomTemplateViewController {
    /********************  XIB  ********************/
    @IBOutlet weak var tableView: UITableView!
    /********************  属性  ********************/
    fileprivate let identifier    = "MySettingCell"
    fileprivate let textArray     = ["意见反馈","关于我们","清除缓存"]
    fileprivate let imageArray    = ["反馈","关于我们","删除"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.initUI()
    }
    //MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MySettingCell
        cell.leftImage.image = UIImage.init(named: imageArray[indexPath.row])
        cell.titleName.text = textArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            //意见反馈
        case 0:
            let vc = CommonFunction.ViewControllerWithStoryboardName("Feedback", Identifier: "Feedback") as! FeedbackViewController
            self.navigationController?.show(vc, sender: nil)
            break
            //关于我们
        case 1:
            let vc = CommonFunction.ViewControllerWithStoryboardName("About", Identifier: "About") as! AboutViewController
            self.navigationController?.show(vc, sender: self)
            break
            //清除缓存
        case 2:
            //显示缓存大小
            let intg: Int = Int(SDImageCache.shared().getSize())
            let currentVolum: String = "\(self.fileSizeWithInterge(intg))"
            
            SDImageCache.shared().clearDisk(onCompletion: {
                //清除缓存
                SDImageCache.shared().clearMemory()
                CommonFunction.MessageNotification("为您清除了"+currentVolum, interval: 2, msgtype: .success,font: UIFont.systemFont(ofSize: 13))
            })
            break
        default:
            break
        }
    }
    //获取缓存大小
    func fileSizeWithInterge(_ size: Int) -> String {
        // 1k = 1024, 1m = 1024k
        if size < 1024 {
            // 小于1k
            return "\(Int(size))B"
        }
        else if size < 1024 * 1024 {
            // 小于1m
            let aFloat: CGFloat = CGFloat(size) / 1024
            return String(format: "%.0fK", aFloat)
        }
        else if size < 1024 * 1024 * 1024 {
            // 小于1G
            let aFloat: CGFloat = CGFloat(size) / (1024 * 1024)
            return String(format: "%.1fM", aFloat)
        }
        else {
            let aFloat: CGFloat = CGFloat(size) / (1024 * 1024 * 1024)
            return String(format: "%.1fG", aFloat)
        }
        
    }
    private func initUI()->Void{
        self.InitCongif(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: CommonFunction.NavigationControllerHeight, width: self.view.frame.width, height:CommonFunction.kScreenHeight - CommonFunction.NavigationControllerHeight)
        self.tableView.backgroundColor = UIColor().TransferStringToColor("#F0EBF0")
        self.tableViewheightForRowAt = 50
        self.numberOfSections = 1
        self.numberOfRowsInSection = 3
        self.header.isHidden = true
        self.RefreshRequest(isLoading: false, isHiddenFooter: true)
    }

}
