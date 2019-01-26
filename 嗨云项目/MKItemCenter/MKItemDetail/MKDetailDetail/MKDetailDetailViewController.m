//
//  MKDetailDetailViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDetailDetailViewController.h"
#import "UIColor+MKExtension.h"
#import "MKItemPropertiesViewController.h"
#import "MKDetailWebViewController.h"
#import "UIViewController+MKExtension.h"
#import "MKScrollToTopButton.h"

@interface MKDetailDetailViewController () <UIScrollViewDelegate, MKDetailDetailSubViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *scrollToTopButtons;

@property (nonatomic, strong) MKDetailWebViewController *detailWebViewController;

@property (nonatomic, strong) MKDetailWebViewController *commentWebViewController;

@property (nonatomic, strong) MKItemPropertiesViewController *itemPropertiesViewController;

@property (nonatomic, assign) BOOL enableSubScroll;

@end


@implementation MKDetailDetailViewController

- (void)dealloc
{
    for (MKScrollToTopButton *b in self.scrollToTopButtons)
    {
        [b cleanup];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pageControl.backgroundColor = [UIColor whiteColor];
    self.pageControl.verticalDividerColor = [UIColor clearColor];
//    self.pageControl.height = 40;
    self.pageControl.selectionIndicatorColor = [UIColor clearColor];
    //    self.pageControl.selectedTextColor = [UIColor whiteColor];
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:14],//文本的颜色 字体 大小
                           NSForegroundColorAttributeName:[UIColor blackColor]//文字颜色
                           };
    self.pageControl.titleTextAttributes = attrs;
    self.pageControl.selectedTitleTextAttributes = attrs;
    self.pageControl.borderColor = [UIColor colorWithHex:0x333333];
    self.pageControl.type = HMSegmentedControlTypeText;
    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.pageControl.selectionIndicatorHeight = 2.0f;
    
    self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    NSMutableArray *pages = [NSMutableArray new];
    
    self.detailWebViewController = [[MKDetailWebViewController alloc] init];
    self.detailWebViewController.delegate = self;
    self.detailWebViewController.title = @"图文详情";
    [pages addObject:self.detailWebViewController];
    
//    self.itemPropertiesViewController = [[MKItemPropertiesViewController alloc] init];
//    self.itemPropertiesViewController.delegate = self;
//    self.itemPropertiesViewController.title = @"产品参数";
//    [pages addObject:self.itemPropertiesViewController];
    
//    self.commentWebViewController = [[MKDetailWebViewController alloc] init];
//    self.commentWebViewController.delegate = self;
//    self.commentWebViewController.title = @"商品评论";
//    [pages addObject:self.commentWebViewController];
    
    self.pages = pages;
    
    self.scrollToTopButtons = [NSMutableArray array];
    [self enableScroll:NO];
}

- (void)loadItem:(MKItemObject *)item
{
    if ( item.itemType == 13 ) {
        
        [self.detailWebViewController loadUrl:[NSString stringWithFormat:@"%@/detail.html?item_uid=%@&item_type=%ld&type=content",BaseHtmlURL, item.itemUid,(long)item.itemType]];
    }else{
     [self.detailWebViewController loadUrl:[NSString stringWithFormat:@"%@/detail.html?item_uid=%@&type=content",BaseHtmlURL, item.itemUid]];
    }

//    [self.commentWebViewController loadUrl:[NSString stringWithFormat:@"%@/detail.html?item_uid=%@&type=comment", BaseUrl,item.itemUid]];
//    NSLog(@"%@",[NSString stringWithFormat:@"%@/detail.html?item_uid=%@&type=content&distributor_id=%@",BaseHtmlURL, item.itemUid,item.distributorInfo.distributorId]);
//    NSLog(@"%@",[NSString stringWithFormat:@"%@/detail.html?item_uid=%@&type=comment", BaseUrl,item.itemUid]);

    [self.itemPropertiesViewController loadProperties:item.itemProperties];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y < -30)
    {
        [self scrollToTop];
    }
}

- (void)subViewControllerViewDidLoad:(UIViewController<MKDetailDetailSubViewControllerProtocol> *)viewController
{
    __weak UIScrollView *s = [viewController getScrollView];
    s.scrollEnabled = self.enableSubScroll;
    MKScrollToTopButton *bt = [MKScrollToTopButton setupOnScrollview:s withVisibilityOffset:-1 bottomEdge:50];
    [bt addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    s.delegate = self;
    [self.scrollToTopButtons addObject:bt];
}

- (void)scrollToTop
{
    [self.delegate detailDetailViewControllerNeedScrollToTop];
}

- (void)enableScroll:(BOOL)enable
{
    self.enableSubScroll = enable;
    for (MKDetailWebViewController *v in self.pages)
    {
        [v getScrollView].scrollEnabled = enable;
    }
}

@end
