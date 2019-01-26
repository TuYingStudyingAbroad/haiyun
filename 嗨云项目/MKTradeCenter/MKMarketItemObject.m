//
//  MKMarketItemObject.m
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketItemObject.h"

@implementation MKMarketItemObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"itemSkuUid" : @"item_sku_uid",
             @"itemUid" : @"item_uid",
             @"sellerId" : @"seller_id",
             @"unitPrice" : @"unit_price",
             @"brandId":@"brand_id"
             };
}

@end
