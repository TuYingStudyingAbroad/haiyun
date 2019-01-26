//
//  YLLoginMainViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLLoginMainViewController.h"
#import "HYLoginMainView.h"
#import "HYSystemInit.h"

@interface YLLoginMainViewController ()<HYBaseViewDelegate>
{
    HYLoginMainView   *_pView;
}

@end

@implementation YLLoginMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"密码登录";
    [self initsubview];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"AllBack" highlightedIcon:@"AllBack" target:self action:@selector(leftBarButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)initsubview
{
    CGRect rect = CGRectMake(0,0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    rect.size.height -= rect.origin.x;
    if ( _pView == nil )
    {
        _pView = [[HYLoginMainView alloc] init];
        _pView.frame = rect;
        _pView.baseDelegate = self;
        [self.view addSubview:_pView];
    }else
    {
        _pView.frame = rect;
    }
    
}
-(void)OnPushController:(NSInteger)nMsgType wParam:(id)wParam
{
    if ( nMsgType == 0 && ISNSStringValid(wParam) )
    {
        self.title = wParam;
    }
}
#pragma mark-取消
-(void)leftBarButton
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
