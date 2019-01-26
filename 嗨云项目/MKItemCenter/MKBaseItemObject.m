//
//  MKBaseItemObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseItemObject.h"
#import "NSString+MKExtension.h"

@implementation MKBaseItemObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"itemUid" : @"item_uid",
             @"itemName" : @"item_name",
             @"supplierId" : @"supplier_id",
             @"categoryId" : @"category_id",
             @"itemType" : @"item_type",
             @"iconUrl" : @"icon_url",
             @"descUrl" : @"desc_url",
             @"marketPrice" : @"market_price",
             @"promotionPrice" : @"promotion_price",
             @"wirelessPrice" : @"wireless_price",
             @"saleBegin" : @"sale_begin",
             @"saleEnd" : @"sale_end",
             @"deliveryType" : @"delivery_type",
             @"shopName":@"distributor_name"
             };
}
+(NSString *)pricdStringNOZero:(NSInteger)price{
    return [NSString stringWithFloat:price/100.0];
}
+ (NSString *)priceString:(NSInteger)price
{
    return [NSString stringWithFormat:@"%.2f",price / 100.0];
}

+ (NSString *)discountStringWithPrice1:(NSInteger)price1 andPrice2:(NSInteger)price2
{
    float d = price1 * 1.0 / price2 * 10;
    
    if (d >= 10)
    {
        return nil;
    }
    d = floorf(d * 10) / 10.0;
    //d = (int)(roundf(d * 10.0)) / 10.0;
    
    if (d == 0)
    {
        d = 0.1;
    }
    //NSString *ds = [NSString stringWithFloat:d];
    NSString *ds = [NSString stringWithFormat:@"%.01f",d];
    NSRange dr = [ds rangeOfString:@"."];
    if (dr.location != NSNotFound && dr.location < ds.length - 2)
    {
        NSInteger ind = ([[ds substringWithRange:NSMakeRange(dr.location + 1, 1)] isEqualToString:@"0"] ? 0 : 2);
        ds = [ds substringToIndex:dr.location + ind];
    }
    return ds;
}

@end
