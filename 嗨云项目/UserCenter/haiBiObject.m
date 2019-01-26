//
//  haiBiObject.m
//  嗨云项目
//
//  Created by kans on 16/5/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "haiBiObject.h"

@implementation haiBiObject
+(NSDictionary *)propertyAndKeyMap{
    return @{@"wealthAccountUid":@"wealth_account_uid",
             @"wealthType":@"wealth_type",
             @"totalAmount":@"total_amount",
             @"amount":@"amount",
             @"transitionAmount":@"transition_amount",
             @"willExpireAmount":@"will_expire_amount",
             @"exchangeRate":@"exchange_rate",
             @"upperLimit":@"upper_limit",
             };
    
}
@end
