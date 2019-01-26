//
//  MKScrollToTopButton.m
//  YangDongXi
//
//  Created by cocoa on 15/4/28.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKScrollToTopButton.h"
#import <PureLayout.h>

@interface MKScrollToTopButton ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat visibilityOffset;

@property (nonatomic, assign) CGFloat bottomEdge;

@end


@implementation MKScrollToTopButton


+ (MKScrollToTopButton *)setupOnScrollview:(UIScrollView *)scrollView
                      withVisibilityOffset:(CGFloat)offset
                                bottomEdge:(CGFloat)bottomEdge
{
    NSCAssert(scrollView.superview, @"必须要有父视图");
    MKScrollToTopButton *bt = [MKScrollToTopButton buttonWithType:UIButtonTypeCustom];
    [bt setImage:[UIImage imageNamed:@"scrolltotop_button.png"] forState:UIControlStateNormal];
    bt.scrollView = scrollView;
    bt.visibilityOffset = offset;
    bt.bottomEdge = bottomEdge;
    
    [scrollView addObserver:bt forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    [bt addTarget:bt action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    bt.exclusiveTouch = YES;
    [scrollView.superview insertSubview:bt aboveSubview:scrollView];
    bt.translatesAutoresizingMaskIntoConstraints = NO;
    if (bottomEdge <= 0)
    {
        bottomEdge = 59;
    }
    [bt autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomEdge];
    [bt autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15];
    
    return bt;
}

- (void)cleanup
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint newContentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        self.hidden = newContentOffset.y < self.visibilityOffset;
    }
}

- (void)onClickButton:(id)sender
{
    [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
}

@end
