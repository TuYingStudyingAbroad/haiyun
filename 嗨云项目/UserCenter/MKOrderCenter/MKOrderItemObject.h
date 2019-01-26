//
//  MKOrderItemObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKSpecificItemObject.h"
#import "MKhigoExtraInfo.h"

typedef NS_ENUM(NSInteger, MKRefundStatu)
{
    MKApplyStatu        = 1,   /**< 申请*/
    MKProcessingStatu   = 2,   /**< 退款中*/
    MKrefuseStatu       = 3,   /**< 不同意*/
    MKFinishedStatu     = 4,   /**< 退款完成*/
    MKFailedStatu      = 5,   /**< 退款失败*/
    MKReturningStatu      = 6,   /**< 退货中*/
};
@interface MKOrderItemObject : MKSpecificItemObject

/**@brief 订单商品uid*/
@property (nonatomic, strong) NSString *orderItemUid;

/**@brief 商品uid*/
@property (nonatomic, strong) NSString *itemUid;

/**@brief 商品名称*/
@property (nonatomic, strong) NSString *itemName;

/**@brief 主图url*/
@property (nonatomic, strong) NSString *iconUrl;

/**@brief 单价，都是 * 100的值*/
@property (nonatomic, assign) float price;

/**@brief 发货方式：0 未指定，1一般进口，2保税区发货，3海外直邮*/
@property (nonatomic, assign) NSInteger deliveryType;

/**@brief sku信息的快照，例如：“颜色:黑色 尺码:xl”*/
@property (nonatomic, strong) NSString *skuSnapshot;

@property (nonatomic,assign)NSInteger state;

@property (nonatomic,strong)NSMutableArray *itemImageArray;

@property (nonatomic,assign)NSInteger itemTypeOne;
/**@brief 金额*/
@property (nonatomic,assign)NSInteger paymentAmount;
/**@brief 余额*/
@property (nonatomic,assign)NSInteger discountAmount;
/**@brief 积分*/
@property (nonatomic,assign)NSInteger point;

/*  */
/**@brief 商品退货状态 1 申请中 2 退款中 3 不同意 4 退款完成 5 退款失败 6 退货中*/
@property (nonatomic,assign)NSInteger refundStatus;

@property (nonatomic,assign)NSInteger canRefundMark;
//跨境标志，1代表该商品为跨境商品，0代表该商品为非跨境商品
@property (nonatomic,assign)NSInteger higoMark;

@property (nonatomic,strong)MKhigoExtraInfo *higoExtraInfo;

/**@brief 商品suk_ID*/
@property (nonatomic,copy) NSString *itemSkuId;

@property (nonatomic, assign)BOOL isStore;

+ (NSString *)refundStatusWithString:(MKRefundStatu)refundStatus;
+ (NSString *)afterSaleStatusWithString:(MKRefundStatu)refundStatus;
@end
