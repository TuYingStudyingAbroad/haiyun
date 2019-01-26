//
//  MKSKUPropertyObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKSKUPropertyObject.h"

@implementation MKSKUPropertyObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"propertyId" : @"sku_property_uid",
             @"skuId"      : @"sku_uid",
             @"valueType"  : @"value_type"};
}

- (BOOL)isEqual:(MKSKUPropertyObject *)object
{
    return [object isKindOfClass:[MKSKUPropertyObject class]] &&
           [self.name isEqualToString:[object name]] &&
           [self.value isEqualToString:[object value]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{name : %@, value : %@}", self.name, self.value];
}

@end
