//
//  YLSafeNewViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeNewViewController.h"
#import "YLSafeNewView.h"

@interface YLSafeNewViewController ()
{
    YLSafeNewView            *_pView;
}

@end

@implementation YLSafeNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyNavigation];
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
    [self initsubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void) initsubView
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    rect.size.height = self.view.frame.size.height - rect.origin.y;
    if ( _pView == nil)
    {
        _pView = NewObject(YLSafeNewView);
        _pView.backgroundColor = [UIColor clearColor];
        _pView.frame = rect;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.frame = rect;
    }
}


- (void)setMyNavigation
{
    
    self.title = @"修改手机号";
    // 下一步
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithMJTitle:@"完成" target:self action:@selector(rightButton)];
}

-(void)rightButton
{
    if ( _pView )
    {
        [_pView onButtonClickRight];
    }
}


@end
