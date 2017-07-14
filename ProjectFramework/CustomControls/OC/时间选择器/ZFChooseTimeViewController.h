//
//  ZFChooseTimeViewController.h
//  slyjg
//
//  Created by 王小腊 on 16/3/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chooseDate)(NSArray*goDate,NSArray*backDate);

/**
 *  时间选择器
 */
@interface ZFChooseTimeViewController : UIViewController

@property (nonatomic, copy) chooseDate selectedDate;

/**
 *  返回选中时间
 *
 *  @param listDate 时间
 */
-(void)backDate:(chooseDate)listDate;



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com