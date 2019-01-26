//
//  MKRollImagesView.m
//  YangDongXi
//
//  Created by cocoa on 15/4/10.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKRollImagesView.h"
#import <PunchScrollView.h>
#import <PureLayout.h>
#import <UIImageView+WebCache.h>
#import "UIColor+MKExtension.h"

#define DurationOfScroll 4.0f


@interface MKRollImagesView () <PunchScrollViewDataSource, PunchScrollViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) PunchScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, assign) BOOL isAutoScroll;

@end


@implementation MKRollImagesView

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"bannerUrls"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initViews];
    }
    return self;
}

//这里开始写代码
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initViews];
}

- (void)initViews
{
    self.scrollView = [[PunchScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.dataSource = self;
    self.scrollView.infiniteScrolling = YES;
    [self addSubview:self.scrollView];
    [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.pageControl = [[UIPageControl alloc] init];
    [self addSubview:self.pageControl];
    [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15];
    [self addObserver:self forKeyPath:@"bannerUrls" options:NSKeyValueObservingOptionNew context:NULL];
    
    if ([self.pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
    {
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"ff4b55"];
    }
    if ([self.pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)])
    {
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"ebebeb"];
    }
    
}

- (void)autoRollEnable:(BOOL)enable
{
    self.isAutoScroll = enable;
    [self autoRoll:enable];
}

- (void)autoRoll:(BOOL)enable
{
    if (!enable)
    {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
    else if (self.scrollTimer == nil)
    {
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:DurationOfScroll target:self
                                                          selector:@selector(swipeViewCircleAction:) userInfo:nil repeats:YES];
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bannerUrls"])
    {
        [self.scrollView reloadData];
        self.pageControl.numberOfPages = self.bannerUrls.count;
    }
}

#pragma mark -
#pragma mark -------------------- PunchScrollViewDataSource ---------------------

- (NSInteger)punchscrollView:(PunchScrollView *)scrollView numberOfPagesInSection:(NSInteger)section
{
    return self.bannerUrls.count > 0 ? self.bannerUrls.count : self.images.count;
}

- (UIView*)punchScrollView:(PunchScrollView*)scrollView viewForPageAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *page = (UIImageView *)[scrollView dequeueRecycledPage];
    if (page == nil)
    {
        page = [[UIImageView alloc] initWithFrame:scrollView.bounds];
        page.contentMode = UIViewContentModeScaleToFill;
        page.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    if (self.bannerUrls.count > indexPath.row)
    {
        [page sd_setImageWithURL:[NSURL URLWithString:self.bannerUrls[indexPath.row]] placeholderImage:self.placeHolderImage];
    }
    else if (self.images.count > indexPath.row)
    {
        page.image = self.images[indexPath.row];
    }
    return page;
}

#pragma mark -
#pragma mark -------------------- PunchScrollViewDelegate ---------------------
- (void)punchScrollView:(PunchScrollView *)scrollView pageChanged:(NSIndexPath*)indexPath
{
    self.pageControl.currentPage = indexPath.row;
}

- (void)punchScrollView:(PunchScrollView *)scrollView didTapOnPage:(UIView*)view
            atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(rollImagesView:didClickIndex:)])
    {
        [self.delegate rollImagesView:self didClickIndex:indexPath.row];
    }
}

#pragma mark -
#pragma mark -------------------- UIScrollViewDelegate --------------------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self autoRoll:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self autoRoll:self.isAutoScroll];
}

- (void)swipeViewCircleAction:(NSTimer *)timer
{
    if (self.bannerUrls.count <= 1)
    {
        return;
    }
    
    [self.scrollView scrollToNextPage:YES];
}

@end
