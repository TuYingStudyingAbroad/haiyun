//
//  MKMarketItem.h
//  YangDongXi
//
//  Created by 杨鑫 on 16/1/13.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import "MKMarketItemObject.h"
#import "MKhigoExtraInfo.h"
#import "MKDistributorInfo.h"


typedef NS_OPTIONS(NSUInteger, MKCustomCommodityType) {
    MKItemOrdinaryGoods = 0,//普通商品
    MKItemgifts = 2, //赠品
    MKBuyGoods = 3,//换购商品
    MKBuyGoodsSub = 4,//换购主商品
    MKPackageGoods= 5, //套装商品
    MKItemgiftsSign = 6, //赠品标签
    MKItemSecondsKill = 7,//秒杀
    MKItemSpellGroup = 8,//拼团
    MKItemTimeToBuy = 9,//限时购
    
};

@interface MKMarketItem : MKMarketItemObject

@property (nonatomic,strong)NSString *itemName;

@property (nonatomic,strong)NSString *skuSnapshot;

@property (nonatomic,strong)NSString *iconUrl;

//增值服务列表
@property (nonatomic,strong)NSArray *serviceList;

//税费信息
@property (nonatomic,strong)MKhigoExtraInfo *higoExtraInfo;
//跨境标志，1代表该商品为跨境商品，0代表该商品为非跨境商品
@property (nonatomic,assign)NSInteger higoMark;

@property (nonatomic,assign)MKCustomCommodityType commodityItemType;


@property (nonatomic,strong)MKDistributorInfo *distributor;
//虚拟商品标志 1实物 2虚拟
@property (nonatomic,strong)NSString *virtualMark;

@property (nonatomic,assign)NSInteger itemType;

/**@brief 商品分享者ID*/
@property (nonatomic, strong) NSString *shareUserId;

+ (NSString *)textForType:(MKCustomCommodityType)Type;

@end
