//
//  YLSafeTool.h
//  嗨云项目
//
//  Created by haiyun on 16/5/26.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BandSaveSuccessBlocks)(void);
typedef void (^SafeToolSuccessBlocks)(id nMsg);
typedef void (^SafeToolFailureBlocks)(void);
@interface YLSafeTool : NSObject

/**
 *  校验旧支付密码
 *
 *  @param paramters pay_pwd 旧支付密码
 *  @param success   success
 *  @param failure   failure
 */
+(void)sendCheckUserOldPayPwd:(NSDictionary *)paramters
                      success:(BandSaveSuccessBlocks)success
                      failure:(SafeToolFailureBlocks)failure;
/**
 *  修改支付密码
 *
 *  @param paramters 信息
 *  @param success   success description
 *  @param failure   failure description
 */
+(void)sendUserPayPwdUpdate:(NSDictionary *)paramters
                    success:(BandSaveSuccessBlocks)success
                    failure:(SafeToolFailureBlocks)failure;

/**
 *  设置、忘记支付密码
 *
 *  @param paramters paramters description
 *  @param success   success description
 *  @param failure   failure description
 */
+(void)sendUserPayPwdReset:(NSDictionary *)paramters
                   success:(BandSaveSuccessBlocks)success
                   failure:(SafeToolFailureBlocks)failure;

/**
 *  1.检验原手机号验证码是否输入正确(即修改手机号时原手机号的校验)
 或
 2.校验“原手机号丢失"输入身份证是否正确
 *
 *  @param paramters paramters description
 *  @param success   success description
 */
+(void)sendUserModifyUserMobileCheck:(NSDictionary *)paramters
                             success:(BandSaveSuccessBlocks)success;


/**
 *  判断是否实名
 *
 *  @param success success description
 */
+(void)sendUserAuthInfoGet:(BandSaveSuccessBlocks)success;
 
/**
 *  更新手机号
 *
 *  @param paramters paramters description
 *  @param success   success description
 */
+(void)sendUserMobileupdate:(NSDictionary *)paramters
                  success:(BandSaveSuccessBlocks)success;

/**
 *  查询账户信息(注意)
 *
 *  @param success success description
 */
+(void)sendUserSafeInfoQuerySuccess:(SafeToolSuccessBlocks)success
                            failure:(SafeToolFailureBlocks)failure;
/**
 *  更新密码或者设置密码
 *
 *  @param paramters 参数
 *  @param success   成功
 */
+(void)sendUpdatePwd:(NSDictionary *)paramters
             success:(BandSaveSuccessBlocks)success;
/**
 *   实名认证
 *
 *  @param paramters 参数
 *  @param success   success
 */
+(void)sendUserAuthonSave:(NSDictionary *)paramters
                  success:(BandSaveSuccessBlocks)success;

/**
 *  发送验证码
 *
 *  @param paramters 参数
 *  @param success   success description
 */
+(void)sendVerificationCode:(NSDictionary *)paramters
                    success:(BandSaveSuccessBlocks)success;

/**
 *   判断实名认证过程
 *
 *  @param paramters 参数
 *  @param success   success
 */
+(void)sendUserAuthonAuditing:(NSDictionary *)paramters
                  success:(SafeToolSuccessBlocks)success
                      failure:(SafeToolFailureBlocks)failure;


@end
