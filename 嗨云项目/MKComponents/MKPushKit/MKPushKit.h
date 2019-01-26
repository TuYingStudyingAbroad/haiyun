//
//  MKPushKit.h
//  YangDongXi
//
//  Created by cocoa on 15/5/13.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKPushKit : NSObject

+ (void)setLogOFF;

+ (void)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
                         fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
