//
//  HYSystemLoginMsg.h
//  嗨云项目
//
//  Created by YanLu on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//


#define HYSystemLoginRegister           10000 //注册并登录
#define HYSystemLoginPersionNews       10001
#define HYSystemRegisterContact        10002 //获取验证码
#define HYSystemLoginMain              10003//登录

#import <Foundation/Foundation.h>

// 焦点图回调block
typedef void (^CodeSuccessBlock)(void);
typedef void (^ProtocolSuccessBlock)(id);


@interface HYSystemLoginMsg : NSObject

//事件处理函数 nMsgType（事件功能号） wParam（事件附带的参数）
+(void)OnDealMes:(NSInteger)nMsgType wParam:(id)wParam animated:(BOOL)animated;

//登录
+(void)loginWith:(NSString *)phoneNum password:(NSString *)password type:(NSString *)type;



/**
 *  注册
 *
 *  @param paramters
 */
+(void)regiserWidth:(NSDictionary *)paramters protocolIds:(NSString *)protocolIds
;

/**
 *  发送验证码
 *
 *  @param paramters 参数
 *  @param success   成功
 */
+(void)sendVerificationCode:(NSDictionary *)paramters
                    success:(CodeSuccessBlock)success;



/**
 *  完善个人信息
 *
 *  @param paramters 信息
 */
+(void)sendUpdateUserLoginInfoMiss:(NSDictionary *)paramters;

/**
 *  微信登录
 *
 *  @param paramters 信息
 */
+(void)sendUserWechatLogin:(NSDictionary *)paramters;

+(void)sendqueryUserMobileDirectory:(NSDictionary *)paramters success:(CodeSuccessBlock)success;

+(void)sendUserprotocol:(NSDictionary *)paramters
                success:(ProtocolSuccessBlock)success;

/**
 *  新增协议
 *
 *  @param paramters 信息
 */
+(void)createHaikeProtocol:(NSDictionary *)paramters
                   success:(CodeSuccessBlock)success;
@end
