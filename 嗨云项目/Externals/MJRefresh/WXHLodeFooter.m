//
//  WXHLodeFooter.m
//  Haiyn
//
//  Created by kans on 16/3/4.
//  Copyright © 2016年 HaiYn. All rights reserved.
//

#import "WXHLodeFooter.h"

@implementation WXHLodeFooter
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
