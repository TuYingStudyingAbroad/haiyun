//
//  MKPlaceTheOrderController.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKPlaceTheOrderController.h"
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

@interface MKPlaceTheOrderController ()<UITextViewDelegate>
//1余额，2嗨币，3支付宝，4连连，5微信
@property (nonatomic,assign)NSInteger isChoose;
//剩余时间
@property (weak, nonatomic) IBOutlet UILabel *remainingTime;
//余额显示
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//积分显示
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;

//支付方式的选择
@property (nonatomic,strong)IBOutletCollection(UIButton) NSMutableArray * seleBut;

@property (nonatomic,strong)MKPaymentView *playView;
@property (weak, nonatomic) IBOutlet UITableViewCell *balanceCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *integralCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *certificationCell;

@property (nonatomic,assign)NSInteger blancePrice;
@property (nonatomic,strong)NSString *blanceExchangeRate;
@property (nonatomic,assign)NSInteger integralPrice;
@property (nonatomic,strong)NSString *integralExchangeRate;

@property (nonatomic,strong)NSTimer * timer;


@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)MKPasswordView *passWordk;


@property (nonatomic,strong)UIView * backView;


@property (nonatomic,strong)NSString *password;
@property (nonatomic,assign)BOOL isInvalidate;



@property (weak, nonatomic) IBOutlet UILabel *orderOutTime;
@property (nonatomic,strong)NSString *payPassword;

@property (nonatomic,strong)NSString *authIdCard;

@property (nonatomic,assign)NSInteger authonStatus;

@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;
//支付方式的显示
@property (strong, nonatomic) NSMutableDictionary *payWayDict;

@property (nonatomic,assign)BOOL isHidenInter;

@end

@implementation MKPlaceTheOrderController


- (IBAction)backHom:(id)sender
{
    //       [getUserCenter loginout];
    [self payVCGoToWhere];
    
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    self.backView.hidden                                              = YES;
    self.textField.text                                               = @"";
    [self handleAction:self.textField];
    [self.textField resignFirstResponder];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    self.playView.hidden                                              = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.textField.text                                               = @"";
    [self handleAction:self.textField];
    [self.textField resignFirstResponder];
    self.isInvalidate                                                 = NO;
    //
    
    if (self.playView) {
        self.playView.hidden                                              = NO;
    }
    [self updateDidSelect];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"支付界面"];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.playView.hidden                                              = YES;
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"支付界面"];
}
- (void)dealloc{
    [_timer invalidate];
    _timer                                                            = nil;
}

#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.backView = [[UIView alloc]initWithFrame:appDelegate.window.bounds];
   
    self.backView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    NSMutableArray *viewArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (NSInteger i = viewArr.count-1 ; i>=0; i--) {
        if ([viewArr[i] isKindOfClass:[MKConfirmOrderViewController class]]) {
            [viewArr removeObject:viewArr[i]];
            break;
        }
    }
    self.navigationController.viewControllers = viewArr;
    for (UIButton *but in self.seleBut) {
        but.userInteractionEnabled                = NO;
    }
    
    if (self.isHidenTime || ( self.orderObject && self.orderObject.orderType != 7)) {
        self.remainingLabel.hidden = NO;
        self.orderOutTime.hidden   = NO;
        self.timer                 = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(daojishi:) userInfo:HYNSStringChangeToDate(HYNowTimeChangeToDate(self.time)) repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [self daojishi:_timer];
    }else{
        self.remainingTime.text    = @"开店礼包订单";
        self.remainingLabel.hidden = YES;
        self.orderOutTime.hidden   = YES;
        self.certificationCell.hidden = YES;
    }
    self.isChoose                          = 0;
//    [self.seleBut[2] setImage:[UIImage imageNamed:@"selected_cycle"] forState:(UIControlStateNormal)];
    if ( _payWayDict == nil )
    {
        _payWayDict = [[NSMutableDictionary alloc] init];
    }else
    {
        [_payWayDict removeAllObjects];
//        [_payWayDict addEntriesFromDictionary:@{@"ali_pay":@"支付宝支付",@"lian_lian_pay":@"连连支付",@"wx_pay":@"微信支付"}];
    }
    self.playView                          = [MKPaymentView loadFromXib];
    self.playView.frame                    = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- 60, [UIScreen mainScreen].bounds.size.width, 60);
    [self.view addSubview:self.playView];
    [self.playView.priceBut addTarget:self action:@selector(handlePaymentAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.playView.priceBut.enabled         = self.isChoose?YES:NO;
    self.playView.priceBut.backgroundColor = [UIColor colorWithHex:self.isChoose?0xff4b55:0xcccccc];
    self.playView.placeLabel.text          = self.totalPrice;
    [self.playView.placeLabel HYPriceChangeFont:9.0f colors:kHEXCOLOR(0xff3333) isTop:NO];

    self.backView                          = [[UIView alloc]initWithFrame:appDelegate.window.bounds];
    
    _backView.backgroundColor              = [UIColor colorWithWhite:0.8 alpha:.2];
    self.backView.hidden                   = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    self.textField                         = [[UITextField alloc]init];
    [self.backView addSubview:self.textField];
    self.passWordk                         = [MKPasswordView loadFromXib];
    [self.passWordk.quXiao addTarget:self action:@selector(handleActionQuxiao:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.passWordk.notPassWork addTarget:self action:@selector(handleActioNotPassWork:) forControlEvents:(UIControlEventTouchUpInside)];
    self.textField.inputAccessoryView      = self.passWordk;
    [self.textField addTarget:self action:@selector(handleAction:) forControlEvents:(UIControlEventEditingChanged)];
    self.textField.keyboardType            = UIKeyboardTypeNumberPad;
//    [self updateDidSelect];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKPasswordSuccessfully:)
                                                 name:@"MKPasswordSuccessfully" object:nil];
    if (self.orderObject.distributorOrderItem.count == 1) {
        MKDistributorOrderItemList *ojec =self.orderObject.distributorOrderItem.firstObject;
        MKOrderItemObject *obj = ojec.orderItemList.lastObject;
        if (obj.itemType == 13) {
            _isHidenInter = YES;
        }
    }
    
    if (self.orderObject.orderItems.count == 1) {
        MKSpecificOrderObject *obj =self.orderObject.orderItems.firstObject;
        if (obj.itemType == 13) {
            _isHidenInter = YES;
        }
    }
        self.integralCell.hidden = _isHidenInter;
}
#pragma mark -获取网络数据
- (void)MKPasswordSuccessfully:(NSNotificationCenter *)sender{
    [self updateDidSelect];
}
- (void)updateDidSelect{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    //1余额，2嗨币，3支付宝，4连连，5微信
    [MKNetworking MKSeniorGetApi:@"/trade/payment/method/get"
                       paramters:nil
                      completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             [ hud hide:YES];
             return;
         }
         
         [self.payWayDict removeAllObjects];
         NSInteger payChange = INT_MAX;
         for( NSDictionary *dics in response.mkResponseData[@"trade_payment_config"] )
         {
             [self.payWayDict setObject:dics[@"payment_name"] forKey:dics[@"payment_key"]];
             if ( [dics[@"sort"] integerValue]<payChange )
             {
                 if ( [dics[@"payment_key"] isEqualToString:@"ali_pay"])
                 {
                     payChange = [dics[@"sort"] integerValue];
                     self.isChoose = 3;
                 }else if ( [dics[@"payment_key"] isEqualToString:@"lian_lian_pay"])
                 {
                     payChange = [dics[@"sort"] integerValue];
                     self.isChoose = 4;
                 }else if ( [dics[@"payment_key"] isEqualToString:@"wx_pay"])
                 {
                     payChange = [dics[@"sort"] integerValue];
                     self.isChoose = 5;
                 }
             }
         }
         if ( self.isChoose>0 && self.isChoose <= self.seleBut.count )
         {
             [self.seleBut[self.isChoose-1] setImage:[UIImage imageNamed:@"selected_cycle"] forState:(UIControlStateNormal)];
             self.playView.priceBut.enabled         = self.isChoose?YES:NO;
             self.playView.priceBut.backgroundColor = [UIColor colorWithHex:self.isChoose?0xff4b55:0xcccccc];
         }
         [MKNetworking MKSeniorGetApi:@"/marketing/wealth_account/list" paramters:nil
                           completion:^(MKHttpResponse *response)
          {
              if (response.errorMsg != nil)
              {
                  [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                  [ hud hide:YES];
                  self.blancePrice = 0;
                  self.integralPrice = 0;
                  [self.tableView reloadData];
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
                       self.blancePrice = 0;
                       self.integralPrice = 0;
                       [self.tableView reloadData];
                       return ;
                   }
                   NSDictionary *dic = response.mkResponseData;
                   self.payPassword  = dic[@"payPassword"];
                   self.authIdCard   = dic[@"authIdCard"];
                   self.authonStatus = [dic[@"authonStatus"] integerValue];
                   self.balanceCell.backgroundColor = [UIColor colorWithHex:0xEEEFF1];
                   self.integralCell.backgroundColor = [UIColor colorWithHex:0xEEEFF1];
                   if ( self.authIdCard.length && self.authonStatus == 1 )
                   {
                       
                       if ( self.payPassword.length )
                       {
                           if (self.blancePrice/self.blanceExchangeRate.doubleValue < self.totalPrice.doubleValue * 100)
                           {
                               self.balanceLabel.text =[NSString stringWithFormat:@"余额不足"];
                               [self.seleBut[0] setImage:[[UIImage imageNamed:@"selected_cycle"] imageWithTintColor:[UIColor colorWithHex:0xcccccc]] forState:(UIControlStateNormal)];
                           }else
                           {
                               self.balanceLabel.text =[NSString stringWithFormat:@"可使用余额%@元",[MKBaseItemObject priceString:self.blancePrice]];
                           }
                           if (self.integralPrice < self.totalPrice.doubleValue*100 ) {
                               self.integralLabel.text =[NSString stringWithFormat:@"嗨币不足"];
                               [self.seleBut[1] setImage:[[UIImage imageNamed:@"selected_cycle"] imageWithTintColor:[UIColor colorWithHex:0xcccccc]] forState:(UIControlStateNormal)];
                           }else
                           {
                               self.integralLabel.text =[NSString stringWithFormat:@"可使用%ld嗨币",self.integralPrice];
                           }
                       }else
                       {
                           self.passLabel.text = @"尚未设置支付密码无法使用余额和嗨币支付";
                           self.workLabel.text = @"去设置";
                           self.balanceLabel.text =[NSString stringWithFormat:@"请先设置支付密码"] ;
                           self.integralLabel.text =[NSString stringWithFormat:@"请先设置支付密码"];
                           [self.seleBut[0] setImage:[[UIImage imageNamed:@"selected_cycle"] imageWithTintColor:[UIColor colorWithHex:0xcccccc]] forState:(UIControlStateNormal)];
                           [self.seleBut[1] setImage:[[UIImage imageNamed:@"selected_cycle"] imageWithTintColor:[UIColor colorWithHex:0xcccccc]] forState:(UIControlStateNormal)];
                       }
                   }
                   else
                   {
                       self.passLabel.text = @"尚未设置实名认证无法使用余额和嗨币支付";
                       self.workLabel.text = @"去认证";
                       self.balanceLabel.text =[NSString stringWithFormat:@"请先实名认证"] ;
                       self.integralLabel.text =[NSString stringWithFormat:@"请先实名认证"];
                       [self.seleBut[0] setImage:[[UIImage imageNamed:@"selected_cycle"] imageWithTintColor:[UIColor colorWithHex:0xcccccc]] forState:(UIControlStateNormal)];
                       [self.seleBut[1] setImage:[[UIImage imageNamed:@"selected_cycle"] imageWithTintColor:[UIColor colorWithHex:0xcccccc]] forState:(UIControlStateNormal)];
                   }
                   [self.tableView reloadData];
               }];
          }];
    }];
    
}


- (void)daojishi:(NSTimer *)timer
{
    //![self.navigationController.viewControllers containsObject:self]
    if ( self.navigationController == nil )
    {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    NSDate * date = (NSDate *)[timer userInfo];
    
    if ( [date compare:HYDateChangeToDate([NSDate date])] == kCFCompareLessThan )
    {
        self.remainingTime.text =[NSString stringWithFormat:@"00:00:00"];
        [_timer invalidate];
        _timer = nil;
        //        [MBProgressHUD showMessageIsWait:@"订单已取消" wait:YES];
        self.playView.priceBut.enabled                                    = NO;
        self.playView.priceBut.backgroundColor                            = [UIColor colorWithHex:0xcccccc];
        self.orderOutTime.text                                            = @"订单已超时，请重新下单!";
    }
    else
    {
        NSTimeInterval secondBetweenDates = [date timeIntervalSinceDate:HYDateChangeToDate([NSDate date])];
        NSInteger day = fabs(secondBetweenDates/(60*60*24));
        NSString *dayStr = day>9?[NSString stringWithFormat:@"%ld",(long)day]:[NSString stringWithFormat:@"0%ld",(long)day];
        
        NSInteger timeShow = labs((NSInteger)secondBetweenDates%(60*60*24));
        NSInteger hour = labs(timeShow/3600);
        NSString *hourStr = hour>9?[NSString stringWithFormat:@"%ld",(long)hour]:[NSString stringWithFormat:@"0%ld",(long)hour];
        
        NSInteger temp = labs((NSInteger)timeShow%3600);
        NSInteger minute =labs(temp/60);
        NSString *minuteStr = minute>9?[NSString stringWithFormat:@"%ld",(long)minute]:[NSString stringWithFormat:@"0%ld",(long)minute];
        
        NSInteger second =labs(temp%60);
        NSString *secondStr = second>9?[NSString stringWithFormat:@"%ld",(long)second]:[NSString stringWithFormat:@"0%ld",(long)second];
        
        
        NSInteger hourT= [dayStr integerValue]*24 + [hourStr integerValue];
        NSString *hourTStr = hourT>9?[NSString stringWithFormat:@"%ld",(long)hourT]:[NSString stringWithFormat:@"0%ld",(long)hourT];
        self.remainingTime.text =[NSString stringWithFormat:@"%@:%@:%@",hourTStr,minuteStr,secondStr];
    }
    
    
}

#pragma mark-点击支付
//1余额，2嗨币，3支付宝，4连连，5微信
- (void)handlePaymentAction:(UIButton *)button{
    NSInteger paymentId                                               = 0 ;
    if (self.isChoose == 1) {
        paymentId                                                         = 11;
    }
    if (self.isChoose == 2) {
        paymentId                                                         = 12;
    }
    if (self.isChoose == 4) {
        paymentId                                                         = 13;
    }
    if (self.isChoose == 3) {
        paymentId                                                         = 1;
    }
    if (self.isChoose == 5) {
        paymentId                                                         = 2;
    }
    if (paymentId == 2 && ![WXApi isWXAppInstalled]) {
        [MBProgressHUD showMessageIsWait:@"请先安装微信客户端" wait:YES];
        return;
    }
    
    if (paymentId == 11 || paymentId == 12) {
        [self updateSubYue:paymentId];
        return;
    }
    [self updateSub:paymentId];
    
}
- (void)updateSubYue:(NSInteger)paymentId{
    self.backView.hidden                                              = NO;
    
    [self.textField becomeFirstResponder];
}
- (void)updateSub:(NSInteger )paymentId{
    MBProgressHUD *hud                                                = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorPostApi:@"/trade/order/pay_type/update" paramters:@{@"order_uid" : self.orderUid, @"payment_id" : @(paymentId)}
                       completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         [self executePay:self.orderUid withPaymentId:paymentId];
     }];
}
- (void)executePay:(NSString *)orderUid withPaymentId:(NSInteger)paymentId
{
    [MKNetworking MKSeniorGetApi:@"/trade/order/payment_url/get" paramters:@{@"order_uid" : orderUid, @"pay_type" : @(paymentId)}
                      completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
        
         NSInteger payType                                                 = [response.mkResponseData[@"pay_type"] integerValue];
         NSInteger payAmount                                               = [response.mkResponseData[@"pay_amount"] integerValue];
         [self payWithType:payType andParams:[response mkResponseData][@"params"] andOrderUid:orderUid andAmount:payAmount];
     }];
}
- (void)payWithType:(NSInteger)type andParams:(NSDictionary *)params andOrderUid:(NSString *)orderUid andAmount:(NSInteger)amount
{
    switch (type)
    {
        case 1:
        {
            NSString *pays                                                    = params[@"param"];
            [MKPayKit alipayWithInfo:pays complete:^(MKPayResult result)
             {
                 [self dealWithPayResult:result andOrderUid:orderUid andAmount:amount];
             }];
            break;
        }
        case 2:
        {
            PayReq *req                                                       = [[PayReq alloc] init];
            req.partnerId                                                     = params[@"partnerid"];
            req.prepayId                                                      = params[@"prepayid"];
            req.nonceStr                                                      = params[@"noncestr"];
            req.timeStamp                                                     = [params[@"timestamp"] unsignedIntValue];
            req.package                                                       = params[@"package"];
            req.sign                                                          = params[@"sign"];
            [MKPayKit weChatPayWithReq:req complete:^(MKPayResult result)
             {
                 [self dealWithPayResult:result andOrderUid:orderUid andAmount:amount];
             }];
            break;
        }
        case 3:
        {
            NSString *tn                                                      = params[@"tn"];
            [MKPayKit upPayWithTn:tn withController:self complete:^(MKPayResult result)
             {
                 [self dealWithPayResult:result andOrderUid:orderUid andAmount:amount];
             }];
            break;
        }
        case 13:
        {
            [MKPayKit upPayWithLL:params withController:self complete:^(MKPayResult result)
            {
                [self dealWithPayResult:result andOrderUid:orderUid andAmount:amount];
            }];
            break;
        }
        default:
            break;
    }
}
- (void)dealWithPayResult:(MKPayResult)result andOrderUid:(NSString *)orderUid andAmount:(NSInteger)amount
{
    if (result == MKPayResultSuccess)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:MKOrderStatusChangedNotification object:nil];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(MKPlaceTheOrderResults:withOrderUid:)]) {
            [self.navigationController popViewControllerAnimated:YES];
            self.playView.hidden   = YES;
            [self.delegate MKPlaceTheOrderResults:result withOrderUid:orderUid];
            return;
        }
        if ( self.orderObject && self.orderObject.orderType == 7)
        {
//            [getMainTabBar changeTabar];
            for(UIViewController *pVc in self.navigationController.viewControllers)
            {
                if ([pVc isKindOfClass:[MKOrdersViewController class]])
                {
                    MKOrdersViewController *orderVc = (MKOrdersViewController *)pVc;
                    [orderVc changePageColtrol:MKOrderStatusPaid];
                    [self.navigationController popToViewController:pVc animated:YES];
                    return;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate.mainTabBarViewController guideToOrderListStatus:MKOrderStatusPaid];
            });
            return;
        }
        MKPaymentSuccessViewController *succe = [MKPaymentSuccessViewController create];
        succe.couponObject                    = self.couponObject;
        succe.consigneeItem                   = self.consigneeItem;
        succe.orderItemSource                 = self.orderItemSource;
        succe.orderUid                        = self.orderUid;
        succe.orderSn                         = self.orderSn;
        succe.payType                         = self.isChoose;
        succe.payAmount                       = self.playView.placeLabel.text.doubleValue * 100;
        [self.navigationController pushViewController:succe animated:YES];
        return;
    }else
    {
        [self payVCGoToWhere];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleActionQuxiao:(UIButton *)sender{
    self.backView.hidden                                              = YES;
    self.textField.text                                               = @"";
    [self handleAction:self.textField];
    [self.textField resignFirstResponder];
}
- (void)handleActioNotPassWork:(UIButton *)sender{
    //忘记支付密码
    PersonZLViewController *accoun                                = [[PersonZLViewController alloc]init];
    self.isInvalidate                                                 = YES;
    [self.navigationController pushViewController:accoun  animated:YES];
}
- (void)handleAction:(UITextField *)textField
{
    if (textField.text.length > 6) {
        textField.text                                                    = self.password;
        return;
    }
    self.password                                                     = textField.text;
    for (NSInteger i                                                  = 0;i< self.passWordk.passLable.count;i ++  ) {
        if (i<self.password.length) {
            UILabel *la                                                       = self.passWordk.passLable[i];
            la.text                                                           = @"·";
        }else{
            UILabel *la                                                       = self.passWordk.passLable[i];
            la.text                                                           = @"";
        }
    }
    if (textField.text.length == 6) {
        [self verifyPassword];
    }
}
#pragma mark -验证支付密码
- (void)verifyPassword{
    //验证支付密码
    NSInteger pay                                                     = 0;
    if (self.isChoose == 1) {
        pay                                                               = 11;
    }
    if (self.isChoose == 2) {
        pay                                                               = 12;
    }
    MBProgressHUD *hub                                                = [MBProgressHUD showHUDAddedTo:UIAppWindowTopView animated:YES];
    [MKNetworking MKSeniorPostApi:@"/trade/order/pay" paramters:@{@"order_uid" :self.orderUid, @"pay_type" : @(pay),@"pay_password":self.password}
                       completion:^(MKHttpResponse *response)
     {
         [hub hide:YES];
         self.backView.hidden                                              = YES;
         self.textField.text                                               = @"";
         [self handleAction:self.textField];
         [self.textField resignFirstResponder];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         if (pay ==11 && response.responseCode == 10000) {
             
             [self dealWithPayResult:MKPayResultSuccess andOrderUid:self.orderUid andAmount:self.totalPrice.floatValue];
             return;
         }
         if (pay ==12  && response.responseCode == 10000) {
             
             [self dealWithPayResult:MKPayResultSuccess andOrderUid:self.orderUid andAmount:self.totalPrice.floatValue];
             return;
         }
     }];
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//8连连支付,7支付宝,9微信
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 6 || indexPath.row == 1 || indexPath.row == 10) {
        return;
    }
    if (indexPath.row == 3) {
        PersonZLViewController *accoun                                = [[PersonZLViewController alloc]init];
        self.isInvalidate                                                 = YES;
        [self.navigationController pushViewController:accoun  animated:YES];
    }
    if (indexPath.row == 4 ) {
        if (!(self.payPassword.length && self.authIdCard.length
            && self.authonStatus == 1) ) {
            return;
        }
        if (self.blancePrice/self.blanceExchangeRate.doubleValue < self.totalPrice.doubleValue * 100) {
            return;
        }
        self.isChoose                   = indexPath.row -3;
    }
    if (indexPath.row == 5 ) {
        if (!(self.payPassword.length && self.authIdCard.length
              && self.authonStatus == 1)) {
            return;
        }
        if (self.integralPrice < self.totalPrice.floatValue * 100 ) {
            return;
        }
        self.isChoose                   = indexPath.row - 3;
    }
    if (indexPath.row == 7 ) {
        self.isChoose                   = indexPath.row - 4;
    }
    if (indexPath.row == 8 ) {
        self.isChoose                   = indexPath.row -4;
    }
    if (indexPath.row == 9 ) {
        self.isChoose                   = indexPath.row -4;
    }
    for (int i                      = 0; i<self.seleBut.count; i++) {
        UIButton *but                   = self.seleBut[i];
        if (self.isChoose == i +1) {
            [but setImage:[UIImage imageNamed:@"selected_cycle"] forState:(UIControlStateNormal)];
        }else{
            [but setImage:[UIImage imageNamed:@"unselect_cycle"] forState:(UIControlStateNormal)];
        }
        if (i == 0) {
            if (!self.payPassword.length || self.blancePrice/self.blanceExchangeRate.doubleValue < self.totalPrice.doubleValue * 100 || !(self.authIdCard.length && self.authonStatus == 1)) {
                [but setImage:[[UIImage imageNamed:@"selected_cycle"] imageWithTintColor:[UIColor colorWithHex:0xcccccc]] forState:(UIControlStateNormal)];
            }
        }
        if (i == 1) {
            if (!self.payPassword.length || self.integralPrice < self.totalPrice.floatValue*100 || !(self.authIdCard.length && self.authonStatus == 1) ) {
                [but setImage:[[UIImage imageNamed:@"selected_cycle"] imageWithTintColor:[UIColor colorWithHex:0xcccccc]] forState:(UIControlStateNormal)];
            }
        }
    }
    if (self.isChoose == 2) {
        self.playView.priceNage.text    = @"嗨币抵扣";
        self.playView.placeLabel.text   = [NSString stringWithFormat:@"%.0f",ceil(self.totalPrice.doubleValue * 100)];
        self.playView.moneyLabel.hidden = YES;
        [self.playView.priceBut setTitle:@"抵扣" forState:(UIControlStateNormal)];
        
    }else{
        self.playView.priceNage.text    = @"应付金额";
        self.playView.placeLabel.text   = [NSString stringWithFormat:@"%@",[MKItemObject priceString:self.totalPrice.doubleValue *100]];
        [self.playView.placeLabel HYPriceChangeFont:9.0f colors:kHEXCOLOR(0xff3333) isTop:NO];
        [self.playView.priceBut setTitle:@"立即支付" forState:(UIControlStateNormal)];
        self.playView.moneyLabel.hidden = NO;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
//8连连支付,7支付宝,9微信
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        return 170;
    }
    if (indexPath.row == 1 || indexPath.row == 6) {
        return 10;
    }
    if (indexPath.row == 2 ) {
        return 35;
    }
    if (indexPath.row == 3 ) {
        
        if ( self.blancePrice==0 && self.integralPrice==0 ) {
            return 0;
        }
        if ( !ISNSStringValid([self.payWayDict objectForKey:@"hi_coin_pay"])
            && !ISNSStringValid([self.payWayDict objectForKey:@"account_balance_pay"]) )
        {
            return 0;
        }
        if (self.isHidenTime || ( self.orderObject && self.orderObject.orderType != 7)) {
            
        }else{
            return 0;
        }
        if (self.authIdCard.length &&  self.authonStatus == 1 ) {
            if (self.payPassword.length) {
                return 0;
            }
        }
        return 35;
    }
    if (indexPath.row == 4) {
        if (self.blancePrice == 0 ) {
            return 0;
        }
        if ( !ISNSStringValid([self.payWayDict objectForKey:@"account_balance_pay"]) ) {
            return 0;
        }
    }
    if (indexPath.row == 5) {
        //如果是秒杀商品 嗨币隐藏
        if (_isHidenInter) {
            return 0;
        }
        if (self.integralPrice == 0) {
            return 0;
        }
        if ( !ISNSStringValid([self.payWayDict objectForKey:@"hi_coin_pay"]) ) {
            return 0;
        }
    }
    /**
     *      @brief 8连连支付入口关闭,7支付宝,9微信
     */
    if ( indexPath.row == 7 )
    {
        if ( !ISNSStringValid([self.payWayDict objectForKey:@"ali_pay"]) ) {
            return 0;
        }
    }
    if ( indexPath.row == 8 )
    {
        if ( !ISNSStringValid([self.payWayDict objectForKey:@"lian_lian_pay"]) ) {
            return 0;
        }
    }
    if ( indexPath.row == 9 )
    {
        if ( !ISNSStringValid([self.payWayDict objectForKey:@"wx_pay"]) ) {
            return 0;
        }
    }
    return 57;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    self.playView.frame                                               = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- 60 +scrollView.contentOffset.y, [UIScreen mainScreen].bounds.size.width, 60);
}



@end
