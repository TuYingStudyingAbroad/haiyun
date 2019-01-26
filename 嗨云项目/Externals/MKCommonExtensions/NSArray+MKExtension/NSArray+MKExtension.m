//
//  NSArray+MKExtension.m
//  MKBaseLib
//
//  Created by cocoa on 15/2/9.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "NSArray+MKExtension.h"

@implementation NSArray (MKExtension)

- (NSString *)jsonString
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    if (data == nil)
    {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
