//
//  NSData+MKExtension.m
//  MKBaseLib
//
//  Created by cocoa on 15/2/5.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "NSData+MKExtension.h"

@implementation NSData (MKExtension)

- (id)jsonObject
{
    if ( self == nil ) {
        return  nil;
    }
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:nil];
}

@end
