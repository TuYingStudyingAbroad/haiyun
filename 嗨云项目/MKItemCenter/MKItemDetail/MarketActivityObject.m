//
//  MarketActivityObject.m
//  嗨云项目
//
//  Created by haiyun on 2016/11/4.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "MarketActivityObject.h"

@implementation MarketActivityObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"activityTag" : @"activity_tag",
             @"limitTagStatus" :  @"limit_tag_status",
             @"limitTagDate" : @"limit_tag_date",
             @"couponMark" :  @"coupon_mark",
             @"toolCode" :  @"tool_code",
             @"icon"     : @"icon"
             };
}

@end
