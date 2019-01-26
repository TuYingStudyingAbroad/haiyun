//
//  MKValueAddedServiceObject.m
//  YangDongXi
//
//  Created by 朱艳娇 on 15/12/22.
//  Copyright © 2015年 yangdongxi. All rights reserved.
//

#import "MKValueAddedServiceObject.h"

@implementation MKValueAddedServiceObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"serviceUid":@"service_uid",
             @"serviceName" : @"service_name",
             @"serviceDesc":@"service_desc",
             @"iconUrl":@"icon_url",
             @"servicePrice":@"service_price"
             };
}

@end
