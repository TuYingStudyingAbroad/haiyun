//
//  MKConsigneeObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKConsigneeObject.h"

@implementation MKConsigneeObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"consigneeUid" : @"consignee_uid",
             @"userId" : @"user_id",
             @"countryCode" : @"country_code",
             @"country" : @"country",
             @"provinceCode" : @"province_code",
             @"province" : @"province",
             @"cityCode" : @"city_code",
             @"city" : @"city",
             @"areaCode" : @"area_code",
             @"area" : @"area",
             @"streetCode" : @"town_code",
             @"isDefault" : @"is_default",
             @"idNo":@"id_card_no"
             };
}

@end
