//
//  MKDistributorCartObject.m
//  嗨云项目
//
//  Created by 李景 on 16/5/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKDistributorCartObject.h"

@implementation MKDistributorCartObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"distributorId" : @"distributor_id",
             @"distributorShopName" : @"distributor_name",
             @"itemList":@"item_list",
             };
}


@end
