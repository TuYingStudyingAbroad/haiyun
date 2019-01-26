//
//  YLSafeUserInfo.m
//  嗨云项目
//
//  Created by haiyun on 16/5/26.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeUserInfo.h"

@implementation YLSafeUserInfo

+ (NSDictionary *)propertyAndKeyMap{
    return @{
             @"payPassword" : @"payPassword",
             @"userId" : @"userId",
             @"password" : @"password",
             @"mobile" : @"mobile",
             @"authId" : @"authId",
             @"authName" : @"authName",
             @"authIdCard" : @"authIdCard",
             @"roleMark" : @"roleMark",
             @"authonStatus" : @"authonStatus"
             };
}

@end
