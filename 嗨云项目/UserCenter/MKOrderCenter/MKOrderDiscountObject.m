//
//  MKOrderDiscountObject.m
//  YangDongXi
//
//  Created by windy on 15/6/3.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKOrderDiscountObject.h"

@implementation MKOrderDiscountObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"discountType" : @"discount_type",
             @"discountCode" : @"discount_code",
             @"discountDesc" : @"discount_desc",
             @"discountAmount" : @"discount_amount",
             @"itemSkuId" :@"item_sku_id",
             };
}

@end
