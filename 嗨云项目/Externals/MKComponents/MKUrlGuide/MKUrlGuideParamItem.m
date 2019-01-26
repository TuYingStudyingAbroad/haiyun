//
//  MKUrlGuideParamItem.m
//  YangDongXi
//
//  Created by cocoa on 15/1/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKUrlGuideParamItem.h"

@implementation MKUrlGuideParamItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            [self setValue:obj forKey:key];
        }];
        if (self.classParamName.length == 0)
        {
            self.classParamName = self.urlParamName;
        }
    }
    return self;
}

@end
