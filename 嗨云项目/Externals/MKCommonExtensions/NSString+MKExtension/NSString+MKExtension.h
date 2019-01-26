//
//  NSString+MKExtension.h
//  MKBaseLib
//
//  Created by cocoa on 15/3/27.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MKExtension)

- (NSString *)md5String;

- (NSString *)sha256String;

+ (NSString *)hexString:(uint8_t *)bytes withLength:(NSInteger)len;

/**
 @brief 保留2位小数，会去掉后面的0
 */
+ (NSString *)stringWithFloat:(float)value;

@end
