//
//  incomDetailViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "incomDetailViewController.h"
#import "MKOrderListViewController.h"

@interface incomDetailViewController ()<UIScrollViewDelegate,totopDelegate>

@property (nonatomic, assign) BOOL enableSubScroll;

@end

@implementation incomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"账户明细";
    
    self.pageControl.backgroundColor = [UIColor whiteColor];
    self.pageControl.verticalDividerColor = [UIColor clearColor];
    self.pageControl.selectionIndicatorColor = [UIColor colorWithHex:0xff4d55];
    //    self.pageControl.selectedTextColor = [UIColor whiteColor];
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:14],//文本的颜色 字体 大小
                           NSForegroundColorAttributeName:[UIColor blackColor]//文字颜色
                           };
    NSDictionary* attrs1 =@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:14],//选中文本的颜色 字体 大小
                            NSForegroundColorAttributeName:[UIColor redColor]//文字颜色
                            };
    self.pageControl.titleTextAttributes = attrs;
    self.pageControl.selectedTitleTextAttributes = attrs1;
    self.pageControl.borderColor = [UIColor colorWithHex:0x333333];
    self.pageControl.type = HMSegmentedControlTypeText;
    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.pageControl.selectionIndicatorHeight = 2.0f;
    
    self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //    self.pageControl.font = [UIFont systemFontOfSize:13.0f];
    
    NSMutableArray *pages = [NSMutableArray new];
    NSArray *array = @[@"收入",@"支出",@"提现"];
    NSArray *statuses = @[@(1), @(2), @(3)];
    for (int i = 0; i < array.count; i++)
    {
        self.incomelistVC=[[incomeListViewController alloc]init];
        self.incomelistVC.title = array[i];
        self.incomelistVC.hidesBottomBarWhenPushed = YES;
        self.incomelistVC.delegate=self;
        self.incomelistVC.orderStatus = [statuses[i] integerValue];
        [pages addObject:self.incomelistVC];
        
    }
    self.pages = pages;
    
    [self enableScroll:NO];
    
    
    //    self.pageControl.selectedSegmentIndex = [statuses indexOfObject:@(self.orderStatus)];
    
}



- (void)enableScroll:(BOOL)enable
{
    self.enableSubScroll = enable;
    
    for (incomeListViewController * v in self.pages)
    {
        v.tableView .scrollEnabled = enable;
    }
}


-(void)getMoneyViewControllerNeedScrollToTop{
    [self scrollToTop];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y < -30)
    {
        [self scrollToTop];
    }
}



- (void)scrollToTop
{
    [self.delegate detailDetailViewControllerNeedScrollToTop];
}



@end
