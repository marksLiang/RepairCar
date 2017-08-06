//
//  CityData.m
//  ZCSH
//
//  Created by Vicente on 16/9/5.
//  Copyright © 2016年 zhongcaishenghuo. All rights reserved.
//

#import "CityData.h"
#import "XMLDictionary.h"

NSMutableArray * dataArray;
NSMutableArray * array1;
NSMutableArray * array2;
NSMutableArray * array3;
NSMutableArray * array4;
NSMutableArray * array5;
NSMutableArray * array6;
NSMutableArray * array7;
NSMutableArray * array8;
NSMutableArray * array9;
NSMutableArray * array10;
NSMutableArray * array11;
NSMutableArray * array12;
NSMutableArray * array13;
NSMutableArray * array14;
NSMutableArray * array15;
NSMutableArray * array16;
NSMutableArray * array17;
NSMutableArray * array18;
NSMutableArray * array19;
NSMutableArray * array20;
NSMutableArray * array21;
NSMutableArray * array22;
NSMutableArray * array23;
NSMutableArray * array24;
NSMutableArray * array25;
NSMutableArray * array26;
@implementation CityData

+(NSMutableArray *)loadFile{
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"南宁市" forKey:@"city"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    dataArray = [[NSMutableArray alloc]init];
    //读取文件
    NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"cities_array"ofType:@"xml"]];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    XMLDictionaryParser *paser = [XMLDictionaryParser sharedInstance];
    NSDictionary *dic = [paser dictionaryWithData:data];
    NSArray * array = dic[@"province"];
    NSMutableArray * cityArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i ++) {
        NSDictionary * dict1 = array[i];
        if (i < 4 ) {
            NSDictionary * dict2 = dict1[@"city"];
            //            NSLog(@"%@",dict2[@"_name"]);
            NSString * cityName = dict2[@"_name"];
            //            NSLog(@"%@",cityName);
            [cityArray addObject:cityName];
        }else if (i >= 4 && i < array.count - 3) {
            NSArray * array1 = dict1[@"city"];
            //            NSLog(@"%ld",array1.count);
            for (NSDictionary * dict2 in array1) {
                //                NSLog(@"%@",dict2[@"_name"]);
                NSString * cityName = dict2[@"_name"];
                //                NSLog(@"%@",cityName);
                [cityArray addObject:cityName];
            }
        }
        
    }
    
    [self sequenceArray:cityArray];
    
    return  dataArray;
}
+(void)sequenceArray:(NSArray *)array{
    array1 = [[NSMutableArray alloc]init];
    array2 = [[NSMutableArray alloc]init];
    array3 = [[NSMutableArray alloc]init];
    array4 = [[NSMutableArray alloc]init];
    array5 = [[NSMutableArray alloc]init];
    array6 = [[NSMutableArray alloc]init];
    array7 = [[NSMutableArray alloc]init];
    array8 = [[NSMutableArray alloc]init];
    array9 = [[NSMutableArray alloc]init];
    array10 = [[NSMutableArray alloc]init];
    array11 = [[NSMutableArray alloc]init];
    array12 = [[NSMutableArray alloc]init];
    array13 = [[NSMutableArray alloc]init];
    array14 = [[NSMutableArray alloc]init];
    array15 = [[NSMutableArray alloc]init];
    array16 = [[NSMutableArray alloc]init];
    array17 = [[NSMutableArray alloc]init];
    array18 = [[NSMutableArray alloc]init];
    array19 = [[NSMutableArray alloc]init];
    array20 = [[NSMutableArray alloc]init];
    array21 = [[NSMutableArray alloc]init];
    array22 = [[NSMutableArray alloc]init];
    array23 = [[NSMutableArray alloc]init];
    array24 = [[NSMutableArray alloc]init];
    array25 = [[NSMutableArray alloc]init];
    array26 = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < array.count; i ++) {
        NSString * str = array[i];
        [self ttransformToPinyinWith:str];
    }
    [dataArray addObject:array1];//a
    [dataArray addObject:array2];//b
    [dataArray addObject:array3];//c
    [dataArray addObject:array4];
    [dataArray addObject:array5];
    [dataArray addObject:array6];
    [dataArray addObject:array7];
    [dataArray addObject:array8];
//    [dataArray addObject:array9];//i
    [dataArray addObject:array10];//j
    [dataArray addObject:array11];//k
    [dataArray addObject:array12];
    [dataArray addObject:array13];
    [dataArray addObject:array14];//n
//    [dataArray addObject:array15];//o
    [dataArray addObject:array16];//p
    [dataArray addObject:array17];//q
    [dataArray addObject:array18];
    [dataArray addObject:array19];
    [dataArray addObject:array20];
//    [dataArray addObject:array21];
//    [dataArray addObject:array22];
    [dataArray addObject:array23];
    [dataArray addObject:array24];
    [dataArray addObject:array25];
    [dataArray addObject:array26];
    
    [self saveDataWithDataArray:dataArray dataCacheKey:@"cityData"];
}
+(void)ttransformToPinyinWith:(NSString *)str{
        NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    NSString * string = [mutableString substringToIndex:1];
    if ([string isEqualToString:@"a"]) {
        [array1 addObject:str];
    }else if ([string isEqualToString:@"b"]){
        [array2 addObject:str];
    }
    else if ([string isEqualToString:@"c"]){
        [array3 addObject:str];
    }
    else if ([string isEqualToString:@"d"]){
        [array4 addObject:str];
    }
    else if ([string isEqualToString:@"e"]){
        [array5 addObject:str];
    }
    else if ([string isEqualToString:@"f"]){
        [array6 addObject:str];
    }
    else if ([string isEqualToString:@"g"]){
        [array7 addObject:str];
    }
    else if ([string isEqualToString:@"h"]){
        [array8 addObject:str];
    }
    else if ([string isEqualToString:@"i"]){
        [array9 addObject:str];
    }
    else if ([string isEqualToString:@"j"]){
        [array10 addObject:str];
    }
    else if ([string isEqualToString:@"k"]){
        [array11 addObject:str];
    }
    else if ([string isEqualToString:@"l"]){
        [array12 addObject:str];
    }
    else if ([string isEqualToString:@"m"]){
        [array13 addObject:str];
    }
    else if ([string isEqualToString:@"n"]){
        [array14 addObject:str];
    }
    else if ([string isEqualToString:@"o"]){
        [array15 addObject:str];
    }
    else if ([string isEqualToString:@"p"]){
        [array16 addObject:str];
    }
    else if ([string isEqualToString:@"q"]){
        [array17 addObject:str];
    }
    else if ([string isEqualToString:@"r"]){
        [array18 addObject:str];
    }
    else if ([string isEqualToString:@"s"]){
        [array19 addObject:str];
    }
    else if ([string isEqualToString:@"t"]){
        [array20 addObject:str];
    }
    else if ([string isEqualToString:@"u"]){
        [array21 addObject:str];
    }
    else if ([string isEqualToString:@"v"]){
        [array22 addObject:str];
    }
    else if ([string isEqualToString:@"w"]){
        [array23 addObject:str];
    }
    else if ([string isEqualToString:@"x"]){
        [array24 addObject:str];
    }
    else if ([string isEqualToString:@"y"]){
        [array25 addObject:str];
    }
    else if ([string isEqualToString:@"z"]){
        [array26 addObject:str];
    }

}
+ (void)saveDataWithDataArray:(NSArray *)dataArray dataCacheKey:(NSString *)key{
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    
    NSLog(@"沙盒路径%@",filePath);
    
    BOOL success = [dataArray writeToFile:filePath atomically:YES];
    
    if (success) {
        NSLog(@"数据保存成功");
    }else{
        NSLog(@"数据保存失败");
    }
    
}
+(NSArray *)getCityData{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",@"cityData"]];
    
    NSArray * data = [NSArray arrayWithContentsOfFile:filePath];
    
    return data;
}
//数组模糊搜索，给swift调用
+(NSMutableArray *)getAarry:(NSArray *)array Preicate:(NSPredicate *)preicate{
    NSMutableArray * cityArray = [NSMutableArray arrayWithArray:[array filteredArrayUsingPredicate:preicate]];
    return cityArray;
}
@end
