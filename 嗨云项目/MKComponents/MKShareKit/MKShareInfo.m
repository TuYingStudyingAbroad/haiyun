//
//  MKShareInfo.m
//  MKBaseLib
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKShareInfo.h"

@implementation MKShareInfo

- (void)processUrl;
{
    NSDictionary *p = @{@(MKPlatformTypeSinaWeibo) : @"sinaweibo", @(MKPlatformTypeQQSpace) : @"qqspace",
                        @(MKPlatformTypeWeixiSession) : @"weixin", @(MKPlatformTypeWeixiTimeline) : @"pengyouquan",
                        @(MKPlatformTypeQQ) : @"qq"};
    NSString *param = p[@(self.type)];
    
    NSString *s = @"&";
    if ([self.url rangeOfString:@"?"].location == NSNotFound)
    {
        s = @"?";
    }
    self.url = [self.url stringByAppendingFormat:@"%@utm_medium=%@", s, param];
    
    if (self.type == MKPlatformTypeSinaWeibo && self.url.length > 0)
    {
        NSRange range = [self.content rangeOfString:@"http://"];
        if (range.location == NSNotFound)
        {
            range = [self.content rangeOfString:@"https://"];
        }
        if (range.location == NSNotFound)
        {
            self.content = [self.content stringByAppendingString:self.url];
        }
    }
}

@end
