//
//  MKBaseItemObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"
#import "MKDistributorInfo.h"

@interface MKBaseItemObject : MKBaseObject

/**@brief 商品id*/
@property (nonatomic, strong) NSString *itemUid;

/**@brief 商品名*/
@property (nonatomic, strong) NSString *itemName;

/**@brief 供应商id*/
@property (nonatomic, assign) NSInteger supplierId;

/**@brief 商品所属类目id*/
@property (nonatomic, assign) NSInteger categoryId;

/**@brief 商品类型*/
@property (nonatomic, assign) NSInteger itemType;

/**@brief 商品主图url*/
@property (nonatomic, strong) NSString *iconUrl;

/**@brief 商品描述url*/
@property (nonatomic, strong) NSString *descUrl;

/**@brief 市场价*/
@property (nonatomic, assign) NSInteger marketPrice;

/**@brief 促销价*/
@property (nonatomic, assign) NSInteger promotionPrice;

/**@brief 无线价*/
@property (nonatomic, assign) NSInteger wirelessPrice;

/**@brief 售卖开始时间*/
@property (nonatomic, strong) NSString *saleBegin;

/**@brief 售卖结束时间*/
@property (nonatomic, strong) NSString *saleEnd;

/**@brief 发货方式：0 未指定，1一般进口，2保税区发货，3海外直邮*/
@property (nonatomic, assign) NSInteger deliveryType;

/**角标url*/
@property (strong,nonatomic) NSString *corner_icon_url;

/**货源地*/
@property (strong,nonatomic) NSString *supply_base;

/**店铺名称*/
@property (nonatomic,strong) NSString *shopName;


+(NSString * )pricdStringNOZero:(NSInteger)price;

/**
 @brief 不会去掉后面0的价格
 */
+ (NSString *)priceString:(NSInteger)price;

/**
 @brief price1/price2的折扣，不带“折”字，保留一位小数，大于10折返回nil
 */
+ (NSString *)discountStringWithPrice1:(NSInteger)price1 andPrice2:(NSInteger)price2;

@end
