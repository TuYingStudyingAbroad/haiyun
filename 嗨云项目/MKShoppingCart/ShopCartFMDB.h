//
//  ShopCartFMDB.h
//  嗨云项目
//
//  Created by 唯我独尊 on 16/9/1.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKCartItemObject.h"

@interface ShopCartFMDB : NSObject

- (void)newShopCartItem:(MKCartItemObject *)item;

- (NSArray *)lastItemFromIndex:(NSInteger)index count:(NSInteger)count;

- (void)deleteItem:(MKCartItemObject *)item;

- (void)clear;

@end
