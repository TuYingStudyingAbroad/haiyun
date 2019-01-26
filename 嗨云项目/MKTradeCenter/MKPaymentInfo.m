//
//  MKPaymentInfo.m
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKPaymentInfo.h"

@implementation MKPaymentInfo

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"paymentId" : @"payment_id",
             @"amount" : @"pay_amount",
             @"outTradeNo" : @"out_trade_no",
             @"status" : @"pay_status",
             @"payTime" : @"pay_time"
             };
}

@end
