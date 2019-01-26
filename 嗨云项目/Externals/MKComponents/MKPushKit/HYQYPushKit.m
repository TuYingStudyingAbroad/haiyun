//
//  HYQYPushKit.m
//  嗨云项目
//
//  Created by 唯我独尊 on 16/9/8.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYQYPushKit.h"
#import "QYSDK.h"
#import "AppDelegate.h"

@implementation HYQYPushKit



+ (void)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    
    //传入正确的App名称
    [[QYSDK sharedSDK] registerAppId:@"2f0a6f437d07248148147584907bbada" appName:@"嗨云"];
    
    //注册 APNS
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge
        | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert
        | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    

}


+ (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
     [[QYSDK sharedSDK] updateApnsToken:deviceToken];
    
}

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
                         fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    
}


@end
