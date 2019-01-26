//
//  ShopCartFMDB.m
//  嗨云项目
//
//  Created by 唯我独尊 on 16/9/1.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "ShopCartFMDB.h"
#import <FMDB.h>
#import "MKHistoryItemObject.h"

#define ShopCartTable @"ShopCartTableList"

@interface ShopCartFMDB ()

@property (nonatomic) FMDatabase *db;

@end


@implementation ShopCartFMDB
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@".ShopCartTableList"];
        self.db = [FMDatabase databaseWithPath:path];
        [self.db open];
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS "ShopCartTable" ("
         "\"time\" integer,"
         "\"deliveryType\" integer,"
         "\"iconUrl\" text,"
         "\"itemName\" text,"
         "\"skuSnapshot\" text,"
         "\"itemType\" integer,"
         "\"itemUid\" text,"
         "\"number\" integer,"
         "\"marketPrice\" integer,"
         "\"promotionPrice\" integer,"
         "\"wirelessPrice\" integer,"
         "\"saleMinNum\" text,"
         "\"saleMaxNum\" text,"
         "\"status\" text,"
         "\"stockNum\" integer,"
         "\"distributorId\" text,"
         "\"skuUid\" text,"
         "\"bizMark\" text,"
         "PRIMARY KEY(\"skuUid\")"
         ");"];
        FMResultSet *rs = [self.db executeQuery:@"SELECT count(*) FROM "ShopCartTable];
        [rs next];
        NSInteger c = [rs intForColumnIndex:0];
        if (c > 200)
        {
            [self.db executeUpdate:@"DELETE FROM "ShopCartTable" WHERE \"time\" IN (SELECT \"time\" FROM "ShopCartTable" ORDER BY \"time\" DESC LIMIT 200, -1)"];
        }
    }
    return self;
}

- (void)newShopCartItem:(MKCartItemObject *)item
{
    //[self deleteItem:item];
    
    
    FMResultSet *rs = [self.db executeQuery:@"select * from "ShopCartTable" where \"skuUid\"=?",item.skuUid];
    
    if([rs next])
        
    {
        MKCartItemObject *item1 = [[MKCartItemObject alloc] init];
        item1.number = [rs longForColumnIndex:7];
        
        [self.db executeUpdate:@"update "ShopCartTable" set \"number\"=? where \"skuUid\"=?",[NSString stringWithFormat:@"%ld",item1.number+item.number],item.skuUid];
        
    }else {
        
        
        NSInteger t = [[NSDate date] timeIntervalSince1970];
        [self.db executeUpdate:@"INSERT INTO "ShopCartTable
         " (\"time\", \"deliveryType\", \"iconUrl\", \"itemName\", \"skuSnapshot\", \"itemType\", \"itemUid\", \"number\", \"marketPrice\", \"promotionPrice\", \"wirelessPrice\", \"saleMinNum\", \"saleMaxNum\",\"status\",\"stockNum\",\"distributorId\",\"skuUid\",\"bizMark\")"
         " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,? ,? ,? ,? ,?)",
         @(t), @(item.deliveryType), item.iconUrl, item.itemName, item.skuSnapshot, @(item.itemType), item.itemUid, @(item.number), @(item.marketPrice), @(item.promotionPrice), @(item.wirelessPrice), item.saleMinNum, item.saleMaxNum,item.status,@(item.stockNum),item.distributorId,item.skuUid,item.bizMark];
    }

   
}

- (void)deleteItem:(MKCartItemObject *)item
{
    [self.db executeUpdate:@"DELETE FROM "ShopCartTable" WHERE \"skuUid\"=?", item.skuUid];
}

- (NSArray *)lastItemFromIndex:(NSInteger)index count:(NSInteger)count
{
    NSDate *date = [NSDate date];
    NSInteger time = [date timeIntervalSince1970];
    NSInteger mowTime = time - 30*24*60*60;
    FMResultSet *res = [self.db executeQuery:@"SELECT * FROM "ShopCartTable" where \"time\"> ? ORDER BY \"time\" DESC LIMIT ?, ?",@(mowTime), @(index), @(count)];
    NSMutableArray *ar = [NSMutableArray array];
    while ([res next])
    {
        MKCartItemObject *item = [[MKCartItemObject alloc] init];
        item.shopCatTime = [res unsignedLongLongIntForColumnIndex:0];
        item.deliveryType = [res longForColumnIndex:1];
        item.iconUrl = [res stringForColumnIndex:2];
        item.itemName = [res stringForColumnIndex:3];
        item.skuSnapshot = [res stringForColumnIndex:4];
        item.itemType = [res longForColumnIndex:5];
        item.itemUid = [res stringForColumnIndex:6];
        item.number = [res longForColumnIndex:7];
        item.marketPrice = [res longForColumnIndex:8];
        item.promotionPrice = [res longForColumnIndex:9];
        item.wirelessPrice = [res longForColumnIndex:10];
        item.saleMinNum = [res stringForColumnIndex:11];
        item.saleMaxNum = [res stringForColumnIndex:12];
        item.status = [res stringForColumnIndex:13];
        item.stockNum = [res longForColumnIndex:14];
        item.distributorId = [res stringForColumnIndex:15];
        item.skuUid = [res stringForColumnIndex:16];
        item.bizMark = [res stringForColumnIndex:17];
        [ar addObject:item];
    }
    return [ar copy];
}

- (void)clear
{
    [self.db executeUpdate:@"DELETE FROM "ShopCartTable];
}
- (void)comiit:(MKCartItemObject *)item
{
   
    
    
        FMResultSet *rs = [self.db executeQuery:@"select * from "ShopCartTable" where \"skuUid\"=?",item.skuUid];
    
         if([rs next])
    
        {
    
            NSLog(@"dddddslsdkien");
    
            [self.db executeUpdate:@"update "ShopCartTable" set \"number\"=? where \"skuUid\"=?",2,item.skuUid];
    
        }
    
    
}


@end

