//
//  MKPushKit.m
//  YangDongXi
//
//  Created by cocoa on 15/5/13.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKPushKit.h"
#import "APService.h"
#import "AppDelegate.h"
#import "MKUrlGuide.h"

@implementation MKPushKit

+ (void)setLogOFF
{
    [APService setLogOFF];
}

+ (void)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    else
    {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    [APService setupWithOption:launchOptions];
}

+ (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    NSInteger userId = getUserCenter.userInfo.userId;
    if (userId > 0)
    {
        [APService setAlias:[NSString stringWithFormat:@"%i", userId] callbackSelector:nil object:nil];
    }
}

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
}

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
                         fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([[MKUrlGuide commonGuide] canHandle:userInfo[@"URI"]])
    {
        [[MKUrlGuide commonGuide] guideForUrl:userInfo[@"URI"]];
    }
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
