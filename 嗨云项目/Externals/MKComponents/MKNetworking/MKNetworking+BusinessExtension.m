//
//  MKNetworking+BusinessExtension.m
//  YangDongXi
//
//  Created by cocoa on 15/5/13.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKNetworking+BusinessExtension.h"
#import "AppDelegate.h"


@implementation MKNetworking (BusinessExtension)

+ (void)registerPlatforms
{
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MKAppConfig" ofType:@"plist"]];
    
    NSString *appKey = [d[@"MKApp"][@"appKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([appKey length] > 0)
    {
        [MKNetworking setAppKey:appKey];
    }
    
    NSString *appSecret = [d[@"MKApp"][@"appSecret"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([appSecret length] > 0)
    {
        [MKNetworking setAppSecret:appSecret];
    }
}

+ (void)getCommonToken:(void (^)(MKHttpResponse *response, BOOL sessionTokenRepeat, BOOL accessTokenRepeat))completion
    sessionTokenRepeat:(BOOL)sessionTokenRepeat
     accessTokenRepeat:(BOOL)accessTokenRepeat
{
    [MKNetworking MKGETAPI:@"auth/session_token/get" paramters:nil completion:^(MKHttpResponse *response)
    {
        if (response.errorMsg == nil)
        {
            getAppConfig.commonToken = response.mkResponseData[@"session_token"];
        }
        completion(response, sessionTokenRepeat, accessTokenRepeat);
    }];
}

+ (void)MKSeniorGetApi:(NSString *)api paramters:(NSDictionary *)paramters
            completion:(void (^)(MKHttpResponse *response))completion
{
    [self MKSeniorGetApi:api paramters:paramters completion:completion sessionTokenRepeat:NO accessTokenRepeat:NO];
}

+ (void)MKSeniorPostApi:(NSString *)api paramters:(NSDictionary *)paramters
             completion:(void (^)(MKHttpResponse *response))completion
{
    [self MKSeniorPostApi:api paramters:paramters completion:completion
       sessionTokenRepeat:NO accessTokenRepeat:NO];
}

+ (void)MKSeniorGetUrl:(NSString *)url paramters:(NSDictionary *)paramters
            completion:(void (^)(MKHttpResponse *response))completion
{
    [self MKSeniorGetUrl:url paramters:paramters completion:completion sessionTokenRepeat:NO accessTokenRepeat:NO];
}

+ (void)MKSeniorPostUrl:(NSString *)url paramters:(NSDictionary *)paramters
             completion:(void (^)(MKHttpResponse *response))completion
{
    [self MKSeniorPostUrl:url paramters:paramters completion:completion sessionTokenRepeat:NO accessTokenRepeat:NO];
}

+ (NSString *)httpsUrlWithApi:(NSString *)api
{
    //修改这里
    NSString *sb = [[MKNetworking getBaseUrl] stringByReplacingOccurrencesOfString:@"http://" withString:@"http://"];
//    NSString *sb = [[MKNetworking getBaseUrl] stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    return [sb stringByAppendingString:api];
}

+ (void)MKSeniorGetApi:(NSString *)api paramters:(NSDictionary *)paramters
            completion:(void (^)(MKHttpResponse *response))completion
    sessionTokenRepeat:(BOOL)sessionTokenRepeat
     accessTokenRepeat:(BOOL)accessTokenRepeat
{
    void (^getTokenCompletion)(MKHttpResponse *response, BOOL sessionTokenRepeat, BOOL accessTokenRepeat) =
        ^(MKHttpResponse *response, BOOL sessionTokenRepeat, BOOL accessTokenRepeat)
    {
        if (response.errorMsg != nil)
        {
            completion(response);
            return ;
        }
        [self MKSeniorGetApi:api paramters:paramters completion:completion
          sessionTokenRepeat:sessionTokenRepeat accessTokenRepeat:accessTokenRepeat];
    };
    NSString *commonToken = getAppConfig.commonToken;
    if (commonToken == nil)
    {
        [self getCommonToken:getTokenCompletion sessionTokenRepeat:YES accessTokenRepeat:NO];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:paramters];
    p[@"session_token"] = commonToken;
    p[@"server_version"] = MockuaiVersionCode;
    NSString *userToken = getUserCenter.accountInfo.accessToken;
    if (userToken != nil)
    {
        p[@"access_token"] = userToken;
    }
    
    [self MKGETAPI:api paramters:p completion:^(MKHttpResponse *response)
    {
        if (response.responseCode == sessionTokenError && !sessionTokenRepeat)
        {
            [self getCommonToken:getTokenCompletion sessionTokenRepeat:YES accessTokenRepeat:NO];
            return ;
        }
        if (response.responseCode == accessTokenError && !accessTokenRepeat)
        {
            [getUserCenter refreshAccessToken:^(MKHttpResponse *response)
            {
                getTokenCompletion(response, NO, YES);
            }];
            return ;
        }
        if (response.responseCode == refreshTokenError)
        {
            response.errorMsg = @"您的登录状态失效了，请重新登录";
            [getUserCenter loginout];
        }
        completion(response);
    }];
}

+ (void)MKSeniorPostApi:(NSString *)api paramters:(NSDictionary *)paramters
             completion:(void (^)(MKHttpResponse *response))completion
     sessionTokenRepeat:(BOOL)sessionTokenRepeat
      accessTokenRepeat:(BOOL)accessTokenRepeat
{
    void (^getTokenCompletion)(MKHttpResponse *response, BOOL sessionTokenRepeat, BOOL accessTokenRepeat) =
        ^(MKHttpResponse *response, BOOL sessionTokenRepeat, BOOL accessTokenRepeat)
    {
        if (response.errorMsg != nil)
        {
            completion(response);
            return ;
        }
        [self MKSeniorPostApi:api paramters:paramters completion:completion
           sessionTokenRepeat:sessionTokenRepeat accessTokenRepeat:accessTokenRepeat];
    };
    
    NSString *commonToken = getAppConfig.commonToken;
    if ( commonToken == nil )
    {
        [self getCommonToken:getTokenCompletion sessionTokenRepeat:YES accessTokenRepeat:NO];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:paramters];
    p[@"session_token"] = commonToken;
    p[@"server_version"] = MockuaiVersionCode;
    NSString *userToken = getUserCenter.accountInfo.accessToken;
    if (userToken != nil)
    {
        p[@"access_token"] = userToken;
    }
    
    [self MKPOSTAPI:api paramters:p completion:^(MKHttpResponse *response)
    {
        if (response.responseCode == sessionTokenError && !sessionTokenRepeat)
        {
            [self getCommonToken:getTokenCompletion sessionTokenRepeat:YES accessTokenRepeat:NO];
            return ;
        }
        if (response.responseCode == accessTokenError && !accessTokenRepeat)
        {
            [getUserCenter refreshAccessToken:^(MKHttpResponse *response)
            {
                getTokenCompletion(response, NO, YES);
            }];
            return ;
        }
        if (response.responseCode == refreshTokenError)
        {
            response.errorMsg = @"您的登录状态失效了，请重新登录";
            [getUserCenter loginout];
        }
        completion(response);
    }];
}

+ (void)MKSeniorGetUrl:(NSString *)url paramters:(NSDictionary *)paramters
            completion:(void (^)(MKHttpResponse *response))completion
    sessionTokenRepeat:(BOOL)sessionTokenRepeat
     accessTokenRepeat:(BOOL)accessTokenRepeat
{
    void (^getTokenCompletion)(MKHttpResponse *response, BOOL sessionTokenRepeat, BOOL accessTokenRepeat) =
    ^(MKHttpResponse *response, BOOL sessionTokenRepeat, BOOL accessTokenRepeat)
    {
        if (response.errorMsg != nil)
        {
            completion(response);
            return ;
        }
        [self MKSeniorGetUrl:url paramters:paramters completion:completion
          sessionTokenRepeat:sessionTokenRepeat accessTokenRepeat:accessTokenRepeat];
    };
    NSString *commonToken = getAppConfig.commonToken;
    if (commonToken == nil)
    {
        [self getCommonToken:getTokenCompletion sessionTokenRepeat:YES accessTokenRepeat:NO];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:paramters];
    p[@"session_token"] = commonToken;
    p[@"server_version"] = MockuaiVersionCode;
    NSString *userToken = getUserCenter.accountInfo.accessToken;
    if (userToken != nil)
    {
        p[@"access_token"] = userToken;
        
    }
    
    [self MKGETUrl:url paramters:p completion:^(MKHttpResponse *response)
    {
        if (response.responseCode == sessionTokenError && !sessionTokenRepeat)
        {
            [self getCommonToken:getTokenCompletion sessionTokenRepeat:YES accessTokenRepeat:NO];
            return ;
        }
        if (response.responseCode == accessTokenError && !accessTokenRepeat)
        {
            [getUserCenter refreshAccessToken:^(MKHttpResponse *response)
            {
                getTokenCompletion(response, NO, YES);
            }];
            return ;
        }
        if (response.responseCode == refreshTokenError)
        {
            response.errorMsg = @"您的登录状态失效了，请重新登录";
            [getUserCenter loginout];
        }
        completion(response);
    }];
}

+ (void)MKSeniorPostUrl:(NSString *)url paramters:(NSDictionary *)paramters
             completion:(void (^)(MKHttpResponse *response))completion
     sessionTokenRepeat:(BOOL)sessionTokenRepeat
      accessTokenRepeat:(BOOL)accessTokenRepeat
{
    void (^getTokenCompletion)(MKHttpResponse *response, BOOL sessionTokenRepeat, BOOL accessTokenRepeat) =
    ^(MKHttpResponse *response, BOOL sessionTokenRepeat, BOOL accessTokenRepeat)
    {
        if (response.errorMsg != nil)
        {
            completion(response);
            return ;
        }
        [self MKSeniorPostUrl:url paramters:paramters completion:completion
           sessionTokenRepeat:sessionTokenRepeat accessTokenRepeat:accessTokenRepeat];
    };
    
    NSString *commonToken = getAppConfig.commonToken;
    if (commonToken == nil)
    {
        [self getCommonToken:getTokenCompletion sessionTokenRepeat:YES accessTokenRepeat:NO];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:paramters];
    p[@"session_token"] = commonToken;
    p[@"server_version"] = MockuaiVersionCode;
    
    NSString *userToken = getUserCenter.accountInfo.accessToken;
    if (userToken != nil)
    {
        p[@"access_token"] = userToken;
        
    }
    
    [self MKPOSTUrl:url paramters:p completion:^(MKHttpResponse *response)
    {
        if (response.responseCode == sessionTokenError && !sessionTokenRepeat)
        {
            [self getCommonToken:getTokenCompletion sessionTokenRepeat:YES accessTokenRepeat:NO];
            return ;
        }
        if (response.responseCode == accessTokenError && !accessTokenRepeat)
        {
            [getUserCenter refreshAccessToken:^(MKHttpResponse *response)
            {
                getTokenCompletion(response, NO, YES);
            }];
            return ;
        }
        if (response.responseCode == refreshTokenError)
        {
            response.errorMsg = @"您的登录状态失效了，请重新登录";
            [getUserCenter loginout];
        }
        completion(response);
    }];
}

@end
