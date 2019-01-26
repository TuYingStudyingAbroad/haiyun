//
//  MKOrderItemObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKOrderItemObject.h"

@implementation MKOrderItemObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"orderItemUid" : @"order_item_uid",
             @"itemUid" : @"item_uid",
             @"itemName" : @"item_name",
             @"iconUrl" : @"icon_url",
             @"skuSnapshot" : @"sku_snapshot",
             @"deliveryType" : @"delivery_type",
             @"itemTypeOne":@"item_type",
             @"refundStatus":@"refund_status",
             @"paymentAmount":@"payment_amount",
             @"discountAmount":@"discount_amount",
             @"point":@"point_amount",
             @"skuUid":@"sku_uid",
             @"canRefundMark":@"can_refund_mark",
             @"higoExtraInfo":@"higo_extra_info",
             @"higoMark":@"higo_mark",
             @"itemSkuId":@"item_sku_id",
             @"shareUserId" : @"share_user_id"
             };
}
+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index{
    if ([propertyName isEqualToString:@"higoExtraInfo"]) {
        return [MKhigoExtraInfo class];
    }
    return nil;
}

+ (NSString *)refundStatusWithString:(MKRefundStatu)refundStatus{
    return @{@(MKApplyStatu)            : @"申请退款中" ,
             @(MKProcessingStatu)       : @"等待退款" ,
             @(MKrefuseStatu)           : @"不同意" ,
             @(MKFinishedStatu)         : @"退款完成" ,
             @(MKFailedStatu)           : @"退款失败",
             @(MKReturningStatu)        : @"退货中"}[@(refundStatus)];
}
+ (NSString *)afterSaleStatusWithString:(MKRefundStatu)refundStatus{
    
    return @{@(MKApplyStatu)            : @"申请售后中" ,
             @(MKProcessingStatu)       : @"等待售后" ,
             @(MKrefuseStatu)           : @"不同意" ,
             @(MKFinishedStatu)         : @"售后完成" ,
             @(MKFailedStatu)           : @"售后失败",
             @(MKFailedStatu)           : @"售后中"}[@(refundStatus)];
}


@end
