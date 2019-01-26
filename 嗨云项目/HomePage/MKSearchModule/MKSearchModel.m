//
//  MKSearchModel.m
//  YangDongXi
//
//  Created by cocoa on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKSearchModel.h"
#import <FMDB.h>

#define keywordHistoryTable @"keywordHistory"

#define maxNumber "20"

@interface MKSearchModel ()

@property (nonatomic) FMDatabase *db;

@end


@implementation MKSearchModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@".searchHistory"];
        self.db = [FMDatabase databaseWithPath:path];
        [self.db open];
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS "keywordHistoryTable" ("
                                 "\"time\" integer,"
                                 "\"keyword\" text,"
                                 "PRIMARY KEY(\"time\")"
                                 ");"];
        FMResultSet *rs = [self.db executeQuery:@"SELECT count(*) FROM "keywordHistoryTable];
        [rs next];
        NSInteger c = [rs intForColumnIndex:0];
        if (c > [@maxNumber integerValue])
        {
            [self.db executeUpdate:@"DELETE FROM "keywordHistoryTable" WHERE \"time\" IN (SELECT \"time\" FROM "keywordHistoryTable" ORDER BY \"time\" DESC LIMIT "maxNumber", -1)"];
        }
    }
    return self;
}

- (void)searchKeyword:(NSString *)keyword
{
    [self.db executeUpdate:@"DELETE FROM "keywordHistoryTable" WHERE \"keyword\"=?", keyword];
    NSArray *arrKey = [self lastTenKeyword];
    if ( arrKey.count >= 10 ) {
        [self.db executeUpdate:@"DELETE FROM "keywordHistoryTable" WHERE \"keyword\"=?", [arrKey lastObject]];
    }
    NSInteger t = [[NSDate date] timeIntervalSince1970];
    [self.db executeUpdate:@"INSERT INTO "keywordHistoryTable" (\"time\", \"keyword\") VALUES (?, ?)", @(t), keyword];
}

- (BOOL)delOneKeyword:(NSString *)keyword
{
   return  [self.db executeUpdate:@"DELETE FROM "keywordHistoryTable" WHERE \"keyword\"=?", keyword];
}
- (NSArray *)lastTenKeyword
{
    FMResultSet *res = [self.db executeQuery:@"SELECT * FROM "keywordHistoryTable" ORDER BY \"time\" DESC LIMIT 0, "maxNumber""];
    NSMutableArray *ar = [NSMutableArray array];
    while ([res next])
    {
        [ar addObject:[res stringForColumnIndex:1]];
    }
    return [ar copy];
}

- (void)clear
{
    [self.db executeUpdate:@"DELETE FROM "keywordHistoryTable];
}

@end
