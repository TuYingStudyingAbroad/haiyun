//
//  YLSafeLoginPasswordViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeLoginPasswordViewController.h"
#import "YLSafeLoginPasswordView.h"


@interface YLSafeLoginPasswordViewController ()<HYBaseViewDelegate>
{
    YLSafeLoginPasswordView    *_pView;
}
@end

@implementation YLSafeLoginPasswordViewController

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
        _pView = NewObject(YLSafeLoginPasswordView);
        _pView.backgroundColor = [UIColor clearColor];
        _pView.nsPhoneNum = self.nsPhoneNum;
        _pView.nsIsChange = self.nsIsChange;
        _pView.baseDelegate = self;
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
    if ( self.nsIsChange )
    {
        self.title = @"修改密码";
    }else
    {
        self.title = @"设置密码";
    }
    // 完成
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithMJTitle:@"完成" target:self action:@selector(rightButton)];
}

-(void)rightButton
{
    if ( _pView )
    {
        [_pView onButtonClickRight];
    }
}

#pragma mark -pop
-(void)OnPushController:(NSInteger)nMsgType wParam:(id)wParam
{
    if ( nMsgType == 0 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
