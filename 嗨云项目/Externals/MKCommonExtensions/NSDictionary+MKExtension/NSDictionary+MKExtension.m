//
//  NSDictionary+MKExtension.m
//  MKBaseLib
//
//  Created by cocoa on 15/4/3.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "NSDictionary+MKExtension.h"

@implementation NSDictionary (MKExtension)

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
