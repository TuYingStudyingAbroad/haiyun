//
//  MiaoTuanXianObject.m
//  嗨云项目
//
//  Created by 小辉 on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MiaoTuanXianObject.h"

@implementation MiaoTuanXianObject
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             //拍卖
             @"auctionUid" : @"auction_uid",
             @"auctionType"      : @"auction_type",
             @"lifecycle"  : @"lifecycle",
             
             @"startingPrice" : @"starting_price",
              @"endPrice" : @"endPrice",
             @"auctionNumber"      : @"auction_number",
             
             @"startTime"  : @"start_time",
             @"endTime" : @"end_time",
             @"priceUnit"      : @"price_unit",
             
             @"timeUnit"  : @"time_unit",
             @"nextCutTime" : @"next_cut_time",
             @"depositPrice"      : @"deposit_price",
             
             @"skuUid"      : @"sku_uid",
             @"isBuyer"  : @"is_buyer",
             
             //秒杀
             @"seckillUid"  : @"seckill_uid",
             @"stockNum" : @"stock_num",
             @"sales"      : @"sales",
             
             //限时购
             @"itemId" : @"item_id",
             @"name" : @"name",
             @"iconImage" : @"iconImage",
             };
}



@end
