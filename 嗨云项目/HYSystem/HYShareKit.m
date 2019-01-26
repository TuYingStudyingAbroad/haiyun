//
//  HYShareKit.m
//  shareSDKDemo
//
//  Created by haiyun on 16/6/5.
//  Copyright © 2016年 haiyun. All rights reserved.
//

//qq
#define kQQAppKey         @"1105363855"
#define kQQAppSecret      @"EjvfinGZKR4GDOLk"

//微信
#define kWXAppKey         @"wx39117121178ae4dc"
#define kWXAppSecret      @"821caa30240ab0f71b5d51005f3d9abb"

//新浪微博
#define kSinaWeiboAppKey            @"2836735600"
#define kSinaWeiboSecret            @"e935d9e58e9f6d939d2ae0e87967ada3"

#define kShareSDKKey                @"1353e7c24bc65"

#import "HYShareKit.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import "HYShareInfo.h"
#import <MessageUI/MessageUI.h>


@interface HYShareKit ()

@end

@implementation HYShareKit

+(void)registerShareApp
{
    [ShareSDK registerApp:kShareSDKKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:kSinaWeiboAppKey
                                           appSecret:kSinaWeiboSecret
                                         redirectUri:@"http://www.sina.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:kWXAppKey
                                       appSecret:kWXAppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:kQQAppKey
                                      appKey:kQQAppSecret
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}
+ (BOOL)handleOpenURL:(NSURL *)url
{
    BOOL rReturn = NO;
    
    return rReturn;
}

+ (void)shareImageWeChat:(HYShareInfo *)shareInfo completion:(void (^)(NSString *errorMsg))completion
{
    if ( ![WXApi isWXAppInstalled] )
    {
        [self completion:completion withErrorMsg:@"您尚未安装微信客户端"];
        return;
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (  shareInfo.images == nil )
    {
        [self completion:completion withErrorMsg:@"分享失败！"];
        return;
    }
    
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupWeChatParamsByText:shareInfo.content
                                       title:shareInfo.title
                                         url:nil
                                  thumbImage:[UIImage imageWithImage:shareInfo.images scaledToSize:CGSizeMake(120, 120)]
                                       image:shareInfo.images
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeImage
                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//    NSLog(@"shareParams == %@",shareParams);

    [ShareSDK share:SSDKPlatformSubTypeWechatSession
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             [self completion:completion withErrorMsg:@"分享成功！"];
         }
         else if ( state == SSDKResponseStateFail )
         {
             [self completion:completion withErrorMsg:@"分享失败！"];
         }
         else
         {
             [self completion:completion withErrorMsg:@"分享成功！"];
             
         }
    }];
    
    
}

+ (void)shareInfoWith:(HYShareInfo *)shareInfo completion:(void (^)(NSString *errorMsg))completion
{
    
    if ( shareInfo.type == HYPlatformTypeWeixiSession
        || shareInfo.type == HYPlatformTypeWeixiTimeline )
    {
        if ( ![WXApi isWXAppInstalled] )
        {
            [self completion:completion withErrorMsg:@"您尚未安装微信客户端"];
            return;
        }
    }
    else if ( shareInfo.type == HYPlatformTypeQQSpace
             || shareInfo.type == HYPlatformTypeQQ )
    {
        if ( ![QQApiInterface isQQInstalled])
        {
            [self completion:completion withErrorMsg:@"您尚未安装QQ客户端"];
            return;
        }
    }
    else if ( shareInfo.type == HYPlatformTypeSinaWeibo )
    {
        if ( ![WeiboSDK isWeiboAppInstalled] )
        {
            [self completion:completion withErrorMsg:@"您尚未安装新浪微博客户端"];
            return;
        }
    }
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSMutableArray *images = [NSMutableArray array];
    if ( shareInfo.shareType == HYShareDKContentTypeImage )
    {
        if ( shareInfo.images )
        {
            [images addObject:shareInfo.images];
        }
        else if ( ISNSStringValid(shareInfo.image)  )
        {
            [images addObject:shareInfo.image];
        }
        else
        {
             [self completion:completion withErrorMsg:@"分享失败！"];
             return;
        }
    }else
    {
        if ( shareInfo.images )
        {
            [images addObject:shareInfo.images];
        }
        else if ( ISNSStringValid(shareInfo.image)  )
        {
            [images addObject:shareInfo.image];
        }
        else
        {
            [images addObject:[UIImage imageNamed:@"HYShare"]];
        }
    }

    if ( !ISNSStringValid(shareInfo.title) )
    {
        shareInfo.title = @"嗨云";
    }
//    NSLog(@"%@===%@ == %@ == %@ == %@ ",shareInfo.images,shareInfo.images,shareInfo.title,shareInfo.content,shareInfo.url);
//    NSLog(@"===%@",images);
    if ( shareInfo.type == HYPlatformTypeSinaWeibo )
    {
        shareInfo.content = [NSString stringWithFormat:@"%@%@%@",ISNSStringValid(shareInfo.title)?shareInfo.title:@"",ISNSStringValid(shareInfo.content)?shareInfo.content:@"",shareInfo.url];
        shareInfo.shareType = HYShareDKContentTypeAuto;
        if ( ISNSStringValid(shareInfo.image) ) {
            [images removeAllObjects];
            [images addObject:shareInfo.image];
        }
    }
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupShareParamsByText:shareInfo.content
                                     images:images //传入要分享的图片
                                        url:[NSURL URLWithString:shareInfo.url]
                                      title:shareInfo.title
                                       type:[self HYShareDKContentType:shareInfo.shareType]];
//    NSLog(@"shareParams == %@",shareParams);
    [ShareSDK share:[self sharePlatformType:shareInfo.type]
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
    {
        if (state == SSDKResponseStateSuccess)
        {
             [self completion:completion withErrorMsg:@"分享成功！"];
        }
        else if ( state == SSDKResponseStateFail )
        {
             [self completion:completion withErrorMsg:@"分享失败！"];
        }
        else
        {
            [self completion:completion withErrorMsg:@""];

        }
    }];
    
}




+ (void)completion:(void (^)(NSString *errorMsg))completion withErrorMsg:(NSString *)errorMsg
{
    if (completion != nil)
    {
        completion(errorMsg);
    }
}

//HYPlatformTypeSinaWeibo = 2,          /**< 新浪微博 */
//HYPlatformTypeQQSpace = 3,            /**< QQ空间 */
//HYPlatformTypeWeixiSession = 0,      /**< 微信好友 */
//HYPlatformTypeWeixiTimeline = 1,     /**< 微信朋友圈 */
//HYPlatformTypeQQ = 5,                /**< QQ */
//HYPlatformTypeAny = 99                /**< 任意平台 */
+(SSDKPlatformType)sharePlatformType:(HYPlatformType)HYType
{
    SSDKPlatformType  shareType = SSDKPlatformTypeAny;
    switch (HYType) {
        case HYPlatformTypeQQ:
            shareType = SSDKPlatformSubTypeQQFriend;
            break;
        case HYPlatformTypeQQSpace:
            shareType = SSDKPlatformSubTypeQZone;
            break;
        case HYPlatformTypeSinaWeibo:
            shareType = SSDKPlatformTypeSinaWeibo;
            break;
        case HYPlatformTypeWeixiSession:
            shareType = SSDKPlatformSubTypeWechatSession;
            break;
        case HYPlatformTypeWeixiTimeline:
            shareType = SSDKPlatformSubTypeWechatTimeline;
        default:
            break;
    }
    
    return shareType;
}
/**
 *  分享内容方式
 *
 *  @param HYType 方式
 *
 *  @return 方式
 */
+(SSDKContentType)HYShareDKContentType:(HYShareDKContentType)HYType
{
    SSDKContentType  shareType = SSDKContentTypeAuto;
    switch (HYType)
    {
        case HYShareDKContentTypeAuto:
            shareType = SSDKContentTypeAuto;
            break;
        case HYShareDKContentTypeText:
            shareType = SSDKContentTypeText;
            break;
        case HYShareDKContentTypeImage:
            shareType = SSDKContentTypeImage;
            break;
        case HYShareDKContentTypeWebPage:
            shareType = SSDKContentTypeWebPage;
            break;
        default:
            break;
    }
    
    return shareType;
}

@end
