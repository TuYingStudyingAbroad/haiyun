//
//  NSData+MKBaseLib.m
//  MKBaseLib
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "NSData+MKBaseLib.h"

@implementation NSData (MKBaseLib)

- (id)baseLib_jsonObject
{
    if ( self == nil ) {
        return  nil;
    }
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:nil];
}


@end
