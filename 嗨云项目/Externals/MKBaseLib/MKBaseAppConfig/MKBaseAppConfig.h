//
//  MKBaseAppConfig.h
//  MKBaseLib
//
//  Created by cocoa on 15/4/14.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MKBaseAppConfig : NSObject

/**
 @brief 魔块设备唯一标示
 */
+ (NSString *)MKUDID;

/**
 @brief 外部版本，对应Version
 */
- (NSString *)getAppVersion;

/**
 @brief 内部版本，对应build
 */
- (NSString *)getBuildVersion;

/**
 @brief idfa
 */
- (NSString *)getIdfa;

/**
 @brief 分辨率
 */
- (CGSize)screenResolution;

@end
