//
//  MKItemObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseItemObject.h"
#import "MKSKUPropertyObject.h"
#import "MKItemImageObject.h"
#import "MKItemBrandObject.h"
#import "MKItemSKUObject.h"
#import "MKItemPropertyObject.h"
#import "MKDistributorInfo.h"
#import "MKhigoExtraInfo.h"
#import "MiaoTuanXianObject.h"
#import "MKItemDiscountObject.h"
#import "MarketActivityObject.h"

typedef NS_ENUM(NSInteger, MKItemStatus)
{
    MKItemStatusPending = 1,
    MKItemStatusAuditThrough = 2,
    MKItemStatusAuditNotThrough = 3,
    MKItemStatusSaling = 4,
    MKItemStatusOffShelf = 5,
    MKItemStatusFrozen = 6
};


@interface MKItemObject : MKBaseItemObject

/**
 @brief 商品附图列表，主图也在其中，主图为第一张图片
 @discussion MKItemImageObject数组
 */
@property (nonatomic, strong) NSArray *itemImages;

@property (nonatomic, strong) MKItemBrandObject *itemBrand;

/**
 @brief 商品sku列表
 @discussion MKItemSKUObject数组
 */
//后台已经处理几种sku可以组合成一件商品 王新辉备注；
@property (nonatomic, strong) NSArray *itemSkus;

/**
 @brief 商品sku属性
 @discussion MKSKUPropertyObject数组
 */
//商品的说有sku 比如两大类 颜色（红，绿） 尺码（A，B），该数值就会有4个字典。后台没有处理，sku不可用也在数组里面 王新辉备注
@property (nonatomic, strong) NSArray *skuProperties;

/**
 @brief 商品属性
 @discussion MKItemPropertyObject数组
 */
//什么货源地啦发货方式啦 王新辉备注，嗨云项目可能没有用到
@property (nonatomic, strong) NSArray *itemProperties;

/**
 @brief 业务属性
 @discussion MKBizPropertyObject数组
 */
@property (nonatomic, strong) NSString *sellerId;

@property (nonatomic, strong) NSArray *bizProperties;

@property (nonatomic, assign) NSInteger minSale;

@property (nonatomic, assign) NSInteger maxSale;

@property (assign,nonatomic) NSInteger limitBuyCount;

@property (nonatomic,strong) MKDistributorInfo *distributorInfo;

//服务标签
@property (nonatomic, strong) NSArray *itemLabelList;

//二维码
@property (nonatomic, strong) NSString *qrCode;

//商品状态
@property (nonatomic, assign) MKItemStatus status;

@property (nonatomic, assign) NSInteger stockStatus;

//跨境标志，1代表该商品为跨境商品，0代表该商品为非跨境商品
@property (nonatomic,assign)NSInteger  higoMark;

//跨境扩展信息
@property (nonatomic,strong)MKhigoExtraInfo *higoExtraInfo;

//商品列表活动标签
@property (nonatomic, assign) NSInteger onSale;

//活动角标
@property (nonatomic, strong) NSString *activityIconUrl;

//优惠券信息
@property (nonatomic ,strong) NSArray *couponList;

//满减送信息
@property (nonatomic ,strong) NSArray *discountInfoList;

//秒杀 团购 拍卖
@property (nonatomic,strong) MiaoTuanXianObject * miaoTuanXianOBJ;

//服务器时间
@property (nonatomic, strong) NSString *time;
//分享后赚的钱
@property (nonatomic, copy) NSString *gains;
//分享后赚的钱的百分比
@property (nonatomic, copy) NSString *gainPercentDesc;
//新的分佣分享金额
@property (nonatomic, copy) NSString *sharingGains;
//新的分佣百分比
@property (nonatomic, copy) NSString *gainSharingDesc;

/**@brief 商品分享者ID*/
@property (nonatomic, strong) NSString *shareUserId;

/***限时购活动**/
@property (nonatomic, strong) NSArray *marketActivityList;


+ (NSString *)stringWithStatus:(MKItemStatus)status;

@end
