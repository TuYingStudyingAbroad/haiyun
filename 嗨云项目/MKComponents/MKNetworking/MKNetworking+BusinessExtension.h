//
//  MKNetworking+BusinessExtension.h
//  YangDongXi
//
//  Created by cocoa on 15/5/13.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <MKBaseLib/MKBaseLib.h>

#define sessionTokenError 50002
#define accessTokenError 50004
#define refreshTokenError 50006


@interface MKNetworking (BusinessExtension)

+ (void)registerPlatforms;

+ (void)MKSeniorGetApi:(NSString *)api paramters:(NSDictionary *)paramters
            completion:(void (^)(MKHttpResponse *response))completion;

+ (void)MKSeniorPostApi:(NSString *)api paramters:(NSDictionary *)paramters
             completion:(void (^)(MKHttpResponse *response))completion;

/**
 主要用于https请求
 */
+ (void)MKSeniorGetUrl:(NSString *)url paramters:(NSDictionary *)paramters
            completion:(void (^)(MKHttpResponse *response))completion;

+ (void)MKSeniorPostUrl:(NSString *)url paramters:(NSDictionary *)paramters
             completion:(void (^)(MKHttpResponse *response))completion;

/**
 主要用于将基础的http转换为https
 */
+ (NSString *)httpsUrlWithApi:(NSString *)api;

@end
