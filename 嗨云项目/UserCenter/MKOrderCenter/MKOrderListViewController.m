//
//  MKOrderListViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKOrderListViewController.h"
#import "MKOrderCommentViewController.h"
#import "MKOrderObject.h"
#import "MKBaseLib.h"
#import <PureLayout.h>
#import "UIColor+MKExtension.h"
#import "NSData+MKExtension.h"
#import "YLOrderDetailViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "MJRefresh.h"
#import <UIAlertView+Blocks.h>
#import "AppDelegate.h"
#import "WXApi.h"
#import "MKDeliveryViewController.h"
#import "NSArray+MKExtension.h"
#import "MKStoreHeardTableViewCell.h"
#import "MKOrderInfoTableViewCell.h"
#import "MKOrderOperationTableViewCell.h"
#import "MKSimpleItemTableViewCell.h"
#import "MKStoreDetailTableViewCell.h"
#import "MKPlaceTheOrderController.h"
#import "MKExceptionView.h"
#import "WXHDownRefreshHeader.h"
#import "HYGiftItemTableViewCell.h"

@interface MKOrderListViewController () <UITableViewDataSource, UITableViewDelegate, MKOrderCommentViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *orderSections;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSString *payOrderId;

@property (nonatomic,strong)MKExceptionView *exceptionView;


@end


@implementation MKOrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets           = NO;
    self.orderSections                                  = [NSMutableArray array];
    self.tableView                                      = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
                                                  style:UITableViewStyleGrouped];
    self.tableView.backgroundColor                      = [UIColor colorWithHex:0xeeeeee];
    self.tableView.separatorStyle                       = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate                             = self;
    self.tableView.dataSource                           = self;
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    WXHDownRefreshHeader * header=[WXHDownRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.header                               = header;
    header.lastUpdatedTimeLabel.hidden                  = YES;
    header.stateLabel.hidden                            = YES;
    MJRefreshAutoNormalFooter *footer                   = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    self.tableView.footer                               = footer;
//    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    footer.refreshingTitleHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"松手即将加载" forState:MJRefreshStatePulling];

    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
    [self registerCells:self.tableView];
//    if (self.orderStatus == MKOrderStatusRefundApply) {
//        self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.exceptionView                                  = [MKExceptionView loadFromXib];
    self.exceptionView.imageView.image                  = [UIImage imageNamed:@"wudingdan_my"];
    self.exceptionView.backgroundColor                  = [UIColor colorWithHex:0xf5f5f5];
    self.exceptionView.circleView.backgroundColor       = [UIColor clearColor];
    if (self.orderStatus == MKOrderStatusRefundApply) {
    self.exceptionView.exceptionLabel.text              = @"您还没有相关的维权订单哦~";

    }else{
    self.exceptionView.exceptionLabel.text              = @"您还没有相关的订单哦~";
    }
        [self.view insertSubview:self.exceptionView atIndex:0];
        [self.exceptionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
        {
    self.edgesForExtendedLayout                         = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
//    self.tabBarController.tabBar.translucent            = NO;
        }
    self.exceptionView.hidden                           = YES;
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderStatusChanged:)
                                                 name:MKOrderStatusChangedNotification object:nil];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if( self.orderStatus == MKOrderStatusUnpaid )
    {
       [self loadDataIsNew:YES];
    }
}
- (void)registerCells:(UITableView *)tableView
{
    NSArray *cs = @[@"MKSimpleItemTableViewCell", @"MKOrderInfoTableViewCell",
                    @"MKOrderOperationTableViewCell",@"MKStoreDetailTableViewCell",
                    @"MKStoreHeardTableViewCell",@"HYGiftItemTableViewCell"];
    for (NSString *c in cs)
    {
        UINib *nib = [UINib nibWithNibName:c bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:c];
    }
}
- (void)orderStatusChanged:(NSNotification *)noti
{
    [self loadDataIsNew:YES];
}

- (void)loadDataIsNew:(BOOL)isNew
{
    NSInteger offset          = self.orderSections.count;
    if (isNew)
    {
            offset                    = 0;
    }

    NSMutableDictionary *param =
        [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : @(offset),
                                                        @"count" : @(20)}];

    if (self.orderStatus > 0)
    {
        if (self.orderStatus == MKOrderStatusRefundApply)
        {
                param[@"refund_mark"]     = @(1);
        }else
        {
                param[@"order_status"]    = @(self.orderStatus);
        }
    }
    [MKNetworking MKSeniorGetApi:@"/trade/order/list" paramters:param completion:^(MKHttpResponse *response)
    {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        if (isNew)
        {
            [self.orderSections removeAllObjects];
        }
        for (NSDictionary *d in response.responseDictionary[@"data"][@"order_list"])
        {
                MKOrderObject *order      = [MKOrderObject objectWithDictionary:d];
                order.cancelOrderTime     = HYNowTimeChangeToDate(order.payTimeout);
                order.dataSouce           = [NSMutableArray array];
            NSMutableArray  *giftArr = [NSMutableArray array];
            NSInteger orderNum = 0;
            for (MKOrderItemObject *obj in order.orderItems)
            {
//                    [order.dataSouce addObject:obj];
//                for ( MKOrderItemObject *objc in obj.orderItemList )
//                {
                    orderNum += obj.number;
                    BOOL isGift = NO;//是否是赠品
                    if ( obj.price == 0.0f )
                    {
                        for ( MKOrderDiscountObject *item in order.discountInfo )
                        {
                            if ( item.discountAmount == 0
                                && [item.discountCode isEqualToString:@"ReachMultipleReduceTool"]
                                && [item.itemSkuId isEqual:obj.itemSkuId]  )
                            {
                                isGift = YES;
                                break;
                            }
                        }
                    }
                    if ( isGift )
                    {
                        [giftArr addObject:obj];
                    }
                    else
                    {
                        [order.dataSouce addObject:obj];
                    }
//                }
            }
            //如果有赠品将赠品放在最后
            if ( giftArr.count > 0 )
            {
                [order.dataSouce addObjectsFromArray:giftArr];
            }
            order.orderNum =orderNum;
            //排除未支付订单出现在待支付订单中
            if ( self.orderStatus == 10 )
            {
                if ( order.orderStatus == 10 )
                {
                    [self.orderSections addObject:order];
                }
            }else
            {
                [self.orderSections addObject:order];
            }
        }
        

        if (self.orderSections.count <= 0)
        {
            self.tableView.hidden     = YES;
            self.exceptionView.hidden = NO;
            return;
        }
        self.tableView.hidden     = NO;
        self.exceptionView.hidden = YES;
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section>=0 && section < self.orderSections.count )
    {
        MKOrderObject *obj = self.orderSections[section];
        return obj.dataSouce.count + 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section >=0 && indexPath.section <self.orderSections.count )
    {
       MKOrderObject *obj = self.orderSections[indexPath.section];
        if (indexPath.row == 0) {
            MKStoreHeardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKStoreHeardTableViewCell" forIndexPath:indexPath];
            cell.model = obj;
            [cell cellWithModel:obj];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        if (indexPath.row == obj.dataSouce.count + 1) {
            
            MKOrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKOrderInfoTableViewCell" forIndexPath:indexPath];
            cell.priceLabel.text = [MKBaseItemObject priceString:obj.totalAmount];
            [cell.priceLabel HYPriceChangeFont:9.0f colors:kHEXCOLOR(kRedColor) isTop:NO];
            cell.numberLabel.text = [NSString stringWithFormat:@"共%ld件商品，合计：",obj.orderNum];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
        if (indexPath.row == obj.dataSouce.count + 2) {
            
            MKOrderOperationTableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"MKOrderOperationTableViewCell" forIndexPath:indexPath];
            [c setSelectionStyle:UITableViewCellSelectionStyleNone];
            for (UIButton *b in c.buttons)
            {
                [b removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                b.hidden = YES;
            }
            //        未支付
            if (obj.orderStatus == MKOrderStatusUnpaid)
            {
                [c.buttons[2] setHidden:YES];
                [c.buttons[1] setHidden:YES];
                [c.buttons[0] setHidden:NO];
                [c.buttons[0] setBackgroundColor:[UIColor colorWithHex:0xff4b55]];
                [(UIButton *)c.buttons[0] setTitle:@"立即支付" forState:UIControlStateNormal];
                [c.buttons[0] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [c.buttons[0] layer].borderColor = nil;
                [c.buttons[0] layer].borderWidth = 0;
                [c.buttons[0] addTarget:self action:@selector(clickPayBtn: withEven:) forControlEvents:UIControlEventTouchUpInside];
            }
            if ([obj ourOrderStatus] == 2) {
                [c.buttons[2] setHidden:YES];
                [c.buttons[1] setHidden:NO];
                [(UIButton *)c.buttons[1] setTitle:@"查看物流" forState:UIControlStateNormal];
                [c.buttons[1] addTarget:self action:@selector(clickDeliveryBtn: withEven:) forControlEvents:UIControlEventTouchUpInside];
                [c.buttons[0] setHidden:NO];
                [(UIButton *)c.buttons[0] setTitle:@"确认收货" forState:UIControlStateNormal];
                [c.buttons[0] setBackgroundColor:[UIColor colorWithHex:0xff4b55]];
                [c.buttons[0] layer].borderColor = nil;
                [c.buttons[0] layer].borderWidth = 0;
                [c.buttons[0] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [c.buttons[0] addTarget:self action:@selector(clickSureBtn: withEven:) forControlEvents:UIControlEventTouchUpInside];
            }
            [c setSelectionStyle:UITableViewCellSelectionStyleNone];
            return c;
        }
        if (indexPath.row == obj.dataSouce.count + 3) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]init];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.backgroundColor = [UIColor colorWithHex:0xeeeeee];
            return cell;
        }
        if (indexPath.row >0 && indexPath.row - 1 < obj.dataSouce.count) {
            
            NSObject *object = obj.dataSouce[indexPath.row - 1];
            if ([object isKindOfClass:[MKOrderItemObject class]]) {
                BOOL isGift = NO;
                MKOrderItemObject  *model = (MKOrderItemObject *)object;
                if ( model.price == 0.0f )
                {
                    for ( MKOrderDiscountObject *item in obj.discountInfo )
                    {
                        if (item.discountAmount == 0 &&  [item.discountCode isEqualToString:@"ReachMultipleReduceTool"]
                            && [item.itemSkuId isEqual:model.itemSkuId]  )
                        {
                            isGift = YES;
                        }
                    }
                }
                if ( isGift )
                {
                    HYGiftItemTableViewCell *c1 = [tableView dequeueReusableCellWithIdentifier:@"HYGiftItemTableViewCell" forIndexPath:indexPath];
                    [c1 cellWithModel:[NSString stringWithFormat:@"赠：%@",((MKOrderItemObject *)object).itemName]];
                    [c1 setSelectionStyle:UITableViewCellSelectionStyleNone];
                    return c1;
                    
                }
                MKSimpleItemTableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"MKSimpleItemTableViewCell" forIndexPath:indexPath];
                [c cellWithModel:(MKOrderItemObject *)object orderObject:obj];
                [c setSelectionStyle:UITableViewCellSelectionStyleNone];
                return c;
            }else{
                MKStoreDetailTableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"MKStoreDetailTableViewCell" forIndexPath:indexPath];
                c.item = (MKDistributorOrderItemList *)object;
                c.storeName.text =[(MKDistributorOrderItemList *)object distributorName];
                [c setSelectionStyle:UITableViewCellSelectionStyleNone];
                return c;
            }
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section >=0 && indexPath.section <self.orderSections.count )
    {
        MKOrderObject *obj = self.orderSections[indexPath.section];
        if (indexPath.row == 0) {
            return 33;
        }
        if (indexPath.row == obj.dataSouce.count + 1) {
            return 37;
        }
        if (indexPath.row == obj.dataSouce.count + 2) {
            
            if (obj.orderStatus == MKOrderStatusUnpaid ||
                obj.orderStatus == MKOrderStatusDeliveried) {
                return 47;
            }
            return 0;
        }
        if (indexPath.row == obj.dataSouce.count + 3) {
            return 10;
        }
        if ( indexPath.row>0 && indexPath.row <= obj.dataSouce.count )
        {
            NSObject *object   = obj.dataSouce[indexPath.row - 1];
            if ([object isKindOfClass:[MKOrderItemObject class]]) {
                MKOrderItemObject  *model = (MKOrderItemObject *)object;
                if ( model.price == 0.0f )
                {
                    for ( MKOrderDiscountObject *item in obj.discountInfo )
                    {
                        if ( item.discountAmount == 0 && [item.discountCode isEqualToString:@"ReachMultipleReduceTool"]
                            && [item.itemSkuId isEqual:model.itemSkuId]  )
                        {
                            return 31.0f;
                        }
                    }
                }
                return 90.0f;
            }else{
                return 28;
            }
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section>=0 && indexPath.section<self.orderSections.count )
    {
        MKOrderObject *obj               = self.orderSections[indexPath.section];
        YLOrderDetailViewController *odv = [[YLOrderDetailViewController alloc] init];
        odv.orderUid                     = obj.orderUid;
        [self.navigationController pushViewController:odv animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
       return 10;
    }
    return .2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .2;
}
- (void)loadNewData
{
    [self loadDataIsNew:YES];
}

- (void)loadMoreData
{
    [self loadDataIsNew:NO];
}
//取消订单
- (void)clickCancleBtn:(UIButton *)sender withEven:(UIEvent *)even
{
    NSSet *touchs = [even allTouches];
    UITouch *touch = [touchs anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if ( indexPath && indexPath.section < self.orderSections.count && indexPath.section>=0 )
    {
        MKOrderObject *obj = self.orderSections[indexPath.section];
        
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"确定取消订单吗？" delegate:nil
                                           cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        al.didDismissBlock = ^(UIAlertView * __nonnull alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 0)
            {
                return ;
            }
            MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
            [MKNetworking MKSeniorPostApi:@"/trade/order/cancel"
                                paramters:@{@"order_uid" : obj.orderUid}
                               completion:^(MKHttpResponse *response)
             {
                 [ hud hide:YES];
                 if (response.errorMsg != nil)
                 {
                     [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                     return ;
                 }
                 [self loadDataIsNew:YES];
             }];
        };
        [al show];
    }
    
}
//删除订单
- (void)clickDeleteBtn:(UIButton *)sender withEven:(UIEvent *)even
{
    NSSet *touchs                = [even allTouches];
    UITouch *touch               = [touchs anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath       = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if ( indexPath && indexPath.section < self.orderSections.count && indexPath.section>=0 )
    {
        MKOrderObject *obj           = self.orderSections[indexPath.section];
        UIAlertView *al              = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除订单吗？" delegate:nil
                                                        cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        al.didDismissBlock                  = ^(UIAlertView * __nonnull alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 0)
            {
                return ;
            }
            MBProgressHUD *hud           = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
            [MKNetworking MKSeniorPostApi:@"/trade/order/delete" paramters:@{@"order_uid" : obj.orderUid}
                               completion:^(MKHttpResponse *response)
             {
                 [ hud hide:YES];
                 if (response.errorMsg != nil)
                 {
                     [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                     return ;
                 }
                 [self loadDataIsNew:YES];
             }];
        };
        [al show];
    }
    
}
//查看物流
- (void)clickDeliveryBtn:(UIButton *)sender withEven:(UIEvent *)even
{
    NSSet *touchs                = [even allTouches];
    UITouch *touch               = [touchs anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath       = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if ( indexPath && indexPath.section < self.orderSections.count && indexPath.section>=0 )
    {
        MKOrderObject *obj           = self.orderSections[indexPath.section];
        MKDeliveryViewController *Vc = [MKDeliveryViewController create];
        Vc.orderUid                  = obj.orderUid;
        [self.navigationController pushViewController:Vc animated:YES];
    }
   
}

//确实收货
- (void)clickSureBtn:(UIButton *)sender withEven:(UIEvent *)even
{
    NSSet *touchs                = [even allTouches];
    UITouch *touch               = [touchs anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath       = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if ( indexPath && indexPath.section < self.orderSections.count && indexPath.section>=0 )
    {
        MKOrderObject *obj           = self.orderSections[indexPath.section];
        UIAlertView *al              = [[UIAlertView alloc] initWithTitle:nil message:@"确认收货吗？" delegate:nil
                                                        cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        al.didDismissBlock                  = ^(UIAlertView * __nonnull alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 0)
            {
                return ;
            }
            NSMutableArray *ar           = [NSMutableArray array];
            
            [ar addObject:obj.orderUid];
            
            NSString *str                = [ar jsonString];
            
            MBProgressHUD *hud           = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
            [MKNetworking MKSeniorPostApi:@"/trade/order/receipt"
                                paramters:@{@"order_uid_list" : str}
                               completion:^(MKHttpResponse *response)
             {
                 [ hud hide:YES];
                 if (response.errorMsg != nil)
                 {
                     [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                     return ;
                 }
                 [self loadDataIsNew:YES];
             }];
        };
        [al show];
    }
    
}

//立即支付
- (void)clickPayBtn:(UIButton*)sender withEven:(UIEvent *)even
{
    NSSet *touchs                              = [even allTouches];
    UITouch *touch                             = [touchs anyObject];
    CGPoint currentTouchPosition               = [touch locationInView:self.tableView];
    NSIndexPath *indexPath                     = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if ( indexPath
        && indexPath.section < self.orderSections.count
        && indexPath.section>=0 )
    {
        MKOrderObject *obj                         = self.orderSections[indexPath.section];
        self.payOrderId                            = obj.orderUid;
        MKPlaceTheOrderController *orderController = [MKPlaceTheOrderController create];
        orderController.orderUid                   = obj.orderUid;
        orderController.totalPrice                 = [MKBaseItemObject priceString:obj.totalAmount];
        orderController.time                       = [HYNSStringChangeToDate(obj.cancelOrderTime)  timeIntervalSinceDate:HYDateChangeToDate([NSDate date])];
        orderController.orderObject                = obj;
        orderController.consigneeItem              = obj.consignee;
        orderController.orderSn                    = obj.orderSn;
        if (obj.couponItems.count) {
            orderController.couponObject               = obj.couponItems[0];
        }
        [self.navigationController pushViewController:orderController animated:YES];
    }
    
}

//评价订单
- (void)clickCommentBtn:(UIButton*)sender withEven:(UIEvent *)even
{
    NSSet *touchs                      = [even allTouches];
    UITouch *touch                     = [touchs anyObject];
    CGPoint currentTouchPosition       = [touch locationInView:self.tableView];
    NSIndexPath *indexPath             = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if ( indexPath
        && indexPath.section < self.orderSections.count
        && indexPath.section>=0 )
    {
        MKOrderObject *obj                 = self.orderSections[indexPath.section];
        MKOrderCommentViewController *ocvc = [[MKOrderCommentViewController alloc] init];
        ocvc.orderUid                      = obj.orderUid;
        ocvc.delegate                      = self;
        [self.navigationController pushViewController:ocvc animated:YES];
    }
    
}

- (void)orderCommentViewControllerCommentFinished:(MKOrderCommentViewController *)commentViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MKOrderStatusChangedNotification object:nil];
}




@end
