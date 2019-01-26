//
//  MKPaymentInfo.h
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

typedef NS_ENUM(NSInteger, MKPaymentStatus)
{
    MKPaymentStatusOnPay        = 1,    /**< 未支付*/
    MKPaymentStatusPaid         = 3,    /**< 已支付*/
};

@interface MKPaymentInfo : MKBaseObject

@property (nonatomic, strong) NSString *paymentId;

@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, strong) NSString *outTradeNo;

@property (nonatomic, assign) MKPaymentStatus status;

@property (nonatomic, strong) NSString *payTime;

@end
