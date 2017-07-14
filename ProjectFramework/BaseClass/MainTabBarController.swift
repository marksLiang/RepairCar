//
//  MainTabBarController.swift
//  ProjectFramework
//
//  Created by 猪朋狗友 on 16/6/13.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import CYLTabBarController


class  CYLBaseNavigationController:UINavigationController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //导航栏颜色渐变---需要的时候开启 不需要不用开启
        //self.navigationBar.layer.insertSublayer(gradientLayer(), at: 0)
        
    }
    
    func gradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        // CGColor是无法放入数组中的，必须要转型。
        gradientLayer.colors = [(UIColor(red: CGFloat(78 / 255.0), green: CGFloat(143 / 255.0), blue: CGFloat(1.0), alpha: CGFloat(1.0)).cgColor),
                                CommonFunction.SystemColor().cgColor,
                                (UIColor(red: CGFloat(60 / 255.0), green: CGFloat(143 / 255.0), blue: CGFloat(1.0), alpha: CGFloat(1.0)).cgColor)]
        // 颜色分割线
        gradientLayer.locations = [0, 0.8, 1.5]
        // 颜色渐变的起点和终点，范围为 (0~1.0, 0~1.0)
        gradientLayer.startPoint = CGPoint(x: CGFloat(0), y: CGFloat(0))
        gradientLayer.endPoint = CGPoint(x: CGFloat(1.0), y: CGFloat(0))
        gradientLayer.frame = CGRect(x: CGFloat(0), y: CGFloat(-20), width: CGFloat(navigationBar.bounds.size.width), height: CGFloat(20 + navigationBar.bounds.size.height))
        return gradientLayer
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            //如果当前的viewcontroller.count大于0 表示不再这个页面内 则 隐藏掉TabbarController
            viewController.hidesBottomBarWhenPushed = true
            
        }
        
        //修改导航栏的返回样式  title为 “” 表示只有箭头了
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = item;
        
        super.pushViewController(viewController, animated: animated)
    }
 
}


 
class MainTabBarController : CYLTabBarController {
    
    var   StartPageImage = UIImageView()   //第一次进入点击进来的图片(用来做动画)
   
    override func viewDidLoad() {
        super.viewDidLoad()
         //第一次启动进来就添加最后一张图片，必须在这里先添加StartPageImage在添加其他vc 不然会出现一闪的白边
            StartPageImage.frame=CGRect(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight)
            StartPageImage.contentMode = .scaleToFill
            //获取启动视图
            self.view.addSubview(StartPageImage)    //添加进来，动画完后在移除
        
        //tabbaritem
        var _tabBarItemsAttributes: [AnyObject] = []
        var _viewControllers:[AnyObject] = []
        
        for i in 0 ... TabBar_Title.count - 1 {
            let dict: [AnyHashable: Any] = [
                CYLTabBarItemTitle: TabBar_Title[i],   //标题
                CYLTabBarItemImage: TabBar_NoSelectedImage[i], //未选择图片
                CYLTabBarItemSelectedImage: TabBar_SelectedImage[i]    //选择图片
            ]
            let vc = UIStoryboard(name: TabBar_StoryName[i], bundle: nil).instantiateViewController(withIdentifier: TabBar_StoryName[i])
            
            let rootNavigationController = CYLBaseNavigationController(rootViewController: vc)   //添加自定义导航控制器   如果是append  vc 则不会出现navigationcontrooler
            rootNavigationController.navigationBar.hideBottomHairline()//隐藏线条
            
            vc.title=TabBar_Title[i]   //标题
            
            _tabBarItemsAttributes.append(dict as AnyObject)
            
            _viewControllers.append(rootNavigationController)
        }
        self.tabBarItemsAttributes = _tabBarItemsAttributes as! [[AnyHashable: Any]]
        
        self.viewControllers = _viewControllers as! [ UIViewController]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //播放启动画面动画
            launchAnimation()
    }
    
    //播放启动画面动画
    fileprivate func launchAnimation() {
        
        //播放动画效果，完毕后将其移除
        UIView.animate(withDuration: 5, delay: 0.5, options: .beginFromCurrentState,
                                   animations: {
                                    self.StartPageImage.alpha = 0.0
                                    self.StartPageImage.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
        }) { (finished) in
          self.StartPageImage.removeFromSuperview()
        }
    }
    
    
    
}
