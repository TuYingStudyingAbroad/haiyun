//
//  MKCategoryObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKCategoryObject.h"

@implementation MKCategoryObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"categoryId" : @"id",
             @"name" : @"cate_name",
             @"level" : @"cate_level",
             @"pId" : @"parent_id",
             @"topId" : @"top_id",
             @"sort" : @"sort"
             };
}

@end
