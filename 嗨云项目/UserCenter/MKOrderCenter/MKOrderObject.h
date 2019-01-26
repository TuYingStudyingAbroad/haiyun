//
//  MKOrderObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"
#import "MKInvoiceInfo.h"
#import "MKConsigneeObject.h"
#import "MKDeliveryInfo.h"
#import "MKCouponObject.h"
#import "MKOrderItemObject.h"
#import "MKSellerObject.h"
#import "MKPaymentInfo.h"
#import "MKWealthAcountInfo.h"
#import "MKOrderDiscountObject.h"
#import "MKDistributorOrderItemList.h"

#define MKOrderStatusChangedNotification @"MKOrderStatusChangedNotification"

typedef NS_ENUM(NSInteger, MKOrderStatus)
{
    //（待付款）
    MKOrderStatusUnpaid         = 10,   /**< 未支付*/
    
    //(已取消)
    MKOrderStatusCanceled       = 20,   /**< 已取消*/
    MKOrderStatusSellerCancel   = 21,   /**< 卖家已取消*/
    //(待发货)
    MKOrderStatusPaid           = 30,   /**< 待推送*/
    MKOrderStatusDelivery       = 35,   /**< 待发货*/
    //(待收货)
    MKOrderStatusDeliveried     = 40,   /**< 已发货 待收货*/
   
    //(不会出来)
    MKOrderStatusRefundApply    = 70,   /**< 退款中*/
    MKOrderStatusRefundParting  = 71,   /**< 代表部分退款中*/
    MKOrderStatusRefundPart     = 72,   /**< 代表部分退款完成*/
   
    //(已关闭)
    MKOrderStatusRefundFinished = 80,   /**< 退款完成*/
    //(已完成)
    MKOrderStatusSignOff        = 50,   /**< 已签收*/
    MKOrderStatusAppraised      = 60,   /**< 已评价*/
    MKOrderStatusOrderClosed    = 90,   /**< 订单关闭*/
    
};

typedef NS_ENUM(NSInteger, MKOrderItemSource)
{
    MKOrderItemSourceOther = 0,             /**< 其他*/
    MKOrderItemSourceShoppingCart = 1,      /**< 购物车*/
    MKOrderItemSourceImmediatelyBuy = 2,    /**< 立即购买*/
};

@interface MKOrderObject : MKBaseObject


/**@brief 订单唯一id*/
@property (nonatomic, strong) NSString *orderUid;

/**@brief 订单序列号*/
@property (nonatomic, strong) NSString *orderSn;

/**@brief 分销商分组*/
@property (nonatomic, strong) NSMutableArray *distributorOrderItem;

/**@brief 为了布局方便新增数组*/
@property (nonatomic, strong) NSMutableArray *dataSouce;

/**@brief 下单商品信息, MKOrderItemObject对象数组*/
@property (nonatomic, strong) NSMutableArray *orderItems;

/**@brief 卖家信息*/
@property (nonatomic, strong) MKSellerObject *seller;

/**@brief 是否需要发票*/
@property (nonatomic, assign) BOOL isInvoice;

/**@brief 发票信息*/
@property (nonatomic, strong) MKInvoiceInfo *invoice;

/**@brief 用户备注*/
@property (nonatomic, strong) NSString *userMemo;

/**@brief 订单类型*/
@property (nonatomic, assign) NSInteger orderType;

/**@brief 订单状态*/
@property (nonatomic, assign) MKOrderStatus orderStatus;

/**@brief 订单总金额*/
@property (nonatomic, assign) NSInteger totalPrice;

/**@brief 运费*/
@property (nonatomic, assign) float deliveryFee;

/**@brief 订单优惠后金额*/
@property (nonatomic, assign) NSInteger totalAmount;

/**@brief 收货信息*/
@property (nonatomic, strong) MKConsigneeObject *consignee;

/**@brief 配送信息*/
@property (nonatomic, strong) NSArray *deliveryInfo;

/**@brief 支付信息*/
@property (nonatomic, strong) MKPaymentInfo *paymentInfo;

/**@brief 订单优惠信息列表*/
@property (nonatomic, strong) NSArray *discountInfo;

/**@brief 订单使用优惠券列表*/
@property (nonatomic, strong) NSArray *couponItems;

/**@brief 订单使用的虚拟财富列表*/
@property (nonatomic, strong) NSArray *wealthItems;

/**@brief 支付方式id*/
@property (nonatomic, assign) NSInteger paymentId;

/**@brief 配送方式id*/
@property (nonatomic, assign) NSInteger deliveryId;

/**@brief 倒计时*/
@property (nonatomic, assign) NSInteger payTimeout;

/**@brief 目前时间*/
@property (nonatomic, strong) NSDate *nowTime;

/**@brief 订单取消的时间，定时器用*/
@property (nonatomic, strong) NSString *cancelOrderTime;

/***取消时间*/
@property (nonatomic, strong) NSString *cancelTime;

/**@brief 下单时间*/
@property (nonatomic, strong) NSString *orderTime;

/**@brief 支付时间*/
@property (nonatomic, strong) NSString *payTime;

/**@brief 发货时间*/
@property (nonatomic, strong) NSString *consignTime;

/**@brief 收货时间*/
@property (nonatomic, strong) NSString *receiptTime;

/**@brief 服务器时间*/
@property (nonatomic,strong) NSString *currentTime;

/**@brief 商品来源*/
@property (nonatomic, assign) MKOrderItemSource orderItemSource;

/**是否跨境税**/
@property (nonatomic,strong)MKhigoExtraInfo *higoExtraInfo;

/**跨境税费，如果不是跨境不显示**/
@property (nonatomic,copy) NSString *taxFee;

/**@brief 订单中总商品个数*/
@property (nonatomic, assign) NSInteger orderNum;

/**@brief 商品分享人ID*/
@property (nonatomic, strong) NSString *shareUserId;

-(NSInteger)ourOrderStatus;

+ (NSString *)textForStatus:(MKOrderStatus)status;
/**
 *  支付方式
 *
 *  @return 支付方式
 */
-(NSString *)ourPayment;

@end
