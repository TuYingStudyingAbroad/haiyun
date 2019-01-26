//
//  MKRealNameObject.m
//  YangDongXi
//
//  Created by windy on 15/5/18.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKRealNameObject.h"

@implementation MKRealNameObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"realName" : @"real_name",
             @"idCard" : @"idcard_no",
             @"frontImage" : @"idcard_front_img",
             @"reverseImage" : @"idcard_reverse_img"
             };
}

@end
