//
//  YLSafePayPasswordController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/14.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafePayPasswordController.h"
#import "YLSafePayPasswordView.h"
#import "YLSafeAuthenticationViewController.h"
#import "YLSafeTool.h"
#import "PersonZLViewController.h"

@interface YLSafePayPasswordController()<HYBaseViewDelegate>
{
    YLSafePayPasswordView   *_pView;
}

@end

@implementation YLSafePayPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
    [self initsubView];
    [self setMyNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ( _pView ) {
        [_pView safePayPasswordClearAll];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void) initsubView
{
    BOOL isHide = YES;
    NSString *titleName = @"设置支付密码";
    switch (self.payState) {
        case SafePayPasswordStateFirstSet:{
            titleName = @"设置支付密码";
        }
            break;
        case SafePayPasswordStateFirstNext:{
            titleName = @"再次确认";
        }
            break;
        case SafePayPasswordStateOld:{
            isHide = NO;
            titleName = @"输入旧支付密码";
        }
            break;
        case SafePayPasswordStateNew:{
            titleName = @"设置新支付密码";
        }
            break;
        case SafePayPasswordStateNewNext:{
            titleName = @"再次确认";
        }
            break;
        case SafePayPasswordStateForgetNew:{
            titleName = @"设置新支付密码";
        }
            break;
        case SafePayPasswordStateForgetNewNext:{
            titleName = @"再次确认";
        }
            break;
        default:
            break;
    }
    self.title = titleName;
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    rect.size.height = self.view.frame.size.height - rect.origin.y;
    if ( _pView == nil)
    {
        _pView = [[YLSafePayPasswordView alloc] initWithFrame:rect hideForget:isHide];
        _pView.backgroundColor = [UIColor clearColor];
        _pView.frame = rect;
        _pView.baseDelegate = self;
        [self.view addSubview:_pView];
        if ( self.payState == SafePayPasswordStateNewNext || self.payState == SafePayPasswordStateForgetNewNext  )
        {
            [_pView updateTitleLabel:@"请再次输入6位支付密码"];
        }
    }
    else
    {
        _pView.frame = rect;
    }
}


- (void)setMyNavigation
{
    
}

-(void)OnPushController:(NSInteger)nMsgType wParam:(id)wParam
{
    if ( nMsgType == 0 )
    {

        switch (self.payState)
        {
            case SafePayPasswordStateFirstSet:
            {
                YLSafePayPasswordController *pVc = [[YLSafePayPasswordController alloc] init];
                pVc.nsPassword = (NSString *)wParam;
                pVc.payState = SafePayPasswordStateFirstNext;
                [self.navigationController pushViewController:pVc animated:YES];
            }
                break;
            case SafePayPasswordStateFirstNext:
            {
                if ( [self.nsPassword isEqualToString:wParam] )
                {
                    YLSafeAuthenticationViewController *pVc = [[YLSafeAuthenticationViewController alloc] init];
                    pVc.nsPassword = (NSString *)wParam;
                    pVc.typeCard = 0;
                    [self.navigationController pushViewController:pVc animated:YES];
                }else
                {
                   [MBProgressHUD showMessageIsWait:@"两次输入密码不同" wait:YES];
                   [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
                break;
            case SafePayPasswordStateOld:
            {
                [self checkUserOldPayPwd:wParam];
            }
                break;
            case SafePayPasswordStateNew:
            {
                if ( [self.oldPassword isEqualToString:wParam] )
                {
                    [MBProgressHUD showMessageIsWait:@"新密码与原密码相同，请重新设置" wait:YES];
                    [_pView safePayPasswordClearAll];
                    return;
                }
                YLSafePayPasswordController *pVc = [[YLSafePayPasswordController alloc] init];
                pVc.oldPassword = self.oldPassword;
                pVc.nsPassword = (NSString *)wParam;
                pVc.payState = SafePayPasswordStateNewNext;
                [self.navigationController pushViewController:pVc animated:YES];
            }
                break;
            case SafePayPasswordStateNewNext:
            {
                if ( [self.nsPassword isEqualToString:wParam])
                {
                    [self newNextState];
                }
                else
                {
                    [MBProgressHUD showMessageIsWait:@"两次输入密码不同" wait:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
                break;
            case SafePayPasswordStateForgetNew:
            {
                YLSafePayPasswordController *pVc = [[YLSafePayPasswordController alloc] init];
                pVc.nsPassword = (NSString *)wParam;
                pVc.payState = SafePayPasswordStateForgetNewNext;
                [self.navigationController pushViewController:pVc animated:YES];
            }
                break;
            case SafePayPasswordStateForgetNewNext:{
                if ( [self.nsPassword isEqualToString:wParam])
                {
                    [self forgetPasswordNew];
                }
                else
                {
                    [MBProgressHUD showMessageIsWait:@"两次输入密码不同" wait:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
                break;
            default:
                break;
        }
    }else if ( nMsgType == 1 )
    {
        YLSafeAuthenticationViewController *pVc = [[YLSafeAuthenticationViewController alloc] init];
        pVc.typeCard = 2;
        [self.navigationController pushViewController:pVc animated:YES];
    }
}

#pragma mark -重置新密码
-(void)newNextState
{
    [YLSafeTool sendUserPayPwdUpdate:@{@"pay_pwd":self.oldPassword,
                                       @"new_pay_pwd":self.nsPassword,
                                       @"once_pay_pwd":self.nsPassword}
                             success:^{
        for(UIViewController *pVc in self.navigationController.viewControllers)
        {
            if ([pVc isKindOfClass:[PersonZLViewController class]])
            {
                [self.navigationController popToViewController:pVc animated:YES];
                break;
            }
        }
    } failure:^{
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
    }];
}

#pragma mark -忘记支付密码重置
-(void)forgetPasswordNew
{
    __weak typeof(self) weakSelf = self;
    [YLSafeTool sendUserPayPwdReset:@{@"pay_pwd":self.nsPassword,
                                      @"once_pay_pwd":self.nsPassword,
                                      @"payFlag":@"1"}
                            success:^{
        for(UIViewController *pVc in weakSelf.navigationController.viewControllers)
        {
            if ([pVc isKindOfClass:[PersonZLViewController class]])
            {
                [weakSelf.navigationController popToViewController:pVc animated:YES];
                break;
                
            }
        }
    } failure:^{
        NSInteger i = 0;
        for(UIViewController *pVc in weakSelf.navigationController.viewControllers)
        {
            i++;
            if ([pVc isKindOfClass:[PersonZLViewController class]])
            {
                break;
            }
        }
        [weakSelf.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i] animated:YES];
    }];
}

#pragma mark -验证旧的支付密码
-(void)checkUserOldPayPwd:(NSString *)oldPsw
{
    [YLSafeTool sendCheckUserOldPayPwd:@{@"pay_pwd":oldPsw}
                               success:^{
                                   dispatch_async(dispatch_get_main_queue(), ^
                                                  {
                                                      YLSafePayPasswordController *pVc = [[YLSafePayPasswordController alloc] init];
                                                      pVc.payState = SafePayPasswordStateNew;
                                                      pVc.oldPassword = oldPsw;
                                                      [self.navigationController pushViewController:pVc animated:YES];
                                                  });
    } failure:^{
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                            [_pView safePayPasswordClearAll];
                       });

    }];
}

@end
