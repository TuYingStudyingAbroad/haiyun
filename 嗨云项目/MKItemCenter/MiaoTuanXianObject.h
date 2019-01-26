//
//  MiaoTuanXianObject.h
//  嗨云项目
//
//  Created by 小辉 on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface MiaoTuanXianObject : MKBaseObject
/////////////////////拍卖/////////////////////////////
//uid
@property(nonatomic,copy)NSString * auctionUid;
//拍卖类型 1升价 2降价
@property(nonatomic,assign)NSInteger auctionType;
/*生命周期
12去支付
降价拍：1未开始 ->2 进行中 (立即拿下) -> 3还有机会 -> 4已结束
升价拍：1未开始 ->2 进行中（立即参与) -> 11可以叫价 ->12去支付 -> 4已结束*/

////秒杀的生命周期：1代表未开始，2代表进行中，3还有机会，4代表已结束， 11去结算
////限时购的生命周期： 0代表未开始，1代表进行中，2代表已结束

@property(nonatomic,assign)NSInteger lifecycle;
//起拍价
@property (nonatomic,assign)NSInteger startingPrice;
//升价拍保留价
@property (nonatomic,assign)NSInteger endPrice;
//拍卖件数
@property (nonatomic,assign)NSInteger auctionNumber;
//起拍时间(时间戳)
@property (nonatomic,copy)NSString * startTime;
//结束时间（时间戳)
@property (nonatomic,copy)NSString * endTime;
//降价幅度/加价幅度
@property (nonatomic,copy)NSString * priceUnit;
//降价时间间隔/升价延时周期
@property (nonatomic,copy)NSString * timeUnit;
//距离下次降价的时间
@property (nonatomic,copy)NSString * nextCutTime;
//保证金商品价格
@property (nonatomic,copy)NSString * depositPrice;
//保证金商品的sku_uid
@property (nonatomic,copy)NSString * skuUid;
//是否拍到了这个商品 1是 2否
@property (nonatomic,assign)NSInteger isBuyer;

///////////////////////////秒杀///////////////////////

@property (nonatomic,copy)NSString * seckillUid;
//轮询时展示库存量
@property (nonatomic,assign)NSInteger stockNum;
//销售的数量
@property (nonatomic,assign)NSInteger sales;

//////////////////////限时购/////////////////
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *iconImage;


@end
