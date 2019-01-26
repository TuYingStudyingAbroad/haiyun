//
//  MKUrlGuideItem.m
//  YangDongXi
//
//  Created by cocoa on 15/1/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKUrlGuideItem.h"
#import "MKUrlGuideParamItem.h"

@implementation MKUrlGuideItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (self)
    {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            [self setValue:obj forKey:key];
        }];
        NSArray *params = self.params;
        NSMutableArray *paramItems = [NSMutableArray arrayWithCapacity:params.count];
        for (NSDictionary *dic in params)
        {
            MKUrlGuideParamItem *item = [[MKUrlGuideParamItem alloc] initWithDictionary:dic];
            [paramItems addObject:item];
        }
        self.params = [paramItems copy];
    }
    return self;
}

@end
