//
//  CityData.h
//  ZCSH
//
//  Created by Vicente on 16/9/5.
//  Copyright © 2016年 zhongcaishenghuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityData : NSObject

/**
 *  读取xml文件
 *
 *  @return 返回直辖市和省的数据
 */
+(NSMutableArray *)loadFile;
+(NSArray *)getCityData;
+(NSMutableArray *)getAarry:(NSArray *)array Preicate:(NSPredicate *)preicate;
@end
