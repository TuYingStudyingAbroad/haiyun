//
//  MKDeliveryDetailItem.m
//  YangDongXi
//
//  Created by windy on 15/5/5.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDeliveryDetailItem.h"

@implementation MKDeliveryDetailItem

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"deliveryDetailUid" : @"delivery_detail_uid",
             @"opTime" : @"op_time",
             @"content" : @"content"
             };
}
@end
