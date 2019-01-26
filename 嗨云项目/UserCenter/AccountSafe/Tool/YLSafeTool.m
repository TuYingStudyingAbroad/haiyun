//
//  YLSafeTool.m
//  嗨云项目
//
//  Created by haiyun on 16/5/26.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeTool.h"
#import "MKNetworking+BusinessExtension.h"
#import "YLSafeUserInfo.h"
#import "HYSafeBandInfo.h"

@implementation YLSafeTool

#pragma mark -校验旧支付密码
+(void)sendCheckUserOldPayPwd:(NSDictionary *)paramters
                      success:(BandSaveSuccessBlocks)success
                      failure:(SafeToolFailureBlocks)failure
{
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorGetApi:@"/user/oldPayPwd/check" paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [progressHUD hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             if ( failure ) {
                 failure();
             }
             return ;
         }
         if ( success )
         {
             success();
         }
         
     }];
}

#pragma mark -修改支付密码
+(void)sendUserPayPwdUpdate:(NSDictionary *)paramters success:(BandSaveSuccessBlocks)success failure:(SafeToolFailureBlocks)failure
{
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorPostApi:@"/user/userPayPwd/update" paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [progressHUD hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             if ( failure ) {
                 failure();
             }
             return ;
         }
         [MBProgressHUD showMessageIsWait:@"支付密码修改成功" wait:YES];
         if ( success )
         {
             success();
         }
         
     }];
}
#pragma mark -设置支付密码
+(void)sendUserPayPwdReset:(NSDictionary *)paramters
                   success:(BandSaveSuccessBlocks)success
                   failure:(SafeToolFailureBlocks)failure
{
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorPostApi:@"/user/userPayPwd/reset" paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [progressHUD hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             if ( failure ) {
                 failure();
             }
             return ;
         }
         [MBProgressHUD showMessageIsWait:@"支付密码设置成功" wait:YES];
         if ( success )
         {
             success();
         }
         
     }];
}

#pragma mark -校验“原手机号丢失"输入身份证是否正确
+(void)sendUserModifyUserMobileCheck:(NSDictionary *)paramters
                             success:(BandSaveSuccessBlocks)success
{
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorGetApi:@"/user/modifyUserMobile/check" paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [progressHUD hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
//         [MBProgressHUD showMessageIsWait:@"身份验证成功" wait:YES];
         if ( success )
         {
             success();
         }
         
     }];
}
#pragma mark -判断是否实名
+(void)sendUserAuthInfoGet:(BandSaveSuccessBlocks)success
{
    [MKNetworking MKSeniorGetApi:@"/user/userAuthInfo/get" paramters:nil completion:^(MKHttpResponse *response) {
        if (response.errorMsg != nil)
        {
            return ;
        }
        if ( success )
        {
            success();
        }
    }];
}
#pragma mark -更新手机号
+(void)sendUserMobileupdate:(NSDictionary *)paramters
                    success:(BandSaveSuccessBlocks)success
{
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorPostApi:@"/user/mobile/update" paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [progressHUD hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         [MBProgressHUD showMessageIsWait:@"手机号码修改成功" wait:YES];
         if ( success )
         {
             success();
         }
         
     }];
}
#pragma mark -查询账户信息(注意)
+(void)sendUserSafeInfoQuerySuccess:(SafeToolSuccessBlocks)success
                            failure:(SafeToolFailureBlocks)failure
{
    [MKNetworking MKSeniorGetApi:@"/user/userSafeInfo/query" paramters:nil completion:^(MKHttpResponse *response) {
        if ( response.errorMsg != nil)
        {
            if ( failure)
            {
                failure();
            }
            return ;
        }
        if ( success )
        {
            YLSafeUserInfo *userInf =  [YLSafeUserInfo objectWithDictionary:[response mkResponseData]];
            success(userInf);
        }
    }];
}
#pragma mark -发送验证码
+(void)sendVerificationCode:(NSDictionary *)paramters
                    success:(BandSaveSuccessBlocks)success
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

#pragma mark -更新或者设置密码
+(void)sendUpdatePwd:(NSDictionary *)paramters
             success:(BandSaveSuccessBlocks)success
{
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorPostApi:@"/user/password/update" paramters:paramters
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
#pragma mark -实名认证
+(void)sendUserAuthonSave:(NSDictionary *)paramters
                  success:(BandSaveSuccessBlocks)success
{
//    [MKNetworking setBaseUrl:@"http://192.168.8.148:9091"];
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorPostApi:@"/user/authon/save" paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
//         [MKNetworking setBaseUrl:BaseUrl];
         [progressHUD hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         [MBProgressHUD showMessageIsWait:@"实名认证资料提交成功" wait:YES];
         if ( success )
         {
             success();
         }
     }];
}

+(void)sendUserAuthonAuditing:(NSDictionary *)paramters
                      success:(SafeToolSuccessBlocks)success
                      failure:(SafeToolFailureBlocks)failure
{
//    [MKNetworking setBaseUrl:@"http://192.168.8.141:9092"];
    MBProgressHUD *progressHUD = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    [MKNetworking MKSeniorGetApi:@"/user/authon/Auditing" paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [progressHUD hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             failure();
             return ;
         }
         if ( success )
         {
             HYSafeBandInfo *userInf;
             if ( [[response mkResponseData] count] ) {
                userInf =  [HYSafeBandInfo objectWithDictionary:[response mkResponseData]];
             }else
             {
                 userInf = [HYSafeBandInfo objectWithDictionary:@{@"authon_status":@"1"}];
             }
             
             success( userInf );
         }
     }];
}

@end
