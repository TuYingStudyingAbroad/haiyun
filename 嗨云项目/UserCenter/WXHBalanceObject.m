//
//  WXHBalanceObject.m
//  嗨云项目
//
//  Created by kans on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "WXHBalanceObject.h"

@implementation WXHBalanceObject
+ (NSDictionary *)propertyAndKeyMap{
    return @{
             @"text" : @"text",
             @"time" : @"time",
             @"amount" : @"amount",
             @"status" : @"status",
             @"orderSn" : @"order_sn",
             @"orderUid" : @"order_uid",
            @"withdrawalsNumber":@"withdrawals_number",
             @"refusalReason":@"refusal_reason"
            
             };
}

@end
