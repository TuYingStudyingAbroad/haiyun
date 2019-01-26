//
//  HYAccounSafeViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYAccounSafeViewController.h"
#import "HYAcountSafeView.h"
#import "YLSafeBandViewController.h"
#import "YLSafeLoginPasswordViewController.h"
#import "YLSafePayPasswordController.h"
#import "YLSafeAlreadyCardController.h"
#import "YLSafeBandCardViewController.h"
#import "YLSafeTool.h"
#import "YLSafeUserInfo.h"
#import "HYMainNotDataView.h"
#import <UIAlertView+Blocks.h>

@interface HYAccounSafeViewController ()<HYAcountSafeViewDelegate,HYMainNotDataViewDelegate>
{
    HYAcountSafeView        *_pSafeView;
    YLSafeUserInfo          *_pSafeInfo;
    
    HYMainNotDataView       *_mainNotDataView;
}

@end

@implementation HYAccounSafeViewController

-(void)dealloc
{
    _pSafeView.delegate = nil;
    _mainNotDataView.delegate = nil;
    _mainNotDataView = nil;
    _pSafeView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账户安全";
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
    [self initsubView];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if( _pSafeView )
    {
        [self OnRequest];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void) initsubView
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if (_pSafeView == nil)
    {
        _pSafeView = NewObject(HYAcountSafeView);
        _pSafeView.frame = rect;
        _pSafeView.delegate = self;
        _pSafeView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_pSafeView];
    }
    else
    {
        _pSafeView.frame = rect;
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
-(void)showSafeView:(HYAcountSafeView *)safeView InfoType:(NSInteger)type
{
    if ( safeView == _pSafeView )
    {
        switch (type)
        {
            case 0://绑定手机号码
            {
                YLSafeBandViewController *pVc = [[YLSafeBandViewController alloc] init];
                if ( _pSafeInfo && _pSafeInfo.mobile )
                {
                    pVc.nsPhoneNum = _pSafeInfo.mobile;
                    pVc.nsPhoneType = 1;
                    pVc.nsIsCard = ![self isAuthIdCardRealler];
                }
                else
                {
                    pVc.nsPhoneNum = nil;
                    pVc.nsPhoneType = 0;
                    pVc.nsIsCard = YES;
                }
                [self.navigationController pushViewController:pVc animated:YES];
            }
                break;
             case 1://设置密码
            {
                if ( ![self isBandPhoneNum] )
                {
                    [self notBandPhoneNum];
                    return;
                }
                YLSafeLoginPasswordViewController *pVc = [[YLSafeLoginPasswordViewController alloc] init];
                if ( _pSafeInfo && ISNSStringValid(_pSafeInfo.password) && ISNSStringValid(_pSafeInfo.mobile))
                {
                    pVc.nsPhoneNum = _pSafeInfo.mobile;
                    pVc.nsIsChange = YES;
                }else
                {
                    pVc.nsPhoneNum = _pSafeInfo.mobile;
                    pVc.nsIsChange = NO;

                }
                [self.navigationController pushViewController:pVc animated:YES];
            }
                break;
            case 2://支付密码
            {
                if ( ![self isBandPhoneNum] )
                {
                    [self notBandPhoneNum];
                    return;
                }
                if ( ![self isSeller] )
                {
                    [self notSetSeller:@"只有开通店铺的店主才需设置支付密码"];
                    return;
                }
                if ( ![self isAuthIdCardRealler] )
                {
                    [self notAuthIdCardRealler];
                    return;
                }
                if ( _pSafeInfo && ISNSStringValid(_pSafeInfo.authIdCard) && ISNSStringValid(_pSafeInfo.authName)  )
                {
                    YLSafePayPasswordController *pVc = [[YLSafePayPasswordController alloc] init];
                    if ( _pSafeInfo && ISNSStringValid(_pSafeInfo.payPassword) )
                    {
                        pVc.payState = SafePayPasswordStateOld;
                    }else
                    {
                        pVc.payState = SafePayPasswordStateFirstSet;
                    }
                    [self.navigationController pushViewController:pVc animated:YES];
                    
                }
                else
                {
                   [self notAuthIdCardRealler];
                }
            }
                break;
            case 3:
            {
                if ( ![self isBandPhoneNum] )
                {
                    [self notBandPhoneNum];
                    return;
                }
                if ( ![self isSeller] )
                {
                    [self notSetSeller:@"只有开通店铺的店主才需进行实名认证"];
                    return;
                }
                if ( _pSafeInfo && ISNSStringValid(_pSafeInfo.authIdCard) && ISNSStringValid(_pSafeInfo.authName)  )
                {
                    YLSafeAlreadyCardController *pVc = [[YLSafeAlreadyCardController alloc] init];
                    pVc.name = _pSafeInfo.authName;
                    pVc.cardId = _pSafeInfo.authIdCard;
                    [self.navigationController pushViewController:pVc animated:YES];
                }else
                {
                    YLSafeBandCardViewController *pVc = [[YLSafeBandCardViewController alloc] init];
                    [self.navigationController pushViewController:pVc animated:YES];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark -判断是否绑定手机
-(BOOL)isBandPhoneNum
{
    if ( _pSafeInfo && ISNSStringValid(_pSafeInfo.mobile) )
    {
        return YES;
    }
    return NO;
}
#pragma mark -判断是否是卖家
-(BOOL)isSeller
{
    if ( _pSafeInfo
        && [_pSafeInfo.roleMark integerValue] == 2 )
    {
        return YES;
    }
    return NO;
}
#pragma mark -判断是否使命认证
-(BOOL)isAuthIdCardRealler
{
    if ( _pSafeInfo
        && ISNSStringValid(_pSafeInfo.authIdCard)
        && ISNSStringValid(_pSafeInfo.authName)  )
    {
        return YES;
    }
    return NO;
}
#pragma mark -未实名认证
-(void)notAuthIdCardRealler
{
    __weak typeof(self) weakSelf = self;
    [UIAlertView showWithTitle:@"提示"
                       message:@"未实名认证，是否去实名认证？"
             cancelButtonTitle:@"取消"
             otherButtonTitles:@[@"确定"]
                      tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                          if ( buttonIndex == 1  )
                          {
                              YLSafeBandCardViewController *pVc = [[YLSafeBandCardViewController alloc] init];
                              [weakSelf.navigationController pushViewController:pVc animated:YES];
                          }

    }];
}

#pragma mark -未绑定手机号码
-(void)notBandPhoneNum
{
    __weak typeof(self) weakSelf = self;
    [UIAlertView showWithTitle:@"提示"
                       message:@"未绑定手机号码，是否去绑定手机号码？"
             cancelButtonTitle:@"取消"
             otherButtonTitles:@[@"确定"]
                      tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                          if ( buttonIndex == 1  )
                          {
                              YLSafeBandViewController *pVc = [[YLSafeBandViewController alloc] init];
                              pVc.nsPhoneNum = nil;
                              pVc.nsIsCard = YES;
                              pVc.nsPhoneType = 0;
                              [weakSelf.navigationController pushViewController:pVc animated:YES];
                          }
                          
                      }];
}
#pragma mark -未开店铺
-(void)notSetSeller:(NSString *)message
{
    [UIAlertView showWithTitle:@"提示"
                       message:message
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                          
                      }];

}
#pragma mark -网络请求
-(void)OnRequest
{
    __weak typeof(self) weakSelf = self;
    [YLSafeTool sendUserSafeInfoQuerySuccess:^(id nMsg)
    {
        _mainNotDataView.hidden = YES;
        [weakSelf safeToolShow:nMsg];
    } failure:^{
        _mainNotDataView.hidden = NO;
    }];
}
-(void)safeToolShow:(YLSafeUserInfo *)userInfo
{
    _pSafeInfo = userInfo;
    if ( _pSafeView )
    {
        [_pSafeView sentSafeView:_pSafeInfo];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
