//
//  MKUserInfo.m
//  YangDongXi
//
//  Created by cocoa on 15/5/26.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKUserInfo.h"

@implementation MKUserInfo

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"userId" : @"id",
             @"userName" : @"nick_name",
             @"inviterId" : @"inviter_id",
             @"invitationCode" : @"invitation_code",
             @"headerUrl" : @"img_url",
             @"mobile"  : @"mobile",
             @"birthday" : @"birthday",
             @"sex" : @"sex",
             @"roleMark":@"role_mark",
             @"fansCount":@"fans_count",
            };
}

@end
