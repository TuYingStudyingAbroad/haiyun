//
//  MKPushKit.m
//  YangDongXi
//
//  Created by cocoa on 15/5/13.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

static NSString *appKey = @"18f54cea2f9ff2cc9570d285";
static NSString *channel = @"Publish channel";
#ifdef DEBUG // 开发
static BOOL const isProduction = FALSE; // 极光FALSE为开发环境
#else // 生产
static BOOL const isProduction = TRUE; // 极光TRUE为生产环境
#endif

#import "MKPushKit.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
#import "MKUrlGuide.h"
#import "QYSDK.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h> // 这里是iOS10需要用到的框架
#endif

MKPushKit    *g_MKPushKitMsg = NULL;
@interface MKPushKit() <JPUSHRegisterDelegate>

@end

@implementation MKPushKit

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_MKPushKitMsg = [[[self class] alloc] init];
    });
    return g_MKPushKitMsg;
}

+ (void)setLogOFF
{
    [JPUSHService setLogOFF];
}

+ (void)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:g_MKPushKitMsg];
#endif
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    else
    {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction];
}

+ (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
     
    [JPUSHService registerDeviceToken:deviceToken];
    NSInteger userId = getUserCenter.userInfo.userId;
    if (userId > 0)
    {
        [JPUSHService setAlias:[NSString stringWithFormat:@"%li", (long)userId] callbackSelector:nil object:nil];
    }
}

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
                         fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([[MKUrlGuide commonGuide] canHandle:userInfo[@"URL"]])
    {
        [[MKUrlGuide commonGuide] guideForUrl:userInfo[@"URL"]];
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif


#pragma mark -设置推送点数

+(void)setNumberBadge
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}

@end
