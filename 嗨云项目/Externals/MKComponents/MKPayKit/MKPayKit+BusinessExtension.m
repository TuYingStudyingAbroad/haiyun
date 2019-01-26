//
//  MKPayKit+BusinessExtension.m
//  YangDongXi
//
//  Created by cocoa on 15/5/13.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKPayKit+BusinessExtension.h"

@implementation MKPayKit (BusinessExtension)

+ (void)registerPlatforms
{
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MKAppConfig" ofType:@"plist"]];

    NSString *appKey = [d[@"Alipay"][@"appKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([appKey length] > 0)
    {
        [MKPayKit updateAlipayScheme:[@"alipay" stringByAppendingString:appKey]];
    }
    
    appKey = [d[@"WeChat"][@"appKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( [appKey length] > 0 )
    {
        [MKPayKit updateWeChatScheme:appKey];
    }
}

@end
