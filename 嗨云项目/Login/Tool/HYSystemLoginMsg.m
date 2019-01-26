//
//  HYSystemLoginMsg.m
//  嗨云项目
//
//  Created by YanLu on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//



#import "HYSystemLoginMsg.h"
#import "HYSystemInit.h"
#import "HYRegisterViewController.h"
#import "YLPersionNewsViewController.h"
#import "AppDelegate.h"
#import "MKNetworking+BusinessExtension.h"
#import "HYContactViewController.h"
#import "YLLoginMainViewController.h"

@implementation HYSystemLoginMsg

+(void)OnDealMes:(NSInteger)nMsgType wParam:(id)wParam animated:(BOOL)animated
{
    //公共部分处理
    switch (nMsgType)
    {
        case HYSystemLoginRegister: //注册并登录
        {
            HYRegisterViewController * pVC = [[HYRegisterViewController alloc] init];
            SystemPushViewController(pVC,animated);
        }
            break;
        case HYSystemLoginPersionNews: //信息完善
        {
            YLPersionNewsViewController * pVC = [[YLPersionNewsViewController alloc] init];
            NSString *_newTyoe = (NSString *)wParam;
            pVC.persionNewsType = (int)StringToBinary2Dec(_newTyoe);
            SystemPushViewController(pVC,animated);
            
        }
            break;
        case HYSystemRegisterContact: //注册并登录
        {
            HYContactViewController * pVC = [[HYContactViewController alloc] init];
            SystemPushViewController(pVC,animated);
        }
            break;
        case HYSystemLoginMain: //注册
        {
            YLLoginMainViewController * pVC = [[YLLoginMainViewController alloc] init];
            SystemPushViewController(pVC,animated);
        }
            break;
             default:
            break;
    }
}

FOUNDATION_EXPORT id SystemPushViewController(UIViewController * pVC,BOOL Animated)
{
    BOOL bFind = NO;
    NSMutableArray * pArray = [NSMutableArray arrayWithArray:[HYSystemInit sharedInstance].navigationController.viewControllers];
    NSArray * pTempArray = [NSArray arrayWithArray:pArray];
    for (UIViewController * PCurVC in pTempArray)
    {
        if ([PCurVC isKindOfClass:pVC.class] )
        {
            bFind = YES;
            [pArray removeObject:PCurVC];
        }
    }
    if ( bFind )
    {
        [pArray addObject:pVC];
        [[HYSystemInit sharedInstance].navigationController  setViewControllers:pArray animated:NO];
    }else
    {
        [[HYSystemInit sharedInstance].navigationController pushViewController:pVC animated:Animated];
    }
    return nil;
}

#pragma mark -登录
+(void)loginWith:(NSString *)phoneNum password:(NSString *)password type:(NSString *)type
{
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:[[UIApplication sharedApplication] keyWindow] wait:YES];
    NSString *typeLogin = @"login_pwd";
    if ( [type integerValue] ) {
        typeLogin = @"login_verify_code";
    }
    [getUserCenter loginWith:@{@"login_name":phoneNum,
                               typeLogin:password,
                               @"login_flag":type,
                               @"login_source":@"1"}
                  completion:^(BOOL success, NSString *msg)
    {
        [hud hide:YES];
        if (!success)
        {
            [MBProgressHUD showMessageIsWait:msg wait:YES];
            return;
        }
        if ( StringToBinary2Dec([getUserCenter.accountInfo accountInfoUser]) == 7
            || StringToBinary2Dec([getUserCenter.accountInfo accountInfoUser]) == 6)
        {
            [[HYSystemInit sharedInstance] dismissLoginView:1];
            return;
        }
        [self OnDealMes:HYSystemLoginPersionNews wParam:[getUserCenter.accountInfo accountInfoUser] animated:NO];
    }];
}

#pragma mark -注册
+(void)regiserWidth:(NSDictionary *)paramters protocolIds:(NSString *)protocolIds
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:[[UIApplication sharedApplication] keyWindow] wait:YES];
    [getUserCenter registerWith:paramters completion:^(BOOL success, NSString *msg) {
        [ hud hide:YES];
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        if ( !success )
        {
            return;
        }
        [self createHaikeProtocol:@{@"protocolIds":protocolIds,@"user_id":getUserCenter.accountInfo.userId} success:^{
            
        }];
        if ( StringToBinary2Dec([getUserCenter.accountInfo accountInfoUser]) == 7 || StringToBinary2Dec([getUserCenter.accountInfo accountInfoUser]) == 6 )
        {
            [[HYSystemInit sharedInstance] dismissLoginView:2];
            return;
        }
        [self OnDealMes:HYSystemLoginPersionNews wParam:[getUserCenter.accountInfo accountInfoUser] animated:NO];
    }];
}

#pragma mark -新增协议
+(void)createHaikeProtocol:(NSDictionary *)paramters
                   success:(CodeSuccessBlock)success
{
    [MKNetworking MKSeniorGetApi:@"/add/haike/protocol" paramters:paramters
                      completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         if ( success )
         {
             success();
         }
     }];
}

#pragma mark -完善个人信息
+(void)sendUpdateUserLoginInfoMiss:(NSDictionary *)paramters
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:[[UIApplication sharedApplication] keyWindow] wait:YES];
    [getUserCenter userUpdateLoginInfoMiss:paramters completion:^(BOOL success, NSString *msg)
    {
        [ hud hide:YES];
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        if ( !success )
        {
            return;
        }
        [[HYSystemInit sharedInstance] dismissLoginView:1];
    }];
}



#pragma mark -发送验证码
+(void)sendVerificationCode:(NSDictionary *)paramters
                    success:(CodeSuccessBlock)success
{
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorPostApi:@"/message/mobile_verify" paramters:paramters
                 completion:^(MKHttpResponse *response)
     {
         [progressHUD hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         [MBProgressHUD showMessageIsWait:@"手机验证码发送成功" wait:YES];
         if ( success )
         {
             success();
         }
         
     }];
}


#pragma mark -微信登录
+(void)sendUserWechatLogin:(NSDictionary *)paramters
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:[[UIApplication sharedApplication] keyWindow] wait:YES];
    [getUserCenter userWechatLogin:paramters completion:^(BOOL success, NSString *msg) {
        
        [ hud hide:YES];
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        if (!success)
        {
            return;
        }
        if ( StringToBinary2Dec([getUserCenter.accountInfo accountInfoUser]) == 7 || StringToBinary2Dec([getUserCenter.accountInfo accountInfoUser]) == 6)
        {
             [MBProgressHUD showMessageIsWait:msg wait:YES];
            [[HYSystemInit sharedInstance] dismissLoginView:1];
            return;
        }
        [self OnDealMes:HYSystemLoginPersionNews wParam:[getUserCenter.accountInfo accountInfoUser] animated:NO];
    }];
}

#pragma mark -发送验证码
+(void)sendqueryUserMobileDirectory:(NSDictionary *)paramters
                            success:(CodeSuccessBlock)success;
{
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorGetApi:@"/user/userMobileDirectory/query"
                       paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [progressHUD hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         if ( success )
         {
             success();
         }
         
     }];
}
#pragma mark -协议返回
+(void)sendUserprotocol:(NSDictionary *)paramters
                success:(ProtocolSuccessBlock)success;

{
    [MKNetworking MKSeniorGetApi:@"/get/Hk/protocol" paramters:paramters
                      completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         if ( success ) {
             success(response.responseDictionary[@"data"]);
         }
     }];
}
@end
