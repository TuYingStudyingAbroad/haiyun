//
//  tradeTypeObject.m
//  嗨云项目
//
//  Created by 唯我独尊 on 16/5/25.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "tradeTypeObject.h"

@implementation tradeTypeObject

+(NSDictionary *)propertyAndKeyMap{
    
    return @{@"textName":@"text",
             @"timeName":@"time",
             @"amount":@"amount",
             @"amount":@"amount",
             @"status":@"status",
             @"orderSn":@"order_s_n",
             @"orderUid":@"order_uid",
             @"withdrawalsNumber":@"withdrawals_number",
             };
    
}

@end
