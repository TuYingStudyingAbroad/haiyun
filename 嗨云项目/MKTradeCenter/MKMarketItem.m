//
//  MKMarketItem.m
//  YangDongXi
//
//  Created by 杨鑫 on 16/1/13.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import "MKMarketItem.h"
#import "MKValueAddedServiceObject.h"

@implementation MKMarketItem
+ (NSDictionary *)propertyAndKeyMap{
    return @{
             @"itemName":@"item_name",
             @"skuSnapshot":@"sku_snapshot",
             @"iconUrl":@"icon_url",
             @"serviceList":@"service_list",
             @"higoExtraInfo":@"higo_extra_info",
             @"virtualMark":@"virtual_mark",
             @"higoMark":@"higo_mark",
             @"distributor":@"distributor_info",
             @"itemType":@"item_type",
             @"shareUserId":@"share_user_id"
             };
}
+(Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index{
    if ([propertyName isEqualToString:@"serviceList"]) {
        return [MKValueAddedServiceObject class];
    }
    if ([propertyName isEqualToString:@"higoExtraInfo"]) {
        return [MKhigoExtraInfo class];
    }
    if ([propertyName isEqualToString:@"distributor"]) {
        return [MKDistributorInfo class];
    }
    return nil;
}
+ (NSString *)textForType:(MKCustomCommodityType)Type{
    return @{@(MKItemgiftsSign)         : @"活动" ,
             @(MKItemSecondsKill)       : @"秒杀",
             @(MKItemSpellGroup)        : @"拼团",
             @(MKItemTimeToBuy)         : @"限时购"
             }[@(Type)];
}
@end
