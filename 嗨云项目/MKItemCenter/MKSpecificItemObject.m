//
//  MKSpecificItemObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKSpecificItemObject.h"

@implementation MKSpecificItemObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"skuUid" : @"item_sku_uid",
             @"itemSkuUid":@"sku_uid",
             @"number" : @"number",
             @"distributorId":@"distributor_id",
             @"itemType":@"item_type",
             @"shareUserId" : @"share_user_id"};
}

@end
