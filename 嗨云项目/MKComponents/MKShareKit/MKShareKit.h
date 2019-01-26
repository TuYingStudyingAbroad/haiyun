//
//  MKShareKit.h
//  YangDongXi
//
//  Created by cocoa on 15/5/7.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKShareInfo.h"

@interface MKShareKit : NSObject

+ (void)registerPlatforms;

+ (void)authenticateWithThirdParty:(MKPlatformType)type
                          complete:(void (^)(NSString *token, NSString *openId, NSString *msg))completion;

+ (void)shareWithInfo:(MKShareInfo *)shareInfo completion:(void (^)(NSString *errorMsg))completion;

+ (BOOL)applicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
