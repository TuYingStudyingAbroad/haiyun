//
//  MKSettlementInfo.m
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKSettlementInfo.h"

@implementation MKSettlementInfo

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"totalPrice" : @"total_price",
             @"deliveryFee" : @"delivery_fee",
             @"discountAmount" : @"discount_amount",
             @"exchangeAmount" : @"exchange_amount",
             @"accountDiscountInfo" : @"discount_info_list",
             @"directDiscountList":@"direct_discount_list",
             @"wealthItems" : @"wealth_account_list",
             @"itemList" : @"item_list"
             };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    if ([propertyName isEqualToString:@"accountDiscountInfo"])
    {
        return [MKAccountDiscountInfo class];
    }
    if ([propertyName isEqualToString:@"directDiscountList"])
    {
        return [MKAccountDiscountInfo class];
    }
    if ([propertyName isEqualToString:@"wealthItems"])
    {
        return [MKWealthAcountInfo class];
    }
    if ([propertyName isEqualToString:@"itemList"])
    {
        return [MKMarketItem class];
    }
    
    return nil;
}

@end
