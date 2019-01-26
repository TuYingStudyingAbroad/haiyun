//
//  MKAppConfig.h
//  YangDongXi
//
//  Created by cocoa on 15/4/14.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKAppConfig : MKBaseAppConfig

@property (nonatomic,strong) NSString *commonToken;
   
/**
 @brief 配置参数信息
 */
@property (nonatomic,strong) NSDictionary *bizInfo;
/**
 @brief 当前版本启动次数
 */
- (NSUInteger)launchTimesThisVersion;

@end
