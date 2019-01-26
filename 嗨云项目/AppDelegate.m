//
//  AppDelegate.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/5.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "AppDelegate.h"
#import "MKAppConfig.h"
#import "UIColor+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "HYSystemInit.h"
#import "HYMainViewController.h"
#import "HYThreeDealMsg.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
     [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024 diskCapacity:32*1024*1024 diskPath:nil]];
    //所有第三方的处理
    [HYThreeDealMsg sharedInstance];
    [HYThreeDealMsg registerApp:launchOptions];
    
    
    self.appConfig = [[MKAppConfig alloc] init];
    self.userCenter = [[MKUserCenter alloc] init];
    [self updateUserAgent];
    
    [MKNetworking setBaseUrl:BaseUrl];//域名

    [MKNetworking registerPlatforms];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainTabBarViewController = [MainTabBarViewController sharedInstance];
    
    //初始化界面的更改
    [HYSystemInit sharedInstance].window = self.window;
    HYMainViewController *InitVC = [[HYMainViewController alloc] init];
    HYNavigationController * navigationController = [[HYNavigationController alloc] initWithRootViewController:InitVC];
    navigationController.navigationBar.hidden = YES;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)updateUserAgent
{
    //修改UIWebView的UserAgent
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(1, 1, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *ua = [NSString stringWithFormat:@"%@ Mockuai/%@ %@/%@ ServerVersion/%@", userAgent, [self.appConfig getAppVersion], @"mockuai",[self.appConfig getAppVersion],MockuaiVersionCode];
    NSDictionary *infoAgentDic = [NSDictionary dictionaryWithObjectsAndKeys:ua, @"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:infoAgentDic];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [HYThreeDealMsg handleOpenURL:url];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [HYThreeDealMsg application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [HYThreeDealMsg application:application OnDealNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [HYThreeDealMsg applicationDidReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [HYThreeDealMsg handleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [HYThreeDealMsg handleOpenURL:url];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [HYThreeDealMsg setNumberBadge];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
