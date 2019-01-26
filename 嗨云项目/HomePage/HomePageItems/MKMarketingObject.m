//
//  MKMarketingObject.m
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketingObject.h"
#import "MKMarketingListItem.h"
#import "MKGridBlockList.h"
@implementation MKMarketingObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"desc" : @"description",
            
            };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    if([propertyName isEqualToString:@"itemList"])
    {
        return [MKMarketingMarqueeItem class];
    }
    if ([propertyName isEqualToString:@"gridList"]) {
        return [MKGridBlockList class];
    }
    return [MKMarketingListItem class];
}

@end
