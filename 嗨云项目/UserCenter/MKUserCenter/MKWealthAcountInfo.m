//
//  MKWealthAcountInfo.m
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKWealthAcountInfo.h"

@implementation MKWealthAcountInfo

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"accountUid" : @"wealth_account_uid",
             @"type" : @"wealth_type",
             @"exchangeRate" : @"exchange_rate"
             };
}

@end
