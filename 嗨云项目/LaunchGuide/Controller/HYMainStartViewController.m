//
//  HYMainStartViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYMainStartViewController.h"
#import "HYMainStartView.h"

@interface HYMainStartViewController()
{
    HYMainStartView     * _pView;
}

@end

@implementation HYMainStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initsubview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setNeedsStatusBarAppearanceUpdate];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)initsubview
{
    if (_pView == nil)
    {
        _pView = [[HYMainStartView  alloc] init];
        _pView.backgroundColor = [UIColor clearColor];
        _pView.frame = self.view.bounds;
        [self.view addSubview:_pView];
    }else
    {
        _pView.frame = self.view.bounds;
    }
    
#ifdef __IPHONE_7_0
    if (IS_IOS(7))
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
