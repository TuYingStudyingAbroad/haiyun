//
//  MKHistoryModel.h
//  YangDongXi
//
//  Created by cocoa on 15/5/11.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKItemObject.h"

@interface MKHistoryModel : NSObject

- (void)newHistoryItem:(MKItemObject *)item;

- (NSArray *)lastItemFromIndex:(NSInteger)index count:(NSInteger)count;

- (void)deleteItem:(MKItemObject *)item;

- (void)clear;

@end
