//
//  MKDeliveryInfo.m
//  YangDongXi
//
//  Created by cocoa on 15/4/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKDeliveryInfo.h"
#import "MKDeliveryDetailItem.h"

@implementation MKDeliveryInfo

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"deliveryType" : @"delivery_type",
             @"deliveryCompany" : @"delivery_company",
             @"deliveryFee" : @"delivery_fee",
             @"deliveryCode" : @"delivery_code",
             @"deliveryDetailList" : @"delivery_detail_list",
             @"expressUrl" : @"express_url"
             };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    if ([propertyName isEqualToString:@"deliveryDetailList"])
    {
        return [MKDeliveryDetailItem class];
    }
    return nil;
}

@end
