//
//  MKScrollToTopButton.h
//  YangDongXi
//
//  Created by cocoa on 15/4/28.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @brief 点击就返回顶部的按键
 */
@interface MKScrollToTopButton : UIButton

/**
 @param offset      滑动多少才显示出来
 @param bottomEdge  与底部的距离
 */
+ (MKScrollToTopButton *)setupOnScrollview:(UIScrollView *)scrollView
                      withVisibilityOffset:(CGFloat)offset
                                bottomEdge:(CGFloat)bottomEdge;

- (void)cleanup;

@end
