//
//  MKMarketActivityObject.m
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketActivityObject.h"
#import "MKMarketItem.h"

@implementation MKMarketActivityObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"activityUid" : @"activity_uid",
             @"activityName" : @"activity_name",
             @"scope" : @"scope",
             @"couponMark" : @"coupon_mark",
             @"discountAmount" : @"discount_amount",
             @"toolCode" : @"tool_code",
             @"properties" : @"property_list",
             @"itemList":@"item_list",
             @"targetitemList":@"target_item_list",
             @"startTime" : @"start_time",
             @"endTime" : @"end_time",
             @"activityTag" : @"activity_tag",
             @"limitTagStatus" :  @"limit_tag_status",
             @"limitTagDate" : @"limit_tag_date",
             @"icon"     : @"icon"
             };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    if ([propertyName isEqualToString:@"itemList"])
    {
        return [MKMarketItem class];
    }
    return nil;
}

@end
