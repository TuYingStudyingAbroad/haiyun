//
//  MKShoppingCartModel.m
//  YangDongXi
//
//  Created by cocoa on 15/4/29.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKShoppingCartModel.h"

#define itemCountUserDefaultsKey @"itemCountUserDefaultsKey"

@implementation MKShoppingCartModel

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"itemCount"];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.itemCount = [[NSUserDefaults standardUserDefaults] integerForKey:itemCountUserDefaultsKey];
        [self addObserver:self forKeyPath:@"itemCount" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.itemCount forKey:itemCountUserDefaultsKey];
}

@end
