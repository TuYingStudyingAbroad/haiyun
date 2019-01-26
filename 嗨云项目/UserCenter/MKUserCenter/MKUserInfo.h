//
//  MKUserInfo.h
//  YangDongXi
//
//  Created by cocoa on 15/5/26.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKUserInfo : MKBaseObject

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, assign) NSInteger inviterId;

@property (nonatomic, strong) NSString *invitationCode;

@property (nonatomic, copy) NSString *headerUrl;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, assign) NSInteger sex;

/**
 *  角色类型 1，普通用户；2，嗨客；5，已有嗨客资格 
 */
@property (nonatomic, copy) NSString *roleMark;
//粉丝数
@property (nonatomic, copy) NSString *fansCount;
@end
