//
//  YLSafeAuthenticationViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeAuthenticationViewController.h"
#import "YLSafeAuthenticationView.h"
#import "YLSafeNewViewController.h"
#import "YLSafeBandViewController.h"
#import "PersonZLViewController.h"
#import "YLSafePayPasswordController.h"
#import "MKPlaceTheOrderController.h"

@interface YLSafeAuthenticationViewController ()<HYBaseViewDelegate>
{
    YLSafeAuthenticationView            *_pView;
}

@end

@implementation YLSafeAuthenticationViewController

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
        _pView = NewObject(YLSafeAuthenticationView);
        _pView.nsPassword = self.nsPassword;
        _pView.backgroundColor = [UIColor clearColor];
        _pView.frame = rect;
        _pView.baseDelegate = self;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.frame = rect;
    }
}


- (void)setMyNavigation
{
    
    self.title = @"核实身份";
    NSString *titleName = @"下一步";
    if ( ISNSStringValid(self.nsPassword) )
    {
        titleName = @"完成";
    }
    
    
    // 下一步
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithMJTitle:titleName target:self action:@selector(rightButton)];
//left
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"AllBack" highlightedIcon:@"AllBack" target:self action:@selector(leftBarButtonClicks)];
    
}

-(void)leftBarButtonClicks
{
    for(UIViewController *pVc in self.navigationController.viewControllers)
    {
        if ([pVc isKindOfClass:[PersonZLViewController class]])
        {
            [self.navigationController popToViewController:pVc animated:YES];
        }
    }
}

-(void)rightButton
{
    if ( _pView )
    {
        [_pView onButtonClickRight];
    }
}

#pragma mark -HYBaseViewDelegate
-(void)OnPushController:(NSInteger)nMsgType wParam:(id)wParam
{
    if ( nMsgType == 0 )
    {
        if ( self.typeCard == 1)
        {
            YLSafeBandViewController *pVc = [[YLSafeBandViewController alloc] init];
            pVc.nsPhoneType = 2;
            pVc.nsIsCard = YES;
            pVc.nsPhoneNum = nil;
            [self.navigationController pushViewController:pVc animated:YES];
        }
        else if( self.typeCard == 2 )
        {
            YLSafePayPasswordController *pVc = [[YLSafePayPasswordController alloc] init];
            pVc.payState = SafePayPasswordStateForgetNew;
            [self.navigationController pushViewController:pVc animated:YES];

        }
    }else if( nMsgType == 1 )
    {
        for(UIViewController *pVc in self.navigationController.viewControllers)
        {
            if ([pVc isKindOfClass:[MKPlaceTheOrderController class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPasswordSuccessfully" object:nil];
                break;
            }
        }
        for(UIViewController *pVc in self.navigationController.viewControllers)
        {
            if ([pVc isKindOfClass:[PersonZLViewController class]])
            {
                [self.navigationController popToViewController:pVc animated:YES];
            }
        }
        
    }else
    {
        NSInteger i = 0;
        for(UIViewController *pVc in self.navigationController.viewControllers)
        {
            i++;
            if ([pVc isKindOfClass:[PersonZLViewController class]])
            {
                break;
            }
        }
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i] animated:YES];
    }
}
@end
