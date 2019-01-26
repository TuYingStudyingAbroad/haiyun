//
//  MKRegionItem.m
//  YangDongXi
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKRegionItem.h"

@implementation MKRegionItem

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.code forKey:@"code"];
    
    [aCoder encodeObject:self.pcode forKey:@"pcode"];
    
    [aCoder encodeObject:self.name forKey:@"name"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.code = [aDecoder decodeObjectForKey:@"code"];
        
        self.pcode = [aDecoder decodeObjectForKey:@"pcode"];
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
