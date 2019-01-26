//
//  MKSpecificOrderObject.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/27.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKSpecificOrderObject.h"

@implementation MKSpecificOrderObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"skuUid" : @"sku_uid",
             @"number" : @"number",
             @"distributorId":@"distributor_id",
             @"itemType":@"item_type",
             @"shareUserId":@"share_user_id"};
}
@end
