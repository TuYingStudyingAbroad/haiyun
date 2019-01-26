//
//  HYFirstBaseViewController.m
//  嗨云项目
//
//  Created by haiyun on 16/6/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYFirstBaseViewController.h"

@interface HYFirstBaseViewController ()

@end

@implementation HYFirstBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( self.navigationController.viewControllers.count == 1 )
    {
        [self setupRedNavigationBar];
    }
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self setupNavigationBar];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)setupNavigationBar
{
    UINavigationBar *appearance = self.navigationController.navigationBar;
    //统一设置导航栏颜色，如果单个界面需要设置，可以在viewWillAppear里面设置，在viewWillDisappear设置回统一格式。
    //    [appearance setBarTintColor:[UIColor redColor]];
    
    //导航栏title格式
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x252525];
    textAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:17.0f];
    [appearance setTitleTextAttributes:textAttribute];
    //设置navigationbar的半透明
    [appearance setTranslucent:NO];
    //去除UINavigationBar下面黑色的线颜色
    [appearance setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [appearance setShadowImage:[UIImage imageWithSolidColor:kHEXCOLOR(0xe9e9e9) size:CGSizeMake(Main_Screen_Width, 1.0f)]];
    
    [appearance setBarTintColor:[UIColor whiteColor]];
    
}

-(void)setupRedNavigationBar
{
    UINavigationBar *appearance = self.navigationController.navigationBar;
    //统一设置导航栏颜色，如果单个界面需要设置，可以在viewWillAppear里面设置，在viewWillDisappear设置回统一格式。
    //    [appearance setBarTintColor:[UIColor redColor]];
    
    //导航栏title格式
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:17.0f];
    [appearance setTitleTextAttributes:textAttribute];
    //设置navigationbar的半透明
    [appearance setTranslucent:NO];
    //去除UINavigationBar下面黑色的线颜色
    [appearance setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [appearance setShadowImage:[UIImage imageWithSolidColor:kHEXCOLOR(0xe9e9e9) size:CGSizeMake(Main_Screen_Width, 1.0f)]];
    
    [appearance setBarTintColor:[UIColor colorWithHex:kRedColor]];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ( self.navigationController.viewControllers.count == 1 )
    {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
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
