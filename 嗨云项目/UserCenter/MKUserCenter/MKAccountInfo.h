//
//  MKAccountInfo.h
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKAccountInfo : MKBaseObject

@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSString *refreshToken;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *inviter;

@property (nonatomic, copy) NSString *sellerId;

-(NSString *)accountInfoUser;


@end
