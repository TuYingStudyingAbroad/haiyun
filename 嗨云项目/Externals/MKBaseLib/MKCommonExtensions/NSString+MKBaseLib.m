//
//  NSString+MKBaseLib.m
//  MKBaseLib
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "NSString+MKBaseLib.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MKBaseLib)

- (NSString *)baseLib_md5String
{
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), result);
    return [NSString baseLib_hexString:result withLength:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)baseLib_sha256String
{
    const char *str = [self UTF8String];
    uint8_t result[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(str, (uint32_t)strlen(str), result);
    return [NSString baseLib_hexString:result withLength:CC_SHA256_DIGEST_LENGTH];
}

+ (NSString *)baseLib_hexString:(uint8_t *)bytes withLength:(NSInteger)len
{
    NSMutableString *output = [NSMutableString stringWithCapacity:len * 2];
    for(int i = 0; i < len; i++)
    {
        [output appendFormat:@"%02x", bytes[i]];
    }
    return [output copy];
}

@end
