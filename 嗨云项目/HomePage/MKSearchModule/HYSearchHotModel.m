//
//  HYSearchHotModel.m
//  嗨云项目
//
//  Created by haiyun on 16/9/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYSearchHotModel.h"

@implementation HYSearchHotModel

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"Id" : @"id",
             @"hotName" : @"hot_name",
             @"indexSort":@"index_sort",
             };
}

@end
