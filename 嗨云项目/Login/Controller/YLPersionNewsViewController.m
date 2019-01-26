//
//  YLPersionNewsViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLPersionNewsViewController.h"
#import "HYLoginNewsAllView.h"
#import "HYLoginNewsPassView.h"
#import "HYLoginIntiveCodeView.h"
#import "HYLoginPhoneNumView.h"
#import "HYLoginPhoneAndPassView.h"
#import "HYLoginPhoneNumAndInviteCodeView.h"
#import "HYLoginIniteCodeAndPasswordView.h"

@interface YLPersionNewsViewController ()
{
    HYLoginNewsAllView              *_pView;
    HYLoginNewsPassView             *_pPassView;
    HYLoginIntiveCodeView           *_pIntiveView;
    HYLoginPhoneNumView             *_pPhoneNumView;
    HYLoginPhoneAndPassView         *_pPhonePassView;
    HYLoginPhoneNumAndInviteCodeView        *_pPhoneCodeView;
    HYLoginIniteCodeAndPasswordView         *_pCodePassView;
}

@end

@implementation YLPersionNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"完善个人信息";
    [self initsubview];
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
    CGRect rect = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
    switch (self.persionNewsType )
    {
        case HYNewsAll:
        {
            if ( _pView == nil )
            {
                _pView = [[HYLoginNewsAllView alloc] init];
                _pView.frame = rect;
                [self.view addSubview:_pView];
            }else
            {
                _pView.frame = rect;
            }
        }
            break;
        case HYNewsPassword:
        {
            if ( _pPassView == nil )
            {
                _pPassView = [[HYLoginNewsPassView alloc] init];
                _pPassView.frame = rect;
                [self.view addSubview:_pPassView];
            }else
            {
                _pPassView.frame = rect;
            }
        }
            break;
        case HYNewsInviteCode:
        {
            if ( _pIntiveView == nil )
            {
                _pIntiveView = [[HYLoginIntiveCodeView alloc] init];
                _pIntiveView.frame = rect;
                [self.view addSubview:_pIntiveView];
            }else
            {
                _pIntiveView.frame = rect;
            }
        }
            break;
        case HYNewsPhoneNum:
        {
            if ( _pPhoneNumView == nil )
            {
                _pPhoneNumView = [[HYLoginPhoneNumView alloc] init];
                _pPhoneNumView.frame = rect;
                [self.view addSubview:_pPhoneNumView];
            }else
            {
                _pPhoneNumView.frame = rect;
            }
        }
            break;
        case HYNewsPhoneNumAndPassword:
        {
            if ( _pPhonePassView == nil )
            {
                _pPhonePassView = [[HYLoginPhoneAndPassView alloc] init];
                _pPhonePassView.frame = rect;
                [self.view addSubview:_pPhonePassView];
            }else
            {
                _pPhonePassView.frame = rect;
            }
        }
            break;
        case HYNewsPhoneNumAndInviteCode:
        {
            if ( _pPhoneCodeView == nil )
            {
                _pPhoneCodeView = [[HYLoginPhoneNumAndInviteCodeView alloc] init];
                _pPhoneCodeView.frame = rect;
                [self.view addSubview:_pPhoneCodeView];
            }else
            {
                _pPhoneCodeView.frame = rect;
            }
        }
            break;
        case HYNewsIniteCodeAndPassword:
        {
            if ( _pCodePassView == nil )
            {
                _pCodePassView = [[HYLoginIniteCodeAndPasswordView alloc] init];
                _pCodePassView.frame = rect;
                [self.view addSubview:_pCodePassView];
            }else
            {
                _pCodePassView.frame = rect;
            }
        }
            break;
    
        default:
            break;
    }
}

@end
