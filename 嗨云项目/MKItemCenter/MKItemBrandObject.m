//
//  MKItemBrandObject.m
//  YangDongXi
//
//  Created by cocoa on 15/6/2.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKItemBrandObject.h"

@implementation MKItemBrandObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"brandId" : @"id",
             @"logoUrl" : @"logo_url",
             @"brandDesc" : @"brand_desc",
             @"bannerImg" : @"banner_img"
             };
}

@end
