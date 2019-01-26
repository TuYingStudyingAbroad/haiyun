//
//  MKHistoryModel.m
//  YangDongXi
//
//  Created by cocoa on 15/5/11.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKHistoryModel.h"
#import <FMDB.h>
#import "MKHistoryItemObject.h"

#define browseHistoryTable @"browseHistoryTable"

@interface MKHistoryModel ()

@property (nonatomic) FMDatabase *db;

@end


@implementation MKHistoryModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@".browseHistory"];
        self.db = [FMDatabase databaseWithPath:path];
        [self.db open];
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS "browseHistoryTable" ("
                                 "\"time\" integer,"
                                 "\"itemUid\" text,"
                                 "\"itemName\" text,"
                                 "\"supplierId\" integer,"
                                 "\"categoryId\" integer,"
                                 "\"itemType\" integer,"
                                 "\"iconUrl\" text,"
                                 "\"descUrl\" text,"
                                 "\"marketPrice\" integer,"
                                 "\"promotionPrice\" integer,"
                                 "\"wirelessPrice\" integer,"
                                 "\"saleBegin\" text,"
                                 "\"saleEnd\" text,"
                                 "\"deliveryType\" integer,"
                                 "\"shopName\" text,"
                                 "\"distributorId\" text,"
                                 "PRIMARY KEY(\"itemUid\")"
                                 ");"];
        FMResultSet *rs = [self.db executeQuery:@"SELECT count(*) FROM "browseHistoryTable];
        [rs next];
        NSInteger c = [rs intForColumnIndex:0];
        if (c > 200)
        {
            [self.db executeUpdate:@"DELETE FROM "browseHistoryTable" WHERE \"time\" IN (SELECT \"time\" FROM "browseHistoryTable" ORDER BY \"time\" DESC LIMIT 200, -1)"];
        }
    }
    return self;
}

- (void)newHistoryItem:(MKItemObject *)item
{
    [self deleteItem:item];
    NSInteger t = [[NSDate date] timeIntervalSince1970];
    [self.db executeUpdate:@"INSERT INTO "browseHistoryTable
        " (\"time\", \"itemUid\", \"itemName\", \"supplierId\", \"categoryId\", \"itemType\", \"iconUrl\", \"descUrl\", \"marketPrice\", \"promotionPrice\", \"wirelessPrice\", \"saleBegin\", \"saleEnd\",\"deliveryType\",\"shopName\",\"distributorId\")"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,? ,? ,?)",
     @(t), item.itemUid, item.itemName, @(item.supplierId), @(item.categoryId), @(item.itemType), item.iconUrl, item.descUrl, @(item.marketPrice), @(item.promotionPrice), @(item.wirelessPrice), item.saleBegin, item.saleEnd,@(item.deliveryType),item.distributorInfo.shopName,item.distributorInfo.distributorId];
}

- (void)deleteItem:(MKItemObject *)item
{
    [self.db executeUpdate:@"DELETE FROM "browseHistoryTable" WHERE \"itemUid\"=?", item.itemUid];
}

- (NSArray *)lastItemFromIndex:(NSInteger)index count:(NSInteger)count
{
    NSDate *date = [NSDate date];
    NSInteger time = [date timeIntervalSince1970];
    NSInteger mowTime = time - 30*24*60*60;
    FMResultSet *res = [self.db executeQuery:@"SELECT * FROM "browseHistoryTable" where \"time\"> ? ORDER BY \"time\" DESC LIMIT ?, ?",@(mowTime), @(index), @(count)];
    NSMutableArray *ar = [NSMutableArray array];
    while ([res next])
    {
        MKHistoryItemObject *item = [[MKHistoryItemObject alloc] init];
        item.historyUpdateTime = [res unsignedLongLongIntForColumnIndex:0];
        item.itemUid = [res stringForColumnIndex:1];
        item.itemName = [res stringForColumnIndex:2];
        item.supplierId = [res longForColumnIndex:3];
        item.categoryId = [res longForColumnIndex:4];
        item.itemType = [res longForColumnIndex:5];
        item.iconUrl = [res stringForColumnIndex:6];
        item.descUrl = [res stringForColumnIndex:7];
        item.marketPrice = [res longForColumnIndex:8];
        item.promotionPrice = [res longForColumnIndex:9];
        item.wirelessPrice = [res longForColumnIndex:10];
        item.saleBegin = [res stringForColumnIndex:11];
        item.saleEnd = [res stringForColumnIndex:12];
        item.deliveryType = [res longForColumnIndex:13];
        item.shopName = [res stringForColumnIndex:14];
        item.distributorId = [res stringForColumnIndex:15];
        [ar addObject:item];
    }
    return [ar copy];
}

- (void)clear
{
    [self.db executeUpdate:@"DELETE FROM "browseHistoryTable];
}

@end
