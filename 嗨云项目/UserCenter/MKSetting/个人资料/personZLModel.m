//
//  personZLModel.m
//  嗨云项目
//
//  Created by 唯我独尊 on 16/5/26.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "personZLModel.h"

@implementation personZLModel

+(NSDictionary *)propertyAndKeyMap{
    
    return @{@"birthday":@"birthday",
             @"sex":@"sex",
             @"img_url":@"img_url",
             @"nickName":@"nick_name",
             @"wxNB":@"wechat",
             @"qqNB":@"qq_code",
             };
    
}

@end
