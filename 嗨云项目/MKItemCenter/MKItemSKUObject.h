//
//  MKItemSKUObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKItemSKUObject : MKBaseObject

/**@brief sku uid*/
@property (nonatomic, strong) NSString *skuId;

/**@brief 不知道*/
@property (nonatomic, strong) NSString *skuCode;

/**@brief 商品id*/
@property (nonatomic, strong) NSString *itemId;

/**@brief 条码*/
@property (nonatomic, strong) NSString *barCode;

/**@brief 物料码*/
@property (nonatomic, strong) NSString *materialCode;

/**@brief 市场价*/
@property (nonatomic, assign) NSInteger marketPrice;

/**@brief 促销价*/
@property (nonatomic, assign) NSInteger promotionPrice;

/**@brief 无线价*/
@property (nonatomic, assign) NSInteger wirelessPrice;

/**@brief 库存量*/
@property (nonatomic, assign) NSInteger stockNum;

@property (nonatomic, assign) NSInteger limitNumber;
/**@brief 已售数量*/
@property (nonatomic, assign) NSInteger soldNum;

/**@brief 商品sku属性*/
@property (nonatomic, strong) NSArray *skuProperties;

/**@brief 商品图片*/
@property (nonatomic, strong) NSString *imageUrl;

@end
