//
//  MKShareInfo.h
//  MKBaseLib
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <MKBaseLib/MKBaseObject.h>

typedef enum
{
    MKPlatformTypeSinaWeibo = 1,          /**< 新浪微博 */
    MKPlatformTypeQQSpace = 6,            /**< QQ空间 */
    MKPlatformTypeSMS = 19,
    MKPlatformTypeWeixiSession = 22,      /**< 微信好友 */
    MKPlatformTypeWeixiTimeline = 23,     /**< 微信朋友圈 */
    MKPlatformTypeQQ = 24,                /**< QQ */
    MKPlatformTypeAny = 99                /**< 任意平台 */
}
MKPlatformType;

@interface MKShareInfo : MKBaseObject

/** @brief 分享方式 */
@property (nonatomic, assign) MKPlatformType type;

/**
 @brief 分享的链接
 @discussion QQ、QQ空间、微信需要。(新浪微博可以使用processUrl方法拼接到content中)
 */
@property (nonatomic,copy) NSString *url;

/**
 @brief 分享的内容
 @discussion 都要
 */
@property (nonatomic,copy) NSString *content;

/**
 @brief 需要分享的标题
 @discussion QQ、QQ空间、微信需要。
 */
@property (nonatomic,copy) NSString *title;

/**
 @brief 需要分享的图片地址 
 @discussion 都可以用，可以为空
 */
@property (nonatomic,copy) NSString *image;

/**
 @brief 给url增加utm_medium参数，表明是哪个渠道来的。
        同时由于新浪微博不支持url，所以会将url拼到content中(如果content本身有url就不会拼了)。
 @discussion
        对应utm_medium参数值：
        @(MKThirdPartySinaWeibo) : @"sinaweibo", 
        @(MKThirdPartyQQSpace) : @"qqspace",
        @(MKThirdPartyWeixiSession) : @"weixin", 
        @(MKThirdPartyWeixiTimeline) : @"pengyouquan",
        @(MKThirdPartyQQ) : @"qq"};
 */
- (void)processUrl;

@end
