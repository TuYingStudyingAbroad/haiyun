//
//  MKHttpResponse.h
//  MKBaseLib
//
//  Created by cocoa on 15/3/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief 错误类型
 */
typedef NS_OPTIONS(NSUInteger, MKHttpErrorType)
{
    MKHttpErrorTypeNone,
    MKHttpErrorTypeLocal,   //本地错误，如网络错误
    MKHttpErrorTypeRemote,  //服务器错误，responseCode不为00000
};

@interface MKHttpResponse : NSObject

@property (nonatomic, strong) NSDictionary *responseDictionary;

@property (nonatomic, assign) NSInteger responseCode;

@property (nonatomic, assign) MKHttpErrorType errorType;

@property (nonatomic, strong) NSString *errorMsg;

@property (nonatomic, strong) NSError *connectionError;

@property (nonatomic, strong) NSData *originData;

/**
 @brief 从responseDictionary提取data字段
 */
- (NSDictionary *)mkResponseData;

@end
