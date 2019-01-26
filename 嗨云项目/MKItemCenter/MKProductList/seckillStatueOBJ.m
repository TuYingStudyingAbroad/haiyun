//
//  seckillStatueOBJ.m
//  嗨云项目
//
//  Created by 小辉 on 16/7/15.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "seckillStatueOBJ.h"

@implementation seckillStatueOBJ
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"timeInterval":@"time_interval",
             @"currentTime":@"current_time",
             @"seckill":@"seckill"
             };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index{
    if ([propertyName isEqualToString:@"seckill"]) {
        return [MiaoTuanXianObject class];
    }
    return nil;
}

@end
