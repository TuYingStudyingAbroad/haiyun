//
//  MKPayKit.m
//  MKBaseLib
//
//  Created by cocoa on 15/3/27.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKPayKit.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "LLPayUtil.h"
#import "LLPaySdk.h"

typedef void(^PayCompleteBlock)(MKPayResult result);

static NSString *weChatScheme = nil;
static NSString *alipayScheme = nil;

static PayCompleteBlock alipayBlock = nil;
static PayCompleteBlock weChatPayBlock = nil;
static PayCompleteBlock upPayBlock = nil;
static PayCompleteBlock llPayBlock = nil;

static BOOL upPayTestModel = NO;


@interface MKPayKit () <UPPayPluginDelegate, WXApiDelegate,LLPaySdkDelegate>

@end


@implementation MKPayKit

+ (MKPayKit *)defaultInstance
{
    static MKPayKit *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      instance = [[self alloc] init];
                  });
    return instance;
}

+ (BOOL)applicationOpenURL:(NSURL *)url
{
    NSString *urlStr = url.absoluteString;
    
    if ([urlStr hasPrefix:[weChatScheme stringByAppendingString:@"://pay/"]])
    {
        return [WXApi handleOpenURL:url delegate:[MKPayKit defaultInstance]];
    }
    if ([urlStr hasPrefix:alipayScheme])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic)
        {
            [self dealWithAliapyResult:resultDic];
        }];
        return YES;
    }
    return NO;
}

#pragma mark - 支付宝
+ (void)updateAlipayScheme:(NSString *)scheme
{
    alipayScheme = scheme;
}

+ (void)alipayWithInfo:(NSString *)info complete:(PayCompleteBlock)complete
{
    NSAssert(alipayScheme != nil, @"没有设置支付宝scheme");
    alipayBlock = complete;
    [[AlipaySDK defaultService] payOrder:info fromScheme:alipayScheme callback:^(NSDictionary *resultDic)
     {
         [self dealWithAliapyResult:resultDic];
     }];
}

+ (void)dealWithAliapyResult:(NSDictionary *)resultDic
{
    MKPayResult res = MKPayResultFailed;
    if ([resultDic[@"resultStatus"] integerValue] == 9000)
    {
        res = MKPayResultSuccess;
    }
    else if ([resultDic[@"resultStatus"] integerValue] == 6001)
    {
        res = MKPayResultCancelled;
    }
    
    if (alipayBlock != nil)
    {
        alipayBlock(res);
    }
}

#pragma mark - 微信
+ (void)updateWeChatScheme:(NSString *)scheme
{
    weChatScheme = scheme;
}

+ (void)weChatPayWithReq:(PayReq *)req complete:(PayCompleteBlock)complete
{
    NSAssert(weChatScheme != nil, @"没有设置微信scheme");
    weChatPayBlock = complete;
    [WXApi sendReq:req];
}

- (void)onReq:(BaseReq *)req
{
    
}

- (void)onResp:(BaseResp *)resp
{
    MKPayResult res = MKPayResultFailed;
    if ([resp isKindOfClass:[PayResp class]])
    {
        switch (resp.errCode)
        {
            case WXSuccess:
                res = MKPayResultSuccess;
                break;
            case WXErrCodeUserCancel:
                res = MKPayResultCancelled;
                break;
            default:
                res = MKPayResultFailed;
                break;
        }
    }
    if (weChatPayBlock != nil)
    {
        weChatPayBlock(res);
    }
}

#pragma mark - 银联
/**
 @brief 启动银联测试模式
 */
+ (void)upPayTestMode
{
    upPayTestModel = YES;
}

+ (void)upPayWithTn:(NSString *)tn withController:(UIViewController *)vc complete:(PayCompleteBlock)complete
{
    upPayBlock = complete;
    [UPPayPlugin startPay:tn mode:upPayTestModel ? @"01" : @"00"
           viewController:vc delegate:[MKPayKit defaultInstance]];
}

- (void)UPPayPluginResult:(NSString *)result
{
    MKPayResult res = MKPayResultFailed;
    if ([result isEqualToString:@"success"])
    {
        res = MKPayResultSuccess;
    }
    else if ([result isEqualToString:@"cancel"])
    {
        res = MKPayResultCancelled;
    }
    else
    {
        res = MKPayResultFailed;
    }
    if (upPayBlock != nil)
    {
        upPayBlock(res);
        upPayBlock = nil;
    }
}

#pragma mark -连连


+ (void)upPayWithLL:(NSDictionary *)payDic withController:(UIViewController *)vc complete:(void(^)(MKPayResult result))complete
{
    
    llPayBlock = complete;

    LLPayUtil *payUtil = [[LLPayUtil alloc] init];
    
    // 进行签名
    NSDictionary *signedOrder = [payUtil signedOrderDic:payDic
                                             andSignKey:[payDic HYValueForKey:@"private_key"]];
    
    [LLPaySdk sharedSdk].sdkDelegate = [MKPayKit defaultInstance];
    
    //接入什么产品就传什么LLPayType
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:vc withPayType:LLPayTypeQuick andTraderInfo:signedOrder];
}

#pragma -mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    MKPayResult res = MKPayResultFailed;
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                res = MKPayResultSuccess;
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                msg = @"支付单处理中";
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                msg = @"支付单失败";
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail:
        {
            msg = @"支付失败";
        }
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
            res = MKPayResultCancelled;
        }
            break;
        case kLLPayResultInitError:
        {
            msg = @"sdk初始化异常";
        }
            break;
        case kLLPayResultInitParamError:
        {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    
//    NSString *showMsg = [msg stringByAppendingString:[LLPayUtil jsonStringOfObj:dic]];
    if (llPayBlock != nil)
    {
        llPayBlock(res);
        llPayBlock = nil;
    }

    
   
}

@end
