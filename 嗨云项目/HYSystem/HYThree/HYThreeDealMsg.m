//
//  HYThreeDealMsg.m
//  嗨云项目
//
//  Created by YanLu on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

//微信
#define kWXAppKey         @"wx39117121178ae4dc"
#define kWXAppSecret      @"821caa30240ab0f71b5d51005f3d9abb"

//百度SDK
#define kBaiduKey               @"00b6a42dae"
#define kBaiduChannelId         @"appstore"  //appstore

//网易七鱼
#define WYQYAppKey       @"2f0a6f437d07248148147584907bbada"

#import "HYThreeDealMsg.h"
#import "IQKeyboardManager.h"
#import "MKPushKit.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "MKPayKit+BusinessExtension.h"
#import "BaiduMobStat.h"
#import "HYShareKit.h"
#import "QYSDK.h"
#import <MessageUI/MessageUI.h>
#import "HYNavigationController.h"
#import "HYQYPushKit.h"
#import "AppDelegate.h"

HYThreeDealMsg    *g_HYThreeDealMsg = NULL;

@interface HYThreeDealMsg()<WXApiDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation HYThreeDealMsg

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_HYThreeDealMsg = [[[self class] alloc] init];
    });
    return g_HYThreeDealMsg;
}

+(void)registerApp:(NSDictionary *)launchOptions//第三方注册
{
    //IQKeyboardManager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
     //*************************百度统计******************
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.shortAppVersion  = IosAppVersion;
    statTracker.enableDebugOn = NO;
    statTracker.channelId = kBaiduChannelId;
    [statTracker startWithAppId:kBaiduKey]; //
    
    
    //*************************shareSDK******************
    [HYShareKit registerShareApp];
    
    //*************************微信******************
    [WXApi registerApp:kWXAppKey withDescription:kWXAppSecret];
    
    //*************************支付******************
    [MKPayKit registerPlatforms];
    //*************************JPush******************
    [MKPushKit sharedInstance];
    [MKPushKit applicationDidFinishLaunchingWithOptions:launchOptions];
    [MKPushKit setLogOFF];
    
    //*************************客服******************
     [[QYSDK sharedSDK] registerAppId:WYQYAppKey appName:@"嗨云"];
    [HYQYPushKit applicationDidFinishLaunchingWithOptions:launchOptions];
}

+(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
    [HYQYPushKit applicationDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [MKPushKit applicationDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
}

+ (void)application:(UIApplication *)application OnDealNotification:(NSDictionary *)userInfo
{
    
    [MKPushKit applicationDidReceiveRemoteNotification:userInfo];
}

+ (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
                         fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [MKPushKit applicationDidReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
+(BOOL)handleOpenURL:(NSURL *)url//URL 处理
{
    BOOL bReturn = NO;
    if ( [MKPayKit applicationOpenURL:url] && [url.absoluteString hasPrefix:[kWXAppKey stringByAppendingString:@"://pay/"]] )
    {
        bReturn = YES;
    }
    else if ( [WXApi handleOpenURL:url delegate:g_HYThreeDealMsg] )
    {
        bReturn = YES;
    }
    return bReturn;
}

+(void)setNumberBadge
{
    [MKPushKit setNumberBadge];
}

+(BOOL)WXLoginIsHide
{
    return !([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]);
}

#pragma mark -第三方登录
-(void)LoginPayType:(NSInteger)nLoginType Result:(threeLoginResult)resultLgoin
{
    
    switch (nLoginType)
    {
        case 0:
        {
            if ( [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi] )
            {
                g_HYThreeDealMsg.reqLoginResult = resultLgoin;
                SendAuthReq* req = NewObject(SendAuthReq);
                req.scope = @"snsapi_userinfo" ;
                req.state = @"hiyun";
                req.openID = kWXAppKey;
                [WXApi sendReq:req];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark-WXApiDelegate
-(void)onResp:(BaseReq*)resp
{
    SendAuthResp *wxResp = (SendAuthResp *)resp;
    if ( [wxResp isKindOfClass:[SendAuthResp class]] )//登录
    {
        switch (wxResp.errCode)
        {
            case WXSuccess:
            {
                SendAuthResp *aresp = (SendAuthResp *)resp;
                if ( self.reqLoginResult  )
                {
                    self.reqLoginResult(aresp.code);
                }
                break;
            }
            default:
            {
                [MBProgressHUD showMessageIsWait:@"授权失败" wait:YES];
            }
                break;
        }
    }
}

#pragma mark -短信分享
-(void)shareInfoWithMessage:(NSString *)mesage type:(NSInteger )types
{
    if ( types == 8 )
    {
        if( [MFMessageComposeViewController canSendText] )
        {
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
            controller.body = mesage;
            controller.messageComposeDelegate = g_HYThreeDealMsg;
            [getMainTabBar.selectedNav presentViewController:controller animated:NO completion:nil];
        }else
        {
            [MBProgressHUD showMessageIsWait:@"该设备不支持短信功能" wait:YES];
        }
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [getMainTabBar.selectedNav dismissViewControllerAnimated:NO completion:nil];
    switch (result)
    {
        case MessageComposeResultSent:
            //信息传送成功
            [MBProgressHUD showMessageIsWait:@"分享成功！" wait:YES];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [MBProgressHUD showMessageIsWait:@"分享失败！" wait:YES];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [MBProgressHUD showMessageIsWait:@"用户取消！" wait:YES];
            break;
        default:
            break;
    }
}
@end
