//
//  MKMulipartFormObject.h
//  MKBaseLib
//
//  Created by cocoa on 15/3/18.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief 用于POST请求的对象
 */
@interface MKMulipartFormObject : NSObject

/**
 @brief 请求内部使用
 */
@property (nonatomic, strong, readonly) NSString *boundary;

/**
 @brief 请求内部使用
 */
@property (nonatomic, strong, readonly) NSMutableData *buildingData;

/**
 @brief 是否完成了，endBuild后为YES
 */
@property (nonatomic, assign, readonly) BOOL isEndBuild;

/**
 @brief 增加POST参数
 */
- (void)addParameters:(NSDictionary *)parameters;

/**
 @brief 增加文件数据
 */
- (void)addFileData:(NSData *)file withName:(NSString *)name type:(NSString *)type filename:(NSString *)filename;

/**
 @brief 增加jpg文件数据
 */
- (void)addJPGData:(NSData *)file withName:(NSString *)name;

/**
 @brief 增加结尾标记
 */
- (void)endBuild;

@end
