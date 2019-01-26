//
//  MKAccountInfo.m
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKAccountInfo.h"

@implementation MKAccountInfo

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"userId" : @"user_id",
             @"accessToken" : @"access_token",
             @"refreshToken" : @"refresh_token",
             @"mobile" : @"mobile",
             @"password" : @"password",
             @"inviter" : @"inviter",
             @"sellerId" : @"seller_id"
            };
}

-(NSString *)accountInfoUser
{
    return  [NSString stringWithFormat:@"%@%@%@",self.mobile,self.password,self.inviter];
}
@end
