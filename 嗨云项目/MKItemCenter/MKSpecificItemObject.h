//
//  MKSpecificItemObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKSpecificItemObject : MKBaseObject

/**@brief 商品sku uid*/
@property (nonatomic, strong) NSString *skuUid;

/**@brief 商品sku uid*/
@property (nonatomic, strong) NSString *itemSkuUid;

/**@brief 购买数量*/
@property (nonatomic, assign) NSInteger number;

/**@brief 经销商ID*/
@property (nonatomic, strong) NSString *distributorId;

/**@brief 商品的itemtype*/
@property (nonatomic, assign) NSInteger itemType;

/**@brief 商品分享者ID*/
@property (nonatomic, strong) NSString *shareUserId;

@end
