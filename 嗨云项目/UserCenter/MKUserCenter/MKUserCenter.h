//
//  MKUserCenter.h
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKAccountInfo.h"
#import "MKUserInfo.h"
#import "MKShoppingCartModel.h"
#import "MKHistoryModel.h"
#import "ShopCartFMDB.h"

extern NSString *const MKUserInfoLoadSuccessNotification;

extern NSString *const MKUserInfoLoadFailedNotification;


@interface MKUserCenter : NSObject

/**
 *  用户信息(邀请码，店铺ID)
 */
@property (nonatomic, strong, readonly) MKAccountInfo *accountInfo;

@property (nonatomic, strong) MKUserInfo *userInfo;

@property (nonatomic, strong) MKShoppingCartModel *shoppingCartModel;

@property (nonatomic, strong) MKHistoryModel *historyModel;

@property (nonatomic, strong) ShopCartFMDB *shopCart;


/**
 *  更新本地 用户数据
 *
 *  @param accountInfo 用户信息(邀请码，店铺ID)
 */
- (void)loginWithAccountInfo:(MKAccountInfo *)accountInfo;

/**
 *  当refresh_token和access_token失效的时候刷新
 *
 *  @param completion 结果
 */
- (void)refreshAccessToken:(void (^)(MKHttpResponse *response))completion;

+ (void)saveTokenCookie:(NSString *)token withrefreshToken:(NSString *)refreshToken;
/**
 *  拉起登陆界面
 */
-(void)loginoutPullView;
/**
 *  退出登录，并且清空本地信息并回到首页
 */
- (void)loginout;

/**
 *  退出登录，并且清空本地信息回到首页
 */
-(void)loginoutGotoMain;
/**
 *  判断是否登录
 *
 *  @return YES登录，NO未登录
 */
- (BOOL)isLogined;

/**
 *  刷新用户信息，如头像昵称等
 */
- (void)reloadUserInfo;

/**
 *  -清空本地用户数据
 */

-(void)clearData;

/**
 *  注册
 *
 *  @param paramters  paramters description
 *  @param completion completion description
 */
-(void)registerWith:(NSDictionary *)paramters completion:(void (^)(BOOL success, NSString *msg))completion;

/**
 *  登录
 *
 *  @param username
 *  @param password
 *  @param completion
 */
- (void)loginWith:(NSDictionary *)paramters
       completion:(void (^)(BOOL success, NSString *msg))completion;
/**
 *  更新用户信息
 *
 *  @param paramters  参数
 *  @param completion wancheng
 */
-(void)userUpdateLoginInfoMiss:(NSDictionary *)paramters
                    completion:(void (^)(BOOL success, NSString *msg))completion;
/**
 *  微信登录
 *
 *  @param paramters  参数
 *  @param completion 完成
 */
-(void)userWechatLogin:(NSDictionary *)paramters completion:(void (^)(BOOL success, NSString *msg))completion;
@end
