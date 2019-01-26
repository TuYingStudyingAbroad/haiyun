//
//  MKhigoExtraInfo.m
//  YangDongXi
//
//  Created by 杨鑫 on 16/1/20.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import "MKhigoExtraInfo.h"

@implementation MKhigoExtraInfo


+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"taxRate" : @"tax_rate",
             @"originalTaxFee" : @"original_tax_fee",
             @"finalTaxFee" : @"final_tax_fee",
             @"supplyBase" : @"supply_base",
             @"supplyBaseIcon" : @"supply_base_icon",
             @"taxType" : @"tax_type",
             @"deliveryType" : @"delivery_type"
             };
}
@end
