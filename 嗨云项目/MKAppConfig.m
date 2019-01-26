//
//  MKAppConfig.m
//  YangDongXi
//
//  Created by cocoa on 15/4/14.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//   779988

#import "MKAppConfig.h"

@implementation MKAppConfig

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSUInteger launchTimes = [self launchTimesThisVersion];
        [[NSUserDefaults standardUserDefaults] setObject:@(launchTimes + 1) forKey:[self getLaunchTimesThisVersionKey]];
        
    }
    return self;
}

- (NSUInteger)launchTimesThisVersion
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[self getLaunchTimesThisVersionKey]] unsignedIntegerValue];
}

- (NSString *)getLaunchTimesThisVersionKey
{
    return [NSString stringWithFormat:@"launchTimeCountAt%@", [self getAppVersion]];
}

@end
