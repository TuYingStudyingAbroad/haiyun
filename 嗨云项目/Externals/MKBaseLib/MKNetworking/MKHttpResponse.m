//
//  MKHttpResponse.m
//  MKBaseLib
//
//  Created by cocoa on 15/3/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKHttpResponse.h"

@implementation MKHttpResponse

- (NSDictionary *)mkResponseData
{
    if ( [self.responseDictionary isKindOfClass:[NSDictionary class]] ) {
        return [self.responseDictionary HYNSDictionaryValueForKey:@"data"];
    }
    return nil;
}

@end
