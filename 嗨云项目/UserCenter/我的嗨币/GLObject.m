//
//  GLObject.m
//  嗨云项目
//
//  Created by 唯我独尊 on 16/8/24.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "GLObject.h"

@implementation GLObject

+(NSDictionary *)propertyAndKeyMap{
    
    return @{@"myID":@"id",
             @"userId":@"user_id",
             @"totalCome":@"total_in_come",
             @"todayCome":@"today_in_come",
             @"inviterUrl":@"inviter_code_url",
             @"shopUrl":@"shop_url",
             };
    
}

@end
