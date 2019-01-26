//
//  MKSearchModel.h
//  YangDongXi
//
//  Created by cocoa on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKSearchModel : NSObject

- (void)searchKeyword:(NSString *)keyword;

- (NSArray *)lastTenKeyword;

- (void)clear;

- (BOOL)delOneKeyword:(NSString *)keyword;

@end
