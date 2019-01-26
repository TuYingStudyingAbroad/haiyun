//
//  MKItemDiscountObject.m
//  嗨云项目
//
//  Created by 李景 on 16/7/20.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKItemDiscountObject.h"
#import "MKMarketActivityObject.h"

@implementation MKItemDiscountObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"consume" : @"consume",
             @"discountAmount" : @"discount_amount",
             @"freePostage" : @"free_postage",
             @"giftList" : @"gift_list",
             @"marketActivity" : @"market_activity",
             @"itemList" : @"item_list",
             @"availableCouponList" : @"available_coupon_list",
             @"savedPostage" : @"saved_postage",
             @"sellerId":@"seller_id",
             @"isAvailable":@"is_available",
             @"desc" : @"desc",
             @"couponList":@"coupon_list"
             };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index{
    if ([propertyName isEqualToString:@"marketActivity"]) {
        return [MKMarketActivityObject class];
    }
    return nil;
}


@end
