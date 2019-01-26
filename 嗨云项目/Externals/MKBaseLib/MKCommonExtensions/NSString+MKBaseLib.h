//
//  NSString+MKBaseLib.h
//  MKBaseLib
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MKBaseLib)

- (NSString *)baseLib_md5String;

- (NSString *)baseLib_sha256String;

+ (NSString *)baseLib_hexString:(uint8_t *)bytes withLength:(NSInteger)len;

@end
