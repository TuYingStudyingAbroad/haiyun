//
//  MKUserCenter.m
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKUserCenter.h"
#import "MKBaseLib.h"
#import "NSString+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "JPUSHService.h"
#import "HYSystemLoginMsg.h"
#import "QYSDK.h"
#import "QYUserInfo.h"
#import "NSArray+MKExtension.h"
#import "HYSystemInit.h"


NSString *const MKUserInfoLoadSuccessNotification = @"MKUserInfoLoadSuccessNotification";

NSString *const MKUserInfoLoadFailedNotification = @"MKUserInfoLoadFailedNotification";


@interface MKUserCenter ()

@property (nonatomic, strong) MKAccountInfo *accountInfo;

//有可能两次请求同时失效，就一起等待，而不是刷两次
@property (nonatomic, strong) NSMutableArray *refreshAccessResponseQueue;

@property (nonatomic, assign) BOOL isRefreshingToken;

@end


@implementation MKUserCenter

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"accountInfo"];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.refreshAccessResponseQueue = [NSMutableArray array];
        
        self.accountInfo = [MKAccountInfo loadFromClassFile];
        self.userInfo = [MKUserInfo loadFromClassFile];
        self.shoppingCartModel = [[MKShoppingCartModel alloc] init];
        self.historyModel = [[MKHistoryModel alloc] init];
        self.shopCart = [[ShopCartFMDB alloc] init];
//        if ( self.accountInfo.sellerId )
//        {
//            [MKSellerIdSingleton sellerIdSingleton].sellerId = self.accountInfo.sellerId;
//        }
        [self addObserver:self forKeyPath:@"accountInfo" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}





#pragma mark -我们的注册
-(void)registerWith:(NSDictionary *)paramters completion:(void (^)(BOOL success, NSString *msg))completion
{
    [MKNetworking MKSeniorPostUrl:[MKNetworking httpsUrlWithApi:@"/user/register"]
                        paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [self dealWithResponse:response withDefaultMsg:@"注册成功" completion:completion];
     }];
}




#pragma mark -我们的登录
-(void)loginWith:(NSDictionary *)paramters completion:(void (^)(BOOL, NSString *))completion
{
    [MKNetworking MKSeniorPostUrl:[MKNetworking httpsUrlWithApi:@"/user/login"]
                        paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [self dealWithResponse:response withDefaultMsg:@"登录成功" completion:completion];
     }];
}

#pragma mark -微信登录
-(void)userWechatLogin:(NSDictionary *)paramters completion:(void (^)(BOOL success, NSString *msg))completion
{
    [MKNetworking MKSeniorPostUrl:[MKNetworking httpsUrlWithApi:@"/user/wechat/login"]
                        paramters:paramters
                       completion:^(MKHttpResponse *response)
     {
         [self dealWithResponse:response withDefaultMsg:@"微信登录成功" completion:completion];
     }];
    
}
#pragma mark -完善个人信息
-(void)userUpdateLoginInfoMiss:(NSDictionary *)paramters
                    completion:(void (^)(BOOL success, NSString *msg))completion
{
    [MKNetworking MKSeniorPostApi:@"/user/loginInfoMiss/update"
                        paramters:paramters
                       completion:^(MKHttpResponse *response)
    {
        NSString *msg = response.errorMsg;
        BOOL success = NO;
        do
        {
            if (msg != nil)
            {
                break;
            }
            success = YES;
            msg = @"完善个人信息成功";
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[response mkResponseData]];
            if ( dict && dict.count > 0 )
            {
                [self loginWithAccountInfo:[MKAccountInfo objectWithDictionary:@{
                                                          @"user_id" : [dict objectForKey:@"user_id"],                       @"access_token" : [dict objectForKey:@"access_token"],
                                                                                 @"refresh_token" : [dict objectForKey:@"refresh_token"],
                                                                                 @"mobile" : @"1",
                                                                                 @"password" : @"1",
                                                                                 @"inviter" : @"1",
                                                                                 @"seller_id" : [dict objectForKey:@"seller_id"]
                                                                                 }]];
            }
           
        }
        while (0);
        if (completion != nil)
        {
            completion(success, msg);
        }
    }];
}
#pragma mark -存储或者更新本地用户数据
- (void)loginWithAccountInfo:(MKAccountInfo *)accountInfo
{
    //添加sellerID
//    if ( accountInfo.sellerId )
//    {
//        [MKSellerIdSingleton sellerIdSingleton].sellerId = accountInfo.sellerId;
//    }
    self.accountInfo = accountInfo;
    [MKUserCenter saveTokenCookie:self.accountInfo.accessToken withrefreshToken:self.accountInfo.refreshToken];
    if ( ISNSStringValid(self.accountInfo.accessToken))
    {
        [self loadUserInfo];
    }
}

#pragma mark -仅仅拉起登陆页面
-(void)loginoutPullView
{
    [[HYSystemInit sharedInstance] pullupLoginView];
}

#pragma mark -退出登录，回到首页吊起登陆
- (void)loginout
{
    [self clearData];
    [getMainTabBar guideToHome];
    getMainTabBar.tabBar.hidden = NO;
    [[HYSystemInit sharedInstance] pullupLoginView];

    
}
#pragma mark -清空本地用户数据
-(void)clearData
{
    self.accountInfo = nil;
    [MKAccountInfo deleteClassFile];
    [MKUserCenter removeTokenCookie];
    
    self.userInfo = nil;
    [MKUserInfo deleteClassFile];
    self.shoppingCartModel.itemCount = 0;
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    [MKUserCenter saveTokenCookie:@"" withrefreshToken:@""];
    [[QYSDK sharedSDK] logout:^(){
        
        //        NSLog(@"退出成功");
    }];
}
#pragma mark -退出登录，回到首页
-(void)loginoutGotoMain
{
    [self clearData];
    [getMainTabBar guideToHome];
    getMainTabBar.tabBar.hidden = NO;
}
#pragma mark -判断是否登录
- (BOOL)isLogined
{
    if ( self.accountInfo && ISNSStringValid(self.accountInfo.accessToken)
        &&  (StringToBinary2Dec([self.accountInfo accountInfoUser])== 7
             || StringToBinary2Dec([self.accountInfo accountInfoUser])== 6 )  )
    {
        return YES;
    }
    return NO;
}

#pragma mark -存储用户信息（邀请码，店铺ID等）
- (void)dealWithResponse:(MKHttpResponse *)response withDefaultMsg:(NSString *)defaultMsg
              completion:(void (^)(BOOL success, NSString *msg))completion
{
    NSString *msg = response.errorMsg;
    BOOL success = NO;
    do
    {
        if (msg != nil)
        {
            break;
        }
        success = YES;
        msg = defaultMsg;
        [self loginWithAccountInfo:[MKAccountInfo objectWithDictionary:[response mkResponseData]]];
    }
    while (0);
    if (completion != nil)
    {
        completion(success, msg);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accountInfo"])
    {
        [self.accountInfo saveToClassFile];
    }
}

#pragma mark -WebView存储cookieTokenKey等
+ (void)saveTokenCookie:(NSString *)token withrefreshToken:(NSString *)refreshToken
{
    NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
    
    [cookiePropertiesUser setObject:cookieTokenKey forKey:NSHTTPCookieName];
    [cookiePropertiesUser setObject:token forKey:NSHTTPCookieValue];
    [cookiePropertiesUser setObject:cookieDomain forKey:NSHTTPCookieDomain];
    
    [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    [self setTokenCookie:refreshToken];
    
}

+ (void)setTokenCookie:(NSString *)token{
    NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
    [cookiePropertiesUser setObject:cookieTokenKeyRefresh forKey:NSHTTPCookieName];
    [cookiePropertiesUser setObject:token forKey:NSHTTPCookieValue];
    [cookiePropertiesUser setObject:cookieDomain forKey:NSHTTPCookieDomain];
    
    [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
}

+ (void)removeTokenCookie
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in storage.cookies)
    {
        if ([cookie.name isEqualToString:cookieTokenKey])
        {
            [storage deleteCookie:cookie];
        }
    }
}
#pragma mark -刷新refresh_token和access_token
- (void)refreshAccessToken:(void (^)(MKHttpResponse *response))completion
{
    [self.refreshAccessResponseQueue addObject:completion];
    if (self.isRefreshingToken)
    {
        return;
    }
    self.isRefreshingToken = YES;
    
    MKAccountInfo *accountInfo = self.accountInfo;
    [MKNetworking MKSeniorPostUrl:[MKNetworking httpsUrlWithApi:@"/auth/access_token/refresh"]
                        paramters:@{@"refresh_token" : accountInfo.refreshToken == nil ? @"" : accountInfo.refreshToken,
                                    @"access_token" : accountInfo.accessToken == nil ? @"" : accountInfo.accessToken}
                completion:^(MKHttpResponse *response)
    {
        if (response.errorMsg == nil)
        {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[response mkResponseData]];
            if ( dict && dict.count > 0 )
            {
                [self loginWithAccountInfo:[MKAccountInfo objectWithDictionary:@{
                                                                                 @"user_id" : accountInfo.userId,                       @"access_token" : [dict objectForKey:@"access_token"],
                                                                                 @"refresh_token" : [dict objectForKey:@"refresh_token"],
                                                                                 @"mobile" :accountInfo.mobile,
                                                                                 @"password" : accountInfo.password,
                                                                                 @"inviter" : accountInfo.inviter,
                                                                                 @"seller_id" : accountInfo.sellerId
                                                                                 }]];
            }
        }
        for (void (^completion)(MKHttpResponse *response) in self.refreshAccessResponseQueue)
        {
            completion(response);
        }
        [self.refreshAccessResponseQueue removeAllObjects];
        self.isRefreshingToken = NO;
    }];
}
#pragma mark -刷新用户头像等信息
- (void)reloadUserInfo
{
    [self loadUserInfo];
}

- (void)loadUserInfo
{
    [MKNetworking MKSeniorGetApi:@"/user/userOneselfInfo/query" paramters:nil completion:^(MKHttpResponse *response)
    {
        if (response.errorMsg != nil)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MKUserInfoLoadFailedNotification object:nil];
            self.userInfo = nil;
            return ;
        }
        MKUserInfo *inf = [MKUserInfo objectWithDictionary:response.mkResponseData];
        self.userInfo = inf;
        [inf saveToClassFile];
        [self changeQYUserInfo];
        [JPUSHService setAlias:[NSString stringWithFormat:@"%li", (long)self.userInfo.userId] callbackSelector:nil object:nil];
        if ( ISNSStringValid( self.accountInfo.accessToken ) ) {
             [[NSNotificationCenter defaultCenter] postNotificationName:MKUserInfoLoadSuccessNotification object:nil];
        }
    }];
}

-(void)changeQYUserInfo
{
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = [NSString stringWithFormat:@"%ld",self.userInfo.userId];
    NSMutableArray *ar = [[NSMutableArray alloc] init];
    NSDictionary *dic1 = @{@"key":@"real_name",@"value":self.userInfo.userName};
    NSDictionary *dic2 = @{@"key":@"mobile_phone",@"value":self.userInfo.mobile};
    [ar addObject:dic1];
    [ar addObject:dic2];
    userInfo.data = [ar jsonString];
//    NSLog(@"%@",[ar jsonString]);
    [[QYSDK sharedSDK] setUserInfo:userInfo];
}
@end
