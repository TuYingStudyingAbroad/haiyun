//
//  fansObject.m
//  嗨云项目
//
//  Created by 小辉 on 16/9/6.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "fansObject.h"

@implementation fansObject
+(NSDictionary *)propertyAndKeyMap{
    return @{@"cumMoney":@"cum_money",
             @"gmtCreated":@"gmt_created",
             @"headPortrait":@"head_portrait",
             @"nickName":@"nickname",
             @"sex":@"sex",
             @"userID":@"user_id"
             };
    
}
@end
