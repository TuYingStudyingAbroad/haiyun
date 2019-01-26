//
//  MKAccountDiscountInfo.h
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"
#import "MKMarketActivityObject.h"
#import "MKMarketItemObject.h"
#import "MKCouponObject.h"


@interface MKAccountDiscountInfo : MKBaseObject

@property (nonatomic, strong) MKMarketActivityObject *marketActivity;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSArray *giftList;

@property (nonatomic, strong) NSArray *availableCoupons;

@property (nonatomic, assign) NSInteger discountAmount;

@property (nonatomic, assign) NSInteger consume;

@end
