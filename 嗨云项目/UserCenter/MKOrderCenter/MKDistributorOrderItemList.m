//
//  MKDistributorOrderItemList.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/18.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKDistributorOrderItemList.h"

@implementation MKDistributorOrderItemList


+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"distributorName" : @"distributor_name",
             @"distributorId" : @"distributor_id",
             @"orderItemList":@"order_item_list"
             };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    if ([propertyName isEqualToString:@"orderItemList"])
    {
        return [MKOrderItemObject class];
    }
    
    return nil;
}


@end
