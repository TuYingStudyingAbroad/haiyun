//
//  MKSellerObject.m
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKSellerObject.h"

@implementation MKSellerObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"sellerId" : @"seller_id",
             @"type" : @"seller_type",
             @"name" : @"seller_name"
             };
}

@end
