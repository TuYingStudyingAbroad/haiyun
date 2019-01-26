//
//  NSString+MKExtension.m
//  MKBaseLib
//
//  Created by cocoa on 15/3/27.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "NSString+MKExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MKExtension)

- (NSString *)md5String
{
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), result);
    return [NSString hexString:result withLength:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)sha256String
{
    const char *str = [self UTF8String];
    uint8_t result[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(str, (uint32_t)strlen(str), result);
    return [NSString hexString:result withLength:CC_SHA256_DIGEST_LENGTH];
}

+ (NSString *)hexString:(uint8_t *)bytes withLength:(NSInteger)len
{
    NSMutableString *output = [NSMutableString stringWithCapacity:len * 2];
    for(int i = 0; i < len; i++)
    {
        [output appendFormat:@"%02x", bytes[i]];
    }
    return [output copy];
}

+ (NSString *)stringWithFloat:(float)value
{
    NSString *string = [NSString stringWithFormat:@"%.2f", value];
    if ([[string substringFromIndex:string.length - 1] isEqualToString:@"0"])
    {
        string = [string substringToIndex:string.length - 1];
        if ([string rangeOfString:@".0"].location != NSNotFound)
        {
            string = [string substringToIndex:string.length - 2];
        }
    }
    return string;
}

@end
