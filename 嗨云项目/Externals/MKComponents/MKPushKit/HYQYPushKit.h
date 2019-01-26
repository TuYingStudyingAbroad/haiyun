//
//  HYQYPushKit.h
//  嗨云项目
//
//  Created by 唯我独尊 on 16/9/8.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYQYPushKit : NSObject


+ (void)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
                         fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;


@end
