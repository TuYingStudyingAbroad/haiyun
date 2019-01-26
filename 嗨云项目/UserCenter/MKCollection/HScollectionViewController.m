//
//  HScollectionViewController.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HScollectionViewController.h"
#import "MKMyCollectionController.h"

@interface HScollectionViewController ()

@end

@implementation HScollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageControl.backgroundColor = [UIColor whiteColor];
    self.pageControl.verticalDividerColor = [UIColor clearColor];
    self.pageControl.selectionIndicatorColor = [UIColor colorWithHex:0xff4d55];
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
    self.title = @"我的收藏";
    NSMutableArray *pages = [NSMutableArray new];
    NSArray *array = @[@"收藏的商品"];
    NSArray *statuses = @[@(0)];
    for (int i = 0; i < array.count; i++)
    {
        MKMyCollectionController *orderListViewController = [[MKMyCollectionController alloc] init];
        orderListViewController.title = array[i];
        
        orderListViewController.orderStatus = [statuses[i] integerValue];
        
        [pages addObject:orderListViewController];
    }
    self.pages = pages;
    
    self.pageControl.selectedSegmentIndex = 0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
