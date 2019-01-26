//
//  MKCouponObject.m
//  YangDongXi
//
//  Created by windy on 15/4/24.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKCouponObject.h"

@implementation MKCouponObject


+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"couponUid" : @"coupon_uid",
             @"toolCode" : @"tool_code",
             @"discountAmount" : @"discount_amount",
             @"startTime" : @"start_time",
             @"endTime" : @"end_time",
             @"number" : @"number",
             @"propertyList" :@"property_list",
             @"name" :@"name",
             @"content" :@"content",
             @"nearExpireDate" :@"near_expire_date"
             };
}


@end
