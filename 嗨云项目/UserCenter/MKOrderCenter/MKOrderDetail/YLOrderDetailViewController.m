//
//  YLOrderDetailViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLOrderDetailViewController.h"
#import "YLOrderDetailView.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKBaseItemObject.h"
#import "UIViewController+MKExtension.h"
#import <UIAlertView+Blocks.h>
#import "NSArray+MKExtension.h"
#import "MKDeliveryViewController.h"
#import "HYMainNotDataView.h"
#import "MKPlaceTheOrderController.h"

@interface YLOrderDetailViewController ()<YLOrderDetailViewDelegate,HYMainNotDataViewDelegate>
{
 
    YLOrderDetailView       *_pView;
    HYMainNotDataView       *_mainNotDataView;
}


@end

@implementation YLOrderDetailViewController

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
    [self loadData];
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
        _pView = NewObject(YLOrderDetailView);
        _pView.frame = rect;
        _pView.delegate = self;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.frame = rect;
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
    self.title = @"订单详情";
}



- (void)loadData
{
    NSString *orderId = self.orderUid == nil ? self.order.orderUid : self.orderUid;
    if (orderId == nil)
    {
        orderId = @"";
    }
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/trade/order/get" paramters:@{@"order_uid":self.orderUid}
                      completion:^(MKHttpResponse *response)
     {
         
         
         [ hud hide:YES];
         if (response.errorMsg != nil)
         {
             
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             _mainNotDataView.hidden = NO;
             return ;
         }
         _mainNotDataView.hidden = YES;
         NSDictionary *d = response.mkResponseData[@"order"];
         self.order = [MKOrderObject objectWithDictionary:d];
         self.order.cancelOrderTime = HYNowTimeChangeToDate(_order.payTimeout);
         if ( _pView )
         {
             [_pView setInfDict:d];
         }
//         [self changeTopRightBtnStatus:self.order.orderStatus type:self.order.orderType];
     }];
}

#pragma mark-改变取消订单状态
-(void)changeTopRightBtnStatus:(MKOrderStatus)orderStatus type:(NSInteger)types
{
    if ( orderStatus == MKOrderStatusUnpaid  && types != 7 )
    {
       self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithMJTitle:@"取消订单" target:self action:@selector(rightButton)];
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
#pragma mark -取消订单
-(void)rightButton
{
    __weak typeof(self) weakSelf = self;
 UIAlertView *alt = [UIAlertView showWithTitle:@"提示"
                       message:@"确定取消订单吗？"
             cancelButtonTitle:@"取消"
             otherButtonTitles:@[@"确定"]
                      tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                          
                          
                      }];
    alt.didDismissBlock = ^(UIAlertView * __nonnull alertView, NSInteger buttonIndex){
        if ( buttonIndex == 1  )
        {
            MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
            [MKNetworking MKSeniorPostApi:@"/trade/order/cancel" paramters:@{@"order_uid" : self.order.orderUid}
                               completion:^(MKHttpResponse *response)
             {
                 [ hud hide:YES];
                 if (response.errorMsg != nil)
                 {
                     [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                     return ;
                 }
                 weakSelf.order.orderStatus = MKOrderStatusCanceled;
                 [weakSelf loadData];
             }];
        }
    };
}


#pragma mark -订单详情的代理
//*   0 支付，1确认收货，2查看物流,3订单状态改变,4取消订单
-(void)showOrderDetailView:(YLOrderDetailView *)orderView InfoType:(NSInteger)type
{
    if ( orderView == _pView )
    {
        switch (type) {
            case 0:
            {
                [self clickPayBtn];
            }
                break;
            case 1:
            {
                [self clickSureBtn];
            }
                break;
            case 2:
            {
                [self clickDeliveryBtn];
            }
                break;
            case 3:
            {
                [self loadData];
            }
                break;
            case 4:
            {
                [self rightButton];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark -立即支付
//立即支付
- (void)clickPayBtn
{
    
    MKPlaceTheOrderController *orderController = [MKPlaceTheOrderController create];
    orderController.orderUid = self.order.orderUid;
    orderController.totalPrice = [MKBaseItemObject priceString:self.order.totalAmount];
    orderController.time =  [HYNSStringChangeToDate(self.order.cancelOrderTime)  timeIntervalSinceDate:HYDateChangeToDate([NSDate date])];
    orderController.consigneeItem = self.order.consignee;
    orderController.orderObject = self.order;
    [self.navigationController pushViewController:orderController animated:YES];
}



#pragma mark -确认收货
- (void)clickSureBtn
{
    __weak typeof(self) weakSelf = self;
   UIAlertView *alert = [UIAlertView showWithTitle:@"提示"
                       message:@"确认收货吗？"
             cancelButtonTitle:@"取消"
             otherButtonTitles:@[@"确定"]
                      tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                          
                          
                      }];
    alert.didDismissBlock = ^(UIAlertView * __nonnull alertView, NSInteger buttonIndex){
        if ( buttonIndex == 1  )
        {
            NSMutableArray *ar = [NSMutableArray array];
            
            [ar addObject:weakSelf.order.orderUid];
            
            NSString *str = [ar jsonString];
            
            MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:weakSelf.view wait:YES];
            [MKNetworking MKSeniorPostApi:@"/trade/order/receipt" paramters:@{@"order_uid_list" : str}
                               completion:^(MKHttpResponse *response)
             {
                 [ hud hide:YES];
                 if (response.errorMsg != nil)
                 {
                     [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                     return ;
                 }
                 weakSelf.order.orderStatus = MKOrderStatusSignOff;
                 [weakSelf loadData];
             }];
            
        }
    };
    
}

#pragma mark - 查看物流
- (void)clickDeliveryBtn
{
    MKDeliveryViewController *Vc = [MKDeliveryViewController create];
    Vc.orderUid = self.order.orderUid;
    [self.navigationController pushViewController:Vc animated:YES];
}

#pragma mark -HYMainNotDataViewDelegate
-(void)reloadDataView:(HYMainNotDataView *)noView
{
    if ( noView == _mainNotDataView )
    {
        [self loadData];
    }
}


@end
