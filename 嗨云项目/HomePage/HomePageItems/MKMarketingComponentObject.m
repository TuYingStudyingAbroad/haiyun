//
//  MKMarketingComponentObject.m
//  YangDongXi
//
//  Created by cocoa on 15/5/7.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketingComponentObject.h"

@implementation MKMarketingComponentObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"values" : @"value"
            };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    return [MKMarketingObject class];
}

@end
