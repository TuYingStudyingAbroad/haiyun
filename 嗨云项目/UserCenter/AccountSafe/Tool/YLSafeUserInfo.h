//
//  YLSafeUserInfo.h
//  嗨云项目
//
//  Created by haiyun on 16/5/26.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface YLSafeUserInfo : MKBaseObject

@property(nonatomic,copy) NSString *payPassword;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *authId;
@property(nonatomic,copy) NSString *authName;
@property(nonatomic,copy) NSString *authIdCard;

//认证状态(待确认0 成功1 失败2 未实名 -1)
@property(nonatomic,copy) NSString *authonStatus;
/**
 *  是否是卖家（1买家，2嗨客,5拥有嗨客资格）
 */
@property(nonatomic,copy) NSString *roleMark;

@end
