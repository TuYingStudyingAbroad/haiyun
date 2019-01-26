//
//  MKItemObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKItemObject.h"
#import "MKSKUPropertyObject.h"
#import "MKItemImageObject.h"
#import "MKItemSKUObject.h"
#import "MKBizPropertyObject.h"


@implementation MKItemObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"skuProperties" : @"sku_property_list",
             @"sellerId" : @"seller_id",
             @"itemImages" : @"item_image_list",
             @"itemSkus" : @"item_sku_list",
             @"itemProperties" : @"item_property_list",
             @"itemBrand" : @"item_brand",
             @"bizProperties" : @"biz_property_list",
             @"minSale" : @"sale_min_num",
             @"maxSale" : @"sale_max_num",
             @"limitBuyCount":@"limit_buy_count",
             @"distributorInfo":@"distributor_info",
             @"higoMark":@"higo_mark",
             @"higoExtraInfo":@"higo_extra_info",
             @"itemLabelList":@"item_label_list",
             @"qrCode" : @"qr_code",
             @"stockStatus": @"stock_status",
             @"miaoTuanXianOBJ":@"item_extra_info",
             @"onSale":@"on_sale",
             @"activityIconUrl":@"activity_icon_url",
             @"couponList":@"coupon_list",
             @"discountInfoList":@"discount_info_list",
             @"shareUserId" : @"share_user_id",
             @"gainPercentDesc" : @"gain_percent_desc",
             @"marketActivityList" : @"market_activity_list",
             @"gainSharingDesc"  : @"gain_sharing_desc",
             @"sharingGains"    : @"sharing_gains"
            };
}

+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    if ([propertyName isEqualToString:@"skuProperties"])
    {
        return [MKSKUPropertyObject class];
    }
    if ([propertyName isEqualToString:@"itemImages"])
    {
        return [MKItemImageObject class];
    }
    if ([propertyName isEqualToString:@"itemSkus"])
    {
        return [MKItemSKUObject class];
    }
    if ([propertyName isEqualToString:@"itemProperties"])
    {
        return [MKItemPropertyObject class];
    }
    if ([propertyName isEqualToString:@"bizProperties"])
    {
        return [MKBizPropertyObject class];
    }
    if ([propertyName isEqualToString:@"distributorInfo"]) {
        return [MKDistributorInfo class];
    }
    if ([propertyName isEqualToString:@"higoExtraInfo"]) {
        return [MKhigoExtraInfo class];
    }
    if ([propertyName isEqualToString:@"miaoTuanXianOBJ"]) {
        return [MiaoTuanXianObject class];
    }
    if ([propertyName isEqualToString:@"itemBrand"]) {
        return [MKItemBrandObject class];
    }
    if ([propertyName isEqualToString:@"marketActivity"]) {
        return [MarketActivityObject class];
    }
    return nil;
}

+ (NSString *)stringWithStatus:(MKItemStatus)status
{
    if (status == MKItemStatusSaling)
    {
        return @"热卖中...";
    }
    if (status < MKItemStatusSaling)
    {
        return @"商品还未上架";
    }
    return @"商品已下架";
}

@end
