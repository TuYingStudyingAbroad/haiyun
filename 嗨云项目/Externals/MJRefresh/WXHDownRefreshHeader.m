//
//  WXHDownRefreshHeader.m
//  Haiyn
//
//  Created by kans on 16/3/4.
//  Copyright © 2016年 HaiYn. All rights reserved.
//

#import "WXHDownRefreshHeader.h"

@implementation WXHDownRefreshHeader
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 21; i>0; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu.png",(unsigned long)i]];

        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 8; i>0; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sx%lu.png",(unsigned long)i]];
        [refreshingImages addObject:image];
    }
    
    [self setImages:@[[UIImage imageNamed:[NSString stringWithFormat:@"1.png"]]] forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}








@end
