//
//  MKCartItemObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseItemObject.h"

@interface MKCartItemObject : MKBaseItemObject

/**@brief 购物车商品uid*/
@property (nonatomic, strong) NSString *cartItemUid;

/**@brief 商品sku uid*/
@property (nonatomic, strong) NSString *skuUid;

/**@brief 商品库存量*/
@property (nonatomic, assign) NSInteger stockNum;

/**@brief 购买数量*/
@property (nonatomic, assign) NSInteger number;

/**@brief 商品sku信息*/
@property (nonatomic, strong) NSString *skuSnapshot;

/**@brief 分销商ID*/
@property (nonatomic, strong) NSString *distributorId;

/**@brief 最小购买限制*/
@property (nonatomic, strong) NSString *saleMinNum;

/**@brief 最大购买限制*/
@property (nonatomic, strong) NSString *saleMaxNum;

/**@brief 商品上下架状态*/
@property (nonatomic, strong) NSString *status;

/**@brief 商品活动标签*/
@property (nonatomic, strong) NSString *bizMark;

/**@brief 本地存储时间*/
@property (nonatomic, assign) NSInteger shopCatTime;
@property (assign, nonatomic) BOOL isChecked;

@property (assign, nonatomic) BOOL isCheckedBtn;
/**@brief 分享ID*/
@property (nonatomic, strong) NSString *shareUserId;

@end
