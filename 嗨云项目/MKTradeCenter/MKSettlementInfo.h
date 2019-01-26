//
//  MKSettlementInfo.h
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"
#import "MKAccountDiscountInfo.h"
#import "MKWealthAcountInfo.h"
#import "MKMarketItem.h"


@interface MKSettlementInfo : MKBaseObject

@property (nonatomic, assign) NSInteger totalPrice;

@property (nonatomic, assign) NSInteger deliveryFee;

@property (nonatomic, assign) NSInteger discountAmount;

@property (nonatomic, assign) NSInteger exchangeAmount;

@property (nonatomic, strong) NSArray *accountDiscountInfo;

@property (nonatomic, strong) NSArray *directDiscountList;

@property (nonatomic, strong) NSArray *wealthItems;

@property (nonatomic, strong) NSArray *itemList;

@end
