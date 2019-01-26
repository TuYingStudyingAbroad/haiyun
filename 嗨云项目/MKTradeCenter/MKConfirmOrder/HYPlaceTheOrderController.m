//
//  HYPlaceTheOrderController.m
//  嗨云项目
//
//  Created by haiyun on 16/9/22.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYPlaceTheOrderController.h"
#import "MKPaymentView.h"
#import "UIView+MKExtension.h"
#import <PureLayout.h>
#import "AppDelegate.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKPaymentSuccessViewController.h"
#import "MKItemDetailViewController.h"
#import "MKConfirmOrderViewController.h"
#import "MKPasswordView.h"
#import "IQKeyboardManager.h"
#import "PersonZLViewController.h"
#import "UIImage+MKExtension.h"
#import "MKOrdersViewController.h"
#import "YLOrderDetailViewController.h"
#import "BaiduMobStat.h"
#import "MKSpecificOrderObject.h"
#import "HYPlaceTheOrderView.h"

@interface HYPlaceTheOrderController ()
{
    HYPlaceTheOrderView *_pView;
    UIButton        *_backBtn;
}

//余额
@property (nonatomic,assign)NSInteger blancePrice;
@property (nonatomic,strong)NSString *blanceExchangeRate;
//嗨币
@property (nonatomic,assign)NSInteger integralPrice;
@property (nonatomic,strong)NSString *integralExchangeRate;

//支付密码
@property (nonatomic,strong)NSString *payPassword;
//实名认证
@property (nonatomic,strong)NSString *authIdCard;

@property (nonatomic,assign)NSInteger authonStatus;

@property (nonatomic,strong)NSMutableArray *ayTableViewData;

@property (nonatomic,strong)NSMutableDictionary *topDict;
@end

@implementation HYPlaceTheOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
    [self initsubView];
    if ( _topDict == nil ) {
        _topDict = [[NSMutableDictionary alloc] init];
    }else{
        [_topDict removeAllObjects];
    }
    
    NSMutableArray *viewArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (NSInteger i = viewArr.count-1 ; i>=0; i--) {
        if ([viewArr[i] isKindOfClass:[MKConfirmOrderViewController class]]) {
            [viewArr removeObject:viewArr[i]];
            break;
        }
    }
    self.navigationController.viewControllers = viewArr;
    
    //生成topCell
    if (self.isHidenTime
        || ( self.orderObject && self.orderObject.orderType != 7) )
    {
        [_topDict setObject:@"1" forKey:@"orderType"];
        [_topDict setObject:HYNowTimeChangeToDate(self.time) forKey:@"orderTime"];
        [_topDict setObject:@"HYPayTopUITableViewCell" forKey:@"cell"];

    }else
    {
        [_topDict setObject:@"7" forKey:@"orderType"];
        [_topDict setObject:@"HYPayTopUITableViewCell" forKey:@"cell"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKPasswordSuccessfully:)
                                                 name:@"MKPasswordSuccessfully" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self updateDidSelect];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
#pragma mark -请求数据
- (void)MKPasswordSuccessfully:(NSNotificationCenter *)sender{
    [self updateDidSelect];
}
- (void)updateDidSelect
{
    if ( _ayTableViewData == nil ) {
        _ayTableViewData = [[NSMutableArray alloc] init];
    }else
    {
        [_ayTableViewData removeAllObjects];
    }
    [_ayTableViewData addObject:_topDict];
    //分割线
    [_ayTableViewData addObject:[NSMutableDictionary dictionaryWithObject:@"HMJSpaceCell" forKey:@"cell"]];
    //选择支付方式
    [_ayTableViewData addObject:[NSMutableDictionary dictionaryWithObject:@"HYPayWayUITableViewCell" forKey:@"cell"]];

    MBProgressHUD *hud                                                = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/marketing/wealth_account/list" paramters:nil
                      completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             [ hud hide:YES];
             return ;
         }
         NSArray *accouArray                                               = response.mkResponseData[@"wealth_account_list"];
         for (NSDictionary *dic in accouArray) {
             if ([dic[@"wealth_type"] integerValue] == 1) {
                 self.blancePrice                                                  = [dic[@"amount"] integerValue];
                 self.blanceExchangeRate                                           = dic[@"exchange_rate"];
             }
             if ([dic[@"wealth_type"] integerValue] == 3) {
                 self.integralPrice                                                = [dic[@"amount"] integerValue];
                 self.integralExchangeRate                                         = dic[@"exchange_rate"];
             }
         }
         
         [MKNetworking MKSeniorGetApi:@"/user/userSafeInfo/query" paramters:nil
                           completion:^(MKHttpResponse *response)
          {
              
              [ hud hide:YES];
              
              if (response.errorMsg != nil)
              {
                  [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                  return ;
              }
              NSDictionary *dic = response.mkResponseData;
              self.payPassword  = dic[@"payPassword"];
              self.authIdCard   = dic[@"authIdCard"];
              self.authonStatus = [dic[@"authonStatus"] integerValue];
              
             //不显示去实名认证的条件,1虚拟财富是空的 或者实名认证并且设置密码了
              if ( !(self.blancePrice == 0 && self.integralPrice == 0) )
              {
                  if ( !(self.authIdCard.length
                      && self.authonStatus == 1
                      && self.payPassword.length) )
                  {
                      
                  }
              }
              
              
              
              if( _pView )
              {
                  [_pView setMessageArr:_ayTableViewData];
              }
          }];
     }];
}


-(void)initsubView
{
    CGRect rect = CGRectMake(20.0f, 34.0f, 20.0f, 22.0f);
    if ( _backBtn == nil ) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = rect;
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImage:[UIImage imageNamed:@"arrow_back_white10x17"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"arrow_back_white10x17"] forState:UIControlStateSelected];
        [_backBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }else{
        _backBtn.frame = rect;
    }
    
    rect = CGRectMake(0, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    rect.size.height = self.view.frame.size.height - rect.origin.y;
    if ( _pView == nil)
    {
        _pView = NewObject(HYPlaceTheOrderView);
        _pView.frame = rect;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.frame = rect;
    }
    
    [self.view bringSubviewToFront:_backBtn];

}

-(void)OnButton:(id)sender
{
    if ( sender == _backBtn ) {
        [self payVCGoToWhere];
    }
}

#pragma mark -payVCGoToWhere
/**
 *  如果是从订单详情或者，订单列表去支付，回来的时候返回上一层，否则，订单列表
 */
-(void)payVCGoToWhere
{
    NSInteger types = self.navigationController.viewControllers.count-2;
    if ( types>=0 && types < self.navigationController.viewControllers.count )
    {
        if ( [self.navigationController.viewControllers[types] isKindOfClass:[MKOrdersViewController class]]
            || [self.navigationController.viewControllers[types] isKindOfClass:[YLOrderDetailViewController class]] )
        {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [appDelegate.mainTabBarViewController guideToOrderListStatus:MKOrderStatusUnpaid];
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
