//
//  HYNavigationController.m
//  HaiYun
//
//  Created by YanLu on 16/4/11.
//  Copyright © 2016年 YanLu. All rights reserved.
//

#import "HYNavigationController.h"

@interface HYNavigationController ()<UIGestureRecognizerDelegate>
{
    UIButton *_leftBtn;
}

@end

@implementation HYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.interactivePopGestureRecognizer.delegate = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigationBar];
}


//设置导航栏主题
- (void)setupNavigationBar
{
    UINavigationBar *appearance = self.navigationBar;
    [appearance setTintColor:[UIColor colorWithHex:0x6b6e73]];
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
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( self.viewControllers.count )
    {
        if ( _leftBtn == nil )
        {
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftBtn.frame = CGRectMake(0, 0, 44, 44);
            [_leftBtn setImage:[UIImage imageNamed:@"AllBack"] forState:UIControlStateNormal];
            [_leftBtn setImage:[UIImage imageNamed:@"AllBack"] forState:UIControlStateHighlighted];
            [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -18.0f, 0, 16)];
            [_leftBtn addTarget:self action:@selector(onLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    }
    [super pushViewController:viewController animated:animated];
}


- (void)onLeftButton:(id)sender
{
    if ( _leftBtn == sender )
    {
        [self popViewControllerAnimated:YES];
    }
}




//手势代理
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    return self.childViewControllers.count > 1;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
