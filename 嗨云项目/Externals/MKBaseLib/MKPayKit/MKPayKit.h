//
//  MKPayKit.h
//  MKBaseLib
//
//  Created by cocoa on 15/3/27.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@class PayReq;

typedef enum : NSUInteger
{
    MKPayTypeAlipay = 1,
    MKPayTypeWeChat = 2,
    MKPayTypeUPPay = 3,
} MKPayType;

typedef enum : NSUInteger
{
    MKPayResultSuccess = 1,
    MKPayResultFailed = 2,
    MKPayResultCancelled = 3,
} MKPayResult;

@interface MKPayKit : NSObject

+ (void)updateAlipayScheme:(NSString *)scheme;

+ (void)alipayWithInfo:(NSString *)info complete:(void(^)(MKPayResult result))complete;

+ (void)updateWeChatScheme:(NSString *)scheme;

+ (void)weChatPayWithReq:(PayReq *)req complete:(void(^)(MKPayResult result))complete;

+ (BOOL)applicationOpenURL:(NSURL *)url;

/**
 @brief 启动银联测试模式
 */
+ (void)upPayTestMode;

+ (void)upPayWithTn:(NSString *)tn withController:(UIViewController *)vc
           complete:(void(^)(MKPayResult result))complete;

+ (void)upPayWithLL:(NSDictionary *)payDic withController:(UIViewController *)vc complete:(void(^)(MKPayResult result))complete;

@end
