//
//  HYThreeDealMsg.h
//  嗨云项目
//
//  Created by YanLu on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^threeLoginResult)(NSString *bResultStr);

@interface HYThreeDealMsg : NSObject



+ (instancetype)sharedInstance;

@property (nonatomic,strong)threeLoginResult reqLoginResult;

/**
 *  第三方注册
 *
 *  @param launchOptions launchOptions
 */
+(void)registerApp:(NSDictionary *)launchOptions;//第三方注册
+(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+(BOOL)handleOpenURL:(NSURL *)url;//URL 第三方调用URL处理
+(void)application:(UIApplication *)application OnDealNotification:(NSDictionary *)userInfo;
+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
                         fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

+(void)setNumberBadge;
/**
 *  微信登录是否隐藏 YES 隐藏， NO bu
 */
+(BOOL)WXLoginIsHide;

#pragma mark -第三方登录
-(void)LoginPayType:(NSInteger)nLoginType Result:(threeLoginResult)resultLgoin;

/**
 *  短信分享
 *
 *  @param mesage 内容
 *  @param types  8短信分享
 */
-(void)shareInfoWithMessage:(NSString *)mesage type:(NSInteger )types;
@end
