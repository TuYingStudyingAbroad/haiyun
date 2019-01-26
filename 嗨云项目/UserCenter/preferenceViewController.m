//
//  preferenceViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "preferenceViewController.h"
#import "preferenceListViewController.h"
#import "MKCouponObject.h"
#import "AppDelegate.h"

@interface preferenceViewController ()

@end

@implementation preferenceViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.hidesBottomBarWhenPushed = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";

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
    NSArray *array = @[@"未使用",@"已使用",@"已过期"];
    NSArray *statuses = @[@(0), @(1), @(2)];
    for (int i = 0; i < array.count; i++)
    {
        preferenceListViewController * preferenceListVC=[[preferenceListViewController alloc]init];
        preferenceListVC.title = array[i];
        preferenceListVC.hidesBottomBarWhenPushed = YES;
        preferenceListVC.orderStatus = [statuses[i] integerValue];
        [pages addObject:preferenceListVC];
        
    }
    self.pages = pages;
    self.pageControl.selectedSegmentIndex = [statuses indexOfObject:@(self.orderStatus)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
