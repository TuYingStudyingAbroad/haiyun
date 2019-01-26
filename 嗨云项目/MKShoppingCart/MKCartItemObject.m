//
//  MKCartItemObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKCartItemObject.h"

@implementation MKCartItemObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"cartItemUid" : @"cart_item_uid",
             @"skuUid" : @"sku_uid",
             @"skuSnapshot":@"sku_snapshot",
             @"stockNum" : @"stock_num",
             @"saleMinNum" : @"sale_min_num",
             @"saleMaxNum" : @"sale_max_num",
             @"status" : @"status",
             @"stockNum" : @"stock_num",
             @"shareUserId" : @"share_user_id"
             };
}

@end
