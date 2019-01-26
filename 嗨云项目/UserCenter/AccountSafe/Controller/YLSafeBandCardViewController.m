//
//  YLSafeBandCardViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeBandCardViewController.h"
#import "HYSafeBandCardView.h"
#import "HYActionSheetViewController.h"
#import "YLSafeTool.h"
#import "PersonZLViewController.h"
#import "HYSafeBandInfo.h"
#import "YLSafeAlreadyView.h"
#import "HYMainNotDataView.h"

@interface YLSafeBandCardViewController ()<HYBaseViewDelegate,HYMainNotDataViewDelegate>
{
    HYSafeBandCardView *_pView;
    
    HYSafeNoCardView   *_p1View;
    
    HYSafeBandInfo  *_safeInfo;
    
    HYMainNotDataView        *_mainNotDataView;

}

@end

@implementation YLSafeBandCardViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实名认证";
//    self.types = 1;
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
    [self initsubView];
    if ( self.types != 1 )
    {
        [self OnRequest];

    }else
    {
        [self setMyNavigation];
    }
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

-(void)initsubView
{
    CGRect rect = CGRectMake(0, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    rect.size.height = self.view.frame.size.height - rect.origin.y;
    if ( _pView == nil)
    {
        _pView = NewObject(HYSafeBandCardView);
        _pView.frame = rect;
        _pView.baseDelegate = self;
        _pView.hidden = YES;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.hidden = YES;
        _pView.frame = rect;
    }
    if ( _p1View == nil)
    {
        _p1View = NewObject(HYSafeNoCardView);
        _p1View.isReject = YES;
        _p1View.name = @"";
        _p1View.cardId = @"4**************12";
        _p1View.frame = rect;
        _p1View.hidden = YES;
        [self.view addSubview:_p1View];
    }
    else
    {
        _p1View.hidden = YES;
        _p1View.frame = rect;
    }
    if ( self.types == 1 ) {
        _pView.hidden = NO;
    }
    if ( _mainNotDataView == nil )
    {
        _mainNotDataView = NewObject(HYMainNotDataView);
        _mainNotDataView.frame = rect;
        _mainNotDataView.hidden = YES;
        _mainNotDataView.delegate = self;
        [self.view addSubview:_mainNotDataView];
    }else
    {
        _mainNotDataView.frame = rect;
    }
    [self.view bringSubviewToFront:_mainNotDataView];

    
}


- (void)setMyNavigation
{
    if ( self.types == 1 && self.isCome )
    {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"AllBack" highlightedIcon:@"AllBack" target:self action:@selector(leftBarButton)];
    }
    
    if ( self.types == 1 && !_safeInfo )
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithMJTitle:@"提交" target:self action:@selector(rightButton)];
        
    }
    else
    {
        if ( _safeInfo )
        {
            // 完成
            if ( [_safeInfo.authonStatus integerValue] == 0 )
            {
                self.navigationItem.rightBarButtonItem = nil;
            }
            else if( [_safeInfo.authonStatus integerValue] == 2  )
            {
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithMJTitle:@"重新提交" target:self action:@selector(rightButton)];
            }else
            {
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithMJTitle:@"提交" target:self action:@selector(rightButton)];
            }
        }
    }
    
    
}

#pragma mark -点击right按钮
-(void)rightButton
{
    if ( self.types == 1 && !_safeInfo )
    {
        if ( _pView )
        {
            [_pView onButtonClickRight];
        }
    }
    else
    {
        if ( _safeInfo ) {
            // 完成
            if ( [_safeInfo.authonStatus integerValue] == 0 )
            {
                self.navigationItem.rightBarButtonItem = nil;
            }
            else if( [_safeInfo.authonStatus integerValue] == 2  )
            {
                YLSafeBandCardViewController *pVc = [[YLSafeBandCardViewController alloc] init];
                pVc.types = 1;
                pVc.isCome = YES;
                [self.navigationController pushViewController:pVc animated:YES];
            }else
            {
                [_pView onButtonClickRight];
            }
        }
    }
    
}

#pragma mark -点击left按钮
-(void)leftBarButton
{
    if ( _safeInfo && [_safeInfo.authonStatus integerValue] == 0 )
    {
        for(UIViewController *pVc in self.navigationController.viewControllers)
        {
            if ([pVc isKindOfClass:[PersonZLViewController class]])
            {
                [self.navigationController popToViewController:pVc animated:YES];
                return;
            }
        }
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -pop
-(void)OnPushController:(NSInteger)nMsgType wParam:(id)wParam
{
    if ( nMsgType == 0 )
    {
        if ( self.types == 1 )
        {
           
            [self OnRequest];
        }
    }
    
}

#pragma mark -网络请求，刷新数据
-(void)OnRequest
{

    [YLSafeTool sendUserAuthonAuditing:nil
                               success:^(id nMsg) {
                                   if ( nMsg )
                                   {
                                       [self updateSafeView:nMsg];
                                   }
    } failure:^{
        _mainNotDataView.hidden = NO;
    }];
}

-(void)updateSafeView:(HYSafeBandInfo *)safes
{
    _safeInfo = safes;
    if ( _safeInfo ) {
        if ( [_safeInfo.authonStatus integerValue] == 0
            || [_safeInfo.authonStatus integerValue] == 2 ) {
            _p1View.hidden = NO;
            _pView.hidden = YES;
            [_p1View updateMessage:_safeInfo];
        }else if ( [_safeInfo.authonStatus integerValue] == 1 )
        {
            _pView.hidden = NO;
            _p1View.hidden = YES;
        }
        [self setMyNavigation];
    }
}

#pragma mark -HYMainNotDataViewDelegate
-(void)reloadDataView:(HYMainNotDataView *)noView
{
    if ( noView == _mainNotDataView )
    {
        [self OnRequest];
    }
}

@end
