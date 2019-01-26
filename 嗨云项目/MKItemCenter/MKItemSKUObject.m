//
//  MKItemSKUObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKItemSKUObject.h"
#import "MKSKUPropertyObject.h"

@implementation MKItemSKUObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"skuId" : @"sku_uid",
             @"skuCode" : @"sku_code",
             @"itemId" : @"item_uid",
             @"barCode" : @"bar_code",
             @"materialCode" : @"material_code",
             @"marketPrice" : @"market_price",
             @"promotionPrice" : @"promotion_price",
             @"wirelessPrice" : @"wireless_price",
             @"stockNum" : @"stock_num",
             @"soldNum" : @"sold_num",
             @"skuProperties" : @"sku_property_list",
             @"imageUrl" : @"image_url",
             @"limitNumber" : @"limit_number"};
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    if ([propertyName isEqualToString:@"skuProperties"])
    {
        return [MKSKUPropertyObject class];
    }
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{code : %@, stock : %li}", self.skuCode, (long)self.stockNum];
}

@end
