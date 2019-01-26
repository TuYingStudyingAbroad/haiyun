//
//  MKAccountDiscountInfo.m
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKAccountDiscountInfo.h"
#import "MKMarketItem.h"

@implementation MKAccountDiscountInfo

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"marketActivity" : @"market_activity",
             @"items" : @"item_list",
             @"availableCoupons" : @"available_coupon_list",
             @"discountAmount" : @"discount_amount",
             @"consume":@"consume",
             @"giftList":@"gift_list",
             };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    if ([propertyName isEqualToString:@"items"])
    {
        return [MKMarketItem class];
    }
    if ([propertyName isEqualToString:@"giftList"])
    {
        return [MKMarketItem class];
    }
    if ([propertyName isEqualToString:@"availableCoupons"])
    {
        return [MKCouponObject class];
    }
    return nil;
}

@end
