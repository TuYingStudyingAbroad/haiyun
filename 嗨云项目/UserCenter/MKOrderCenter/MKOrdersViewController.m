//
//  MKOrdersViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKOrdersViewController.h"
#import "MKOrderListViewController.h"
#import "MKBaseLib.h"
#import "UIColor+MKExtension.h"

#import "MKAfterSalesViewController.h"


@interface MKOrdersViewController ()

@property (nonatomic, weak) IBOutlet UIView *emptyView;

@property (nonatomic, strong) NSMutableArray *statuses;

@end

@implementation MKOrdersViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的订单";
    self.pageControl.backgroundColor         = [UIColor whiteColor];
    self.pageControl.verticalDividerColor    = [UIColor clearColor];
    self.pageControl.selectionIndicatorColor = [UIColor colorWithHex:0xff4d55];
    //    self.pageControl.selectedTextColor = [UIColor whiteColor];
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:14],//文本的颜色 字体 大小
                           NSForegroundColorAttributeName:[UIColor blackColor]//文字颜色
                           };
    NSDictionary* attrs1 =@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:14],//选中文本的颜色 字体 大小
                            NSForegroundColorAttributeName:kHEXCOLOR(kRedColor)//文字颜色
                            };
    self.pageControl.titleTextAttributes         = attrs;
    self.pageControl.selectedTitleTextAttributes = attrs1;
    self.pageControl.borderColor                 = [UIColor colorWithHex:0x333333];
    self.pageControl.type                        = HMSegmentedControlTypeText;
    self.pageControl.selectionIndicatorLocation  = HMSegmentedControlSelectionIndicatorLocationDown;
    self.pageControl.selectionIndicatorHeight    = 2.0f;

    self.pageControl.selectionStyle              = HMSegmentedControlSelectionStyleTextWidthStripe;
    NSMutableArray *pages                        = [NSMutableArray new];
    NSArray *array                               = @[@"全部",@"待付款",@"待发货",@"待收货"];
    if ( _statuses == nil )
    {
        _statuses = [[NSMutableArray alloc] initWithArray:@[@(0), @(MKOrderStatusUnpaid), @(MKOrderStatusPaid), @(MKOrderStatusDeliveried)]];
    }else
    {
        [_statuses removeAllObjects];
        [_statuses addObjectsFromArray:@[@(0), @(MKOrderStatusUnpaid), @(MKOrderStatusPaid), @(MKOrderStatusDeliveried)]];
    }
    for (int i = 0; i < array.count; i++)
    {
        MKOrderListViewController *orderListViewController = [[MKOrderListViewController alloc] init];
        orderListViewController.title       = array[i];

        orderListViewController.orderStatus = [self.statuses[i] integerValue];

        [pages addObject:orderListViewController];
    }
    self.pages                            = pages;

    self.pageControl.selectedSegmentIndex = [self.statuses indexOfObject:@(self.orderStatus)];

    self.emptyView.clipsToBounds          = YES;
    self.emptyView.layer.cornerRadius     = 50.0f;
}

-(void)changePageColtrol:(MKOrderStatus )orderStatus
{
    self.orderStatus = orderStatus;
    [self setSelectedPageIndex:[self.statuses indexOfObject:@(self.orderStatus)] animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


@end
