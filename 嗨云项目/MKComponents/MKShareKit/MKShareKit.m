//
//  MKShareKit.m
//  YangDongXi
//
//  Created by cocoa on 15/5/7.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKShareKit.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <SDWebImage/SDImageCache.h>


@implementation MKShareKit

+ (void)registerPlatforms
{
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MKAppConfig"
                                                                                                 ofType:@"plist"]];
    NSString *appKey = [d[@"ShareSDK"][@"appKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([appKey length] == 0)
    {
        return;
    }
    [ShareSDK registerApp:appKey];
    
    appKey = [d[@"SinaWeibo"][@"appKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *appSecret = [d[@"SinaWeibo"][@"appSecret"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *redirectUri = [d[@"SinaWeibo"][@"redirectUri"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([appKey length] > 0 && [appSecret length] > 0 && [redirectUri length] > 0)
    {
        [ShareSDK connectSinaWeiboWithAppKey:appKey
                                   appSecret:appSecret
                                 redirectUri:redirectUri];
    }
    
    appKey = [d[@"QZone"][@"appKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    appSecret = [d[@"QZone"][@"appSecret"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([appKey length] > 0 && [appSecret length] > 0 && [redirectUri length] > 0)
    {
        [ShareSDK connectQZoneWithAppKey:appKey
                               appSecret:appSecret
                       qqApiInterfaceCls:[QQApiInterface class]
                         tencentOAuthCls:[TencentOAuth class]];
        
        [ShareSDK connectQQWithQZoneAppKey:appKey
                         qqApiInterfaceCls:[QQApiInterface class]
                           tencentOAuthCls:[TencentOAuth class]];
    }
    
    appKey = [d[@"WeChat"][@"appKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    appSecret = [d[@"WeChat"][@"appSecret"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([appKey length] > 0 && [appSecret length] > 0)
    {
        [ShareSDK connectWeChatWithAppId:appKey
                               appSecret:appSecret
                               wechatCls:[WXApi class]];
    }
    [ShareSDK connectSMS];
}

+ (void)authenticateWithThirdParty:(MKPlatformType)type
                          complete:(void (^)(NSString *token, NSString *openId, NSString *msg))completion
{
    ShareType st = (ShareType)type;
    [ShareSDK cancelAuthWithType:st];
    [ShareSDK getUserInfoWithType:st authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
    {
        if (result)
        {
            NSString *token = [[userInfo credential] token];
            NSString *openId = [[userInfo credential] uid];
            completion(token, openId, nil);
        }
        else
        {
            completion(nil, nil, @"授权失败");
        }
    }];
}

+ (BOOL)applicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}

+ (void)shareWithInfo:(MKShareInfo *)shareInfo completion:(void (^)(NSString *errorMsg))completion
{
    NSSet *typeSet = [NSSet setWithArray:@[@(MKPlatformTypeSinaWeibo), @(MKPlatformTypeQQSpace), @(MKPlatformTypeWeixiSession), @(MKPlatformTypeWeixiSession),
                                           @(MKPlatformTypeWeixiTimeline), @(MKPlatformTypeQQ), @(MKPlatformTypeSMS)]];
    if (![typeSet containsObject:@(shareInfo.type)])
    {
        [self completion:completion withErrorMsg:@"不支持这种分享方式"];
        return;
    }
    
    id<ISSCAttachment> images;
    if (shareInfo.image.length > 0)
    {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:shareInfo.image];
        if (image != nil)
        {
            images = [ShareSDK jpegImageWithImage:image quality:0.8];
        }

    }
    id<ISSContent> publishContent = [ShareSDK content:shareInfo.content
                                       defaultContent:@""
                                                image:images
                                                title:shareInfo.title
                                                  url:shareInfo.url
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    ShareType type = (ShareType)shareInfo.type;
    SSPublishContentEventHandler resultHandler = ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
    {
        if (end)
        {
            if ((state == SSPublishContentStateSuccess) && ([error errorCode] == 0))
            {
                [self completion:completion withErrorMsg:nil];
            }
            else
            {
                [self completion:completion withErrorMsg:@"分享失败"];
            }
        }
    };
    if (type == ShareTypeSinaWeibo || type == ShareTypeSMS)
    {
        [publishContent setContent:[NSString stringWithFormat:@"%@%@", shareInfo.content, shareInfo.url]];
    }
    
    if (type == ShareTypeSMS)
    {
        [ShareSDK clientShareContent:publishContent type:ShareTypeSMS
                         authOptions:nil shareOptions:nil statusBarTips:YES result:resultHandler];
        return;
    }
    
    [ShareSDK shareContent:publishContent type:type authOptions:nil shareOptions:nil statusBarTips:NO
                    result:resultHandler];
}

+ (void)completion:(void (^)(NSString *errorMsg))completion withErrorMsg:(NSString *)errorMsg
{
    if (completion != nil)
    {
        completion(errorMsg);
    }
}

@end
