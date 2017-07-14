//
//  ViewController.h
//  全景_图片
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface PanoramaViewController : GLKViewController

/// 全景图路径
@property (strong, nonatomic)UIImage* image;

-(id)initWithUrlPath: (UIImage *)image;

@end

