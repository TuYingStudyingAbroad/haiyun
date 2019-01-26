//
//  MKOrderObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKOrderObject.h"

@interface MKOrderObject ()


@end

@implementation MKOrderObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"orderUid" : @"order_uid",
             @"orderSn" : @"order_sn",
             @"orderItems" : @"order_item_list",
             @"isInvoice" : @"is_invoice",
             @"userMemo" : @"user_memo",
             @"orderStatus" : @"order_status",
             @"totalPrice" : @"total_price",
             @"deliveryFee" : @"delivery_fee",
             @"totalAmount" : @"total_amount",
             @"deliveryInfo" : @"delivery_info_list",
             @"paymentInfo" : @"order_payment",
             @"discountInfo" : @"order_discount_list",
             @"couponItems" : @"coupon_list",
             @"wealthItems" : @"wealth_account_list",
             @"paymentId" : @"payment_id",
             @"deliveryId" : @"delivery_id",
             @"orderTime" : @"order_time",
             @"orderType" :@"type",
             @"payTime" : @"pay_time",
             @"consignTime" : @"consign_time",
             @"receiptTime" : @"receipt_time",
             @"orderItemSource" : @"source_type",
             @"distributorOrderItem":@"distributor_order_item_list",
             @"payTimeout":@"pay_timeout",
             @"higoExtraInfo":@"higo_extra_info",
             @"currentTime":@"cur_date",
             @"consignee":@"consignee",
             @"cancelTime":@"cancel_time",
             @"taxFee":@"tax_fee"
             };
}


+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    if ([propertyName isEqualToString:@"orderItems"])
    {
        return [MKOrderItemObject class];
    }
    if ([propertyName isEqualToString:@"deliveryInfo"])
    {
        return [MKDeliveryInfo class];
    }
    if ([propertyName isEqualToString:@"discountInfo"])
    {
        return [MKOrderDiscountObject class];
    }
    if ([propertyName isEqualToString:@"couponItems"])
    {
        return [MKCouponObject class];
    }
    if ([propertyName isEqualToString:@"wealthItems"])
    {
        return [MKWealthAcountInfo class];
    }
    if ([propertyName isEqualToString:@"distributorOrderItem"])
    {
        return [MKDistributorOrderItemList class];
    }
    if ([propertyName isEqualToString:@"consignee"]) {
        return [MKConsigneeObject class];
    }
    if ([propertyName isEqualToString:@"higoExtraInfo"]) {
        return [MKhigoExtraInfo class];
    }
    
    return nil;
}


+ (NSString *)textForStatus:(MKOrderStatus)status
{
    return @{@(MKOrderStatusUnpaid)         : @"待付款" ,
             @(MKOrderStatusCanceled)       : @"已取消" ,
             @(MKOrderStatusSellerCancel)   : @"已取消",
             @(MKOrderStatusPaid)           : @"待发货" ,
             @(MKOrderStatusDelivery)       : @"待发货",
             @(MKOrderStatusSellerCancel)   : @"卖家已取消",
             @(MKOrderStatusPaid)           : @"待推送" ,
             @(MKOrderStatusDeliveried)     : @"待收货" ,
             @(MKOrderStatusSignOff)        : @"已完成" ,
             @(MKOrderStatusAppraised)      : @"已完成" ,
             @(MKOrderStatusRefundApply)    : @"退款中" ,
             @(MKOrderStatusRefundParting)  : @"部分退款中",
             @(MKOrderStatusRefundPart)     : @"代表部分退款完成",
             @(MKOrderStatusRefundFinished) : @"已关闭",
             @(MKOrderStatusOrderClosed)    : @"已完成"}[@(status)];
}

-(NSInteger)ourOrderStatus
{
    NSInteger status = 5;
    switch (self.orderStatus) {
        case MKOrderStatusUnpaid://待付款
        {
            status = 0;
        }
            break;
        case MKOrderStatusPaid:
        case MKOrderStatusDelivery://待发货
        {
            status = 1;
        }
            break;
        case MKOrderStatusDeliveried://待收货
        {
            status = 2;
        }
            break;
        case MKOrderStatusCanceled:
        case MKOrderStatusSellerCancel://已取消
        {
            status = 3;
        }
            break;
        case MKOrderStatusRefundFinished://已关闭
        {
            status = 4;
        }
            break;
        case MKOrderStatusSignOff://已完成
        case MKOrderStatusAppraised:
        case MKOrderStatusOrderClosed:
        {
            status = 5;
        }
            break;
        default:
            break;
    }
    return status;
}

-(NSString *)ourPayment
{
    NSString *payment = @"";
    if ( self.paymentInfo.status == MKPaymentStatusPaid )
    {
        switch ([self.paymentInfo.paymentId integerValue]) {
            case 1:
            case 4:
            {
                payment = @"支付宝支付";
            }
                break;
            case 2:
            case 5:
            {
                payment = @"微信支付";
            }
                break;
            case 3:
            case 6:
            {
                payment = @"银联支付";
            }
                break;
            case 11:
            {
                payment = @"账户余额支付";
            }
                break;
            case 12:
            {
                payment = @"嗨币支付";
            }
                break;
            case 13:
            case 14:
            {
                payment = @"连连支付";
            }
                break;
            default:
                break;
        }
    }
    return payment;
}
@end
