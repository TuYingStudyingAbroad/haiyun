//
//  MKOrderDiscountObject.h
//  YangDongXi
//
//  Created by windy on 15/6/3.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKOrderDiscountObject : MKBaseObject

/**@brief 优惠类型：1代表营销活动，2代表虚拟账户*/
@property (nonatomic, assign) NSInteger discountType;


/**@brief 商品suk_ID*/
@property (nonatomic, copy) NSString   *itemSkuId;

//SIMPLE_TOOL(1, "SYS_MARKET_TOOL_000001"),
/**
 * 复合工具
 * 满减送
 */
//COMPOSITE_TOOL(2, "ReachMultipleReduceTool"),

/**
 * 换购
 */
//BARTER_TOOL(3, "BarterTool"),
/**
 * 首单立减
 */
//FIRST_ORDER_DISCOUNT(4, "FirstOrderDiscount"),
/**
 * 限时购
 */
//TIME_RANGE_DISCOUNT(5, "TimeRangeDiscount"),;

/**@brief 优惠标志码，如果discount_type为1，2满减送，3换购，4首单立减，5限时购
 则discount_code跟营销活动的tool_code对应*/
@property (nonatomic, strong) NSString *discountCode;

/**@brief 优惠描述信息*/
@property (nonatomic, strong) NSString *discountDesc;

/**@brief 优惠额度*/
@property (nonatomic, assign) NSInteger discountAmount;

@end
