//
//  MKDetailPhotosViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDetailPhotosViewController.h"
#import <PunchScrollView.h>
#import <UIImageView+WebCache.h>
#import <PureLayout.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIColor+MKExtension.h"
 
@interface MKDetailPhotosViewController () <PunchScrollViewDataSource, PunchScrollViewDelegate, MJPhotoBrowserDelegate>

@property (strong, nonatomic) PunchScrollView *punchScrollView;

@end


@implementation MKDetailPhotosViewController

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"imageUrls"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutViews];
    
    [self addObserver:self forKeyPath:@"imageUrls" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)layoutViews
{
    self.punchScrollView = [[PunchScrollView alloc] initWithFrame:self.view.bounds];
    
    self.punchScrollView.infiniteScrolling = YES;
    self.punchScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.punchScrollView];
    self.punchScrollView.backgroundColor = [UIColor clearColor];
    
    self.pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:self.pageControl];
    [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15];
    
    if ([self.pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
    {
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"ff4b55"];
    }
    if ([self.pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)])
    {
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"ebebeb"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.punchScrollView.delegate || !self.punchScrollView.dataSource)
    {
        self.punchScrollView.delegate = self;
        self.punchScrollView.dataSource = self;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"imageUrls"])
    {
        self.pageControl.numberOfPages = self.imageUrls.count;
        [self.punchScrollView reloadData];
    }
}

#pragma mark -
#pragma mark -------------------- PunchScrollViewDataSource ---------------------
- (NSInteger)punchscrollView:(PunchScrollView *)scrollView numberOfPagesInSection:(NSInteger)section
{
    return self.imageUrls.count;
}

- (UIView*)punchScrollView:(PunchScrollView*)scrollView viewForPageAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *page = (UIImageView*)[scrollView dequeueRecycledPage];
    if (page == nil)
    {
        page = [[UIImageView alloc] initWithFrame:scrollView.bounds];
        page.contentMode = UIViewContentModeScaleAspectFill;
        page.clipsToBounds = YES;
        page.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.hidesWhenStopped = YES;
        indicatorView.tag = 666;
        [page addSubview:indicatorView];
        [indicatorView autoCenterInSuperview];
    }
    
    UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[page viewWithTag:666];
    [indicatorView startAnimating];
    if (self.imageUrls.count != 0)
    {
        
        [page sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[indexPath.row]]
                placeholderImage:[UIImage imageNamed:@"placeholder_320x320"]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            [indicatorView stopAnimating];
        }];
    }else
    {
        [indicatorView stopAnimating];
    }
    return page;
}

#pragma mark -
#pragma mark -------------------- PunchScrollViewDelegate ---------------------
- (void)punchScrollView:(PunchScrollView*)scrollView pageChanged:(NSIndexPath*)indexPath
{
    self.pageControl.currentPage = indexPath.row;
}

- (void)punchScrollView:(PunchScrollView *)scrollView didTapOnPage:(UIView *)view atIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i<self.imageUrls.count; i++)
    {
        // 替换为中等尺寸图片
        NSString *url = self.imageUrls[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = (UIImageView *)view; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.delegate = self;
    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
