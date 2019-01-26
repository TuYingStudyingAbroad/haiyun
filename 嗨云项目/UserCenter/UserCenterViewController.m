//
//  UserCenterViewController.m
//  YangDongXi
//
//  Created by Will Su on 14-7-5.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "UserCenterViewController.h"
#import "MKBaseLib.h"
#import "MKConsigneeListViewController.h"
#import "MKOrdersViewController.h"
#import "UIViewController+MKExtension.h"
#import "MKOrderListViewController.h"
#import "MKCollectionViewController.h"
#import "MKSettingTableViewController.h"
#import "MKCouponViewController.h"
#import "MKHistoryViewController.h"
#import "UIColor+MKExtension.h"
#import "MKVouchersViewController.h"
#import "MKRealNameViewController.h"
#import "MKWebViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKUserCenter.h"
#import "AppDelegate.h"
#import "HYNavigationController.h"
#import "MKUrlGuide.h"
#import "getMoneyTableViewController.h"
#import "preferenceViewController.h"
#import "MyHBViewController.h"
#import "PersonZLViewController.h"
#import "HScollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "BaiduMobStat.h"
#import "QYSDK.h"
#import "QYCommodityInfo.h"
#import "QYSource.h"
#import <PureLayout.h>
#import "QYConversationManagerProtocol.h"
#import "XTSettingViewController.h"
#import "getMoneyViewController.h"
#import "fansViewController.h"
#import "JoinUSViewController.h"
//兑吧
#import "CreditWebViewController.h"
#import "CreditNavigationController.h"
#import "FSdefsViewController.h"
#import "HYKTViewController.h"
@interface UserCenterViewController () <UIAlertViewDelegate,QYConversationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *divisionView;
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *bgAvatarImageView;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
//邀请码
@property (weak, nonatomic) IBOutlet UILabel *yqmLabel;
//背景图
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

//加入嗨客View
@property (weak, nonatomic) IBOutlet UIView *joinHKBackView;
//二维码btn
@property (weak, nonatomic) IBOutlet UIButton *ewmBtn;
//今日收益（非嗨客）
@property (weak, nonatomic) IBOutlet UILabel *FHKjrsrLabel;
//余额（非嗨客）
@property (weak, nonatomic) IBOutlet UILabel *FHKyeLabel;
//今日收益（嗨客）
@property (weak, nonatomic) IBOutlet UILabel*vouchersLabel;
//粉丝（嗨客）
@property (weak, nonatomic) IBOutlet UILabel*couponNumLabel;
//余额（嗨客）
@property (weak, nonatomic) IBOutlet UILabel*yangIntegralNumLabel;
//查看全部订单
@property (weak, nonatomic) IBOutlet UILabel *ckddL;
@property (weak, nonatomic) IBOutlet UILabel *tepy1;
@property (weak, nonatomic) IBOutlet UILabel *tepy2;
@property (weak, nonatomic) IBOutlet UILabel *tepy3;
@property (weak, nonatomic) IBOutlet UILabel *tepy4;

@property (weak, nonatomic) NSString *nopayOrder;
@property (weak, nonatomic) NSString *waitReciveOrder;
@property (weak, nonatomic) UITapGestureRecognizer *tapGesture;
@property (assign, nonatomic) BOOL isControlRefresh;
//待付款显示数量label
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
//待发货显示数量label
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
//待收货显示数量label
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
//售后中显示数量label
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, assign) UIStatusBarStyle myStatusBarStyle;
@property (weak, nonatomic) IBOutlet UILabel *xxL;
@property (weak, nonatomic) IBOutlet UIButton *xxB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopeLayout;
//非嗨客显示收益底部View
@property (weak, nonatomic) IBOutlet UIView *fHKView;
//嗨客显示收益底部View
@property (weak, nonatomic) IBOutlet UIView *HKView;
//优惠劵提示label
@property (weak, nonatomic) IBOutlet UILabel *yhjMessageLabel;
//客服未读消息label
@property (weak, nonatomic) IBOutlet UILabel *kfMessageLabel;
//昵称约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nikeNameLayout;
//兑吧
@property (nonatomic,strong) NSDictionary *loginData;
@property (weak, nonatomic) IBOutlet UILabel *hiCoinLabel;
//
@property (nonatomic,strong) NSMutableDictionary *dbDict;
@end

@implementation UserCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isControlRefresh = YES;
    self.tableView.editing = NO;
    self.dbDict = [[NSMutableDictionary alloc] init];
    //隐藏滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
  
    self.ckddL.textColor = [UIColor colorWithHex:0x666666];
    self.tepy1.textColor = [UIColor colorWithHex:0x666666];
    self.tepy2.textColor = [UIColor colorWithHex:0x666666];
    self.tepy3.textColor = [UIColor colorWithHex:0x666666];
    self.tepy4.textColor = [UIColor colorWithHex:0x666666];
    self.paymentLabel.layer.cornerRadius = 7.5;
    self.deliveryLabel.layer.cornerRadius = 7.5;
    self.goodsLabel.layer.cornerRadius = 7.5;
    self.commentLabel.layer.cornerRadius = 7.5;
    
    self.paymentLabel.layer.masksToBounds = YES;
    self.deliveryLabel.layer.masksToBounds = YES;
    self.goodsLabel.layer.masksToBounds = YES;
    self.commentLabel.layer.masksToBounds = YES;
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 30;
    self.bgAvatarImageView.layer.masksToBounds = YES;
    self.bgAvatarImageView.layer.cornerRadius = 30;
    self.bgAvatarImageView.layer.borderWidth = 0;
    self.bgAvatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
   
    
    self.paymentLabel.hidden = YES;
    self.deliveryLabel.hidden = YES;
    self.goodsLabel.hidden = YES;
    self.commentLabel.hidden = YES;
    
    self.paymentLabel.backgroundColor = [UIColor colorWithHex:0xFF2741];
    self.deliveryLabel.backgroundColor = [UIColor colorWithHex:0xFF2741];
    self.goodsLabel.backgroundColor = [UIColor colorWithHex:0xFF2741];;
    self.commentLabel.backgroundColor = [UIColor colorWithHex:0xFF2741];;
    //设置按钮背景部分圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 83.0f, 30.0f) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(15.0f, 15.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 83.0f, 30.0f);
    maskLayer.path = maskPath.CGPath;
    self.joinHKBackView.layer.mask = maskLayer;
    self.joinHKBackView.userInteractionEnabled = YES;
    if (getUserCenter.userInfo != nil)
    {
        self.userNameLabel.text = getUserCenter.userInfo.userName;
        if (getUserCenter.userInfo.userName == nil) {
            
            self.userNameLabel.text = @"设置昵称";
        }
        
        [self.bgAvatarImageView sd_setImageWithURL:[NSURL URLWithString:getUserCenter.userInfo.headerUrl] placeholderImage:[UIImage imageNamed:@"touxiang1"]];
    }else {
        
        
        self.userNameLabel.text = @"设置昵称";
        self.bgAvatarImageView.image = [UIImage imageNamed:@"touxiang1"];
    }
    /**********************1.2.2新增*****************/
    
    self.yhjMessageLabel.layer.cornerRadius = 7.5;
    self.yhjMessageLabel.layer.masksToBounds = YES;
    self.kfMessageLabel.layer.cornerRadius = 7.5;
    self.kfMessageLabel.layer.masksToBounds = YES;
    self.joinHKBackView.hidden = YES;
    self.ewmBtn.hidden = YES;
    self.yqmLabel.hidden = YES;
    NSString *role = [NSString stringWithFormat:@"%@",getUserCenter.userInfo.roleMark];
    
    //买家(没有嗨客资格)
    if ([role isEqualToString:@"1"]) {
        
        self.joinHKBackView.hidden = YES;
        self.ewmBtn.hidden = YES;
        self.yqmLabel.hidden = YES;
        self.nameTopeLayout.constant = 50;
        self.nikeNameLayout.constant = -60;
        self.fHKView.hidden = NO;
        self.HKView.hidden = YES;
        
    }
    //嗨客
    if ([role isEqualToString:@"2"]) {
        
        self.joinHKBackView.hidden = YES;
        self.ewmBtn.hidden = YES;
        self.yqmLabel.hidden = NO;
        self.yqmLabel.text = [NSString stringWithFormat:@"邀请码:%@",getUserCenter.userInfo.invitationCode];
        if (getUserCenter.userInfo.fansCount) {
            
            self.couponNumLabel.text = [NSString stringWithFormat:@"%@",getUserCenter.userInfo.fansCount];
        }else {
            
            self.couponNumLabel.text = @"0";
        }
        self.nameTopeLayout.constant = 37.5;
        self.nikeNameLayout.constant = -60;
        self.fHKView.hidden = YES;
        self.HKView.hidden = NO;
        
        
    }
    //具有嗨客资格
    if ([role isEqualToString:@"5"]) {
        
        self.joinHKBackView.hidden = NO;
        self.ewmBtn.hidden = YES;
        self.yqmLabel.hidden = YES;
        self.nameTopeLayout.constant = 50;
        self.nikeNameLayout.constant = 10;
        self.fHKView.hidden = NO;
        self.HKView.hidden = YES;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserName:)
                                                 name:MKUserInfoLoadSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserNameFailed:)
                                                 name:MKUserInfoLoadFailedNotification object:nil];
    self.myStatusBarStyle = UIStatusBarStyleLightContent;
    /**********************1.2.3新增*****************/
   
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.myStatusBarStyle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isControlRefresh)
    {
        [self loadData];
        [self loadCouponNum];
        [self loadWealthAccount];
        [self loadTadayMoney];
    }
    else{
        self.isControlRefresh = YES;
    }
    
    [self checkLoginState];
    
    //实时更新用户数据
    [appDelegate.userCenter reloadUserInfo];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    

    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    [self configBadgeView];
   
}
- (void)configBadgeView
{
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [self.kfMessageLabel setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",count];
    self.kfMessageLabel.text = value;
}
//加入嗨客按钮
- (IBAction)joinHKBtn:(id)sender {
    JoinUSViewController * joinUSVC=[[JoinUSViewController alloc]init];
    joinUSVC.haiKeBlock=^(NSString* code){
        if ([code isEqualToString:@"10000"]) {
            self.joinHKBackView.hidden = YES;
            self.ewmBtn.hidden = YES;
            self.yqmLabel.hidden = NO;
            self.yqmLabel.text = [NSString stringWithFormat:@"邀请码:%ld",getUserCenter.userInfo.inviterId];
            self.nameTopeLayout.constant = 37.5;
            self.fHKView.hidden = YES;
            self.HKView.hidden = NO;
            [self.tableView reloadData];
        }
        
    };
    [self.navigationController pushViewController:joinUSVC animated:YES];
   

}
//非嗨客今日收益按钮
- (IBAction)FHKjrsyBtn:(id)sender {
    
    
}
//非嗨客余额按钮
- (IBAction)HKyeBtn:(id)sender {
    getMoneyViewController * getMoneyVC=[getMoneyViewController create];
    getMoneyVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:getMoneyVC animated:YES];
    
    
}

- (void)onUnreadCountChanged:(NSInteger)count
{
    [self configBadgeView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)getUserNameFailed:(NSNotification *)nof {
    
    self.joinHKBackView.hidden = YES;
    self.ewmBtn.hidden = YES;
    self.yqmLabel.hidden = YES;
    self.nameTopeLayout.constant = 50;
    self.fHKView.hidden = NO;
    self.HKView.hidden = YES;
    //[MBProgressHUD showMessageIsWait:@"网络错误或账号问题" wait:YES];
}
-(void)getUserName:(NSNotification *)notification
{   //实时更新用户数据
    self.userNameLabel.text = getUserCenter.userInfo.userName;
    [self.bgAvatarImageView sd_setImageWithURL:[NSURL URLWithString:getUserCenter.userInfo.headerUrl] placeholderImage:[UIImage imageNamed:@"touxiang1"]];
    
    NSString *role = [NSString stringWithFormat:@"%@",getUserCenter.userInfo.roleMark];

    //买家(没有嗨客资格)
    if ([role isEqualToString:@"1"]) {
        
        self.joinHKBackView.hidden = YES;
        self.ewmBtn.hidden = YES;
        self.yqmLabel.hidden = YES;
        self.nameTopeLayout.constant = 50;
        self.nikeNameLayout.constant = -60;
        self.fHKView.hidden = NO;
        self.HKView.hidden = YES;
        
    }
    //嗨客
    if ([role isEqualToString:@"2"]) {
    
        self.joinHKBackView.hidden = YES;
        self.ewmBtn.hidden = YES;
        self.yqmLabel.hidden = NO;
        self.yqmLabel.text = [NSString stringWithFormat:@"邀请码:%@",getUserCenter.userInfo.invitationCode];
        
        if (getUserCenter.userInfo.fansCount) {
            
            self.couponNumLabel.text = [NSString stringWithFormat:@"%@",getUserCenter.userInfo.fansCount];
        }else {
            
          self.couponNumLabel.text = @"0";
        }
        self.nameTopeLayout.constant = 37.5;
        self.nikeNameLayout.constant = -60;
        self.fHKView.hidden = YES;
        self.HKView.hidden = NO;
        
        
    }
    //具有嗨客资格
    if ([role isEqualToString:@"5"]) {
        
        self.joinHKBackView.hidden = NO;
        self.ewmBtn.hidden = YES;
        self.yqmLabel.hidden = YES;
        self.nameTopeLayout.constant = 50;
        self.nikeNameLayout.constant = 10;
        self.fHKView.hidden = NO;
        self.HKView.hidden = YES;
    }
    
    [self.tableView reloadData];
    [self loadData];
    [self loadCouponNum];
    [self loadWealthAccount];
    [self loadTadayMoney];
    
}

- (void)checkLoginState
{
    MKAccountInfo *accountInfo = getUserCenter.accountInfo;
    if (accountInfo.accessToken.length == 0)
    {
        self.paymentLabel.hidden = YES;
        self.deliveryLabel.hidden = YES;
        self.goodsLabel.hidden = YES;
        self.commentLabel.hidden = YES;
        
    }
    
    [self.tableView reloadData];
}
#pragma mark -获得今日收益接口
-(void)loadTadayMoney {
    
    [MKNetworking MKSeniorGetApi:@"/seller/center/get" paramters:nil
                      completion:^(MKHttpResponse *response)
     
     {
         
         if (response.errorMsg != nil)
         {
             return ;
         }
         NSString *sellerStr = [[response mkResponseData] HYValueForKey:@"is_seller"];
         if (sellerStr.integerValue == 1) {
             
             NSDictionary *jrsy = [[response mkResponseData] HYNSDictionaryValueForKey:@"seller_info"];
             NSString *str = [jrsy HYValueForKey:@"today_in_come"];
             
             self.vouchersLabel.text = str.integerValue==0?@"0.00":[NSString stringWithFormat:@"%@",[MKBaseItemObject priceString:str.integerValue]];
         }else {
             
             self.FHKjrsrLabel.text = @"0.00";
             
         }
         
     
     
     }];

    
}
//优惠券
- (void)loadCouponNum
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"30" forKey:@"status"];
    [param setObject:@"0" forKey:@"offset"];
    [param setObject:@"15" forKey:@"count"];
    [MKNetworking MKSeniorGetApi:@"/marketing/user/coupon/list" paramters:param
                      completion:^(MKHttpResponse *response)
    
     {
         if (response.errorMsg != nil)
         {
             return ;
         }
         
         NSArray *db = [[response mkResponseData] HYNSArrayValueForKey:@"coupon_list"];
       [self.yhjMessageLabel setHidden:[[[response mkResponseData] HYValueForKey:@"total_count"] integerValue] == 0];
         if (db && db.count > 0)
         {
             NSInteger total = [[[response mkResponseData] HYValueForKey:@"total_count"] integerValue];
             self.yhjMessageLabel.text = [NSString stringWithFormat:@"%li",(long)total];
         }
         else
         {
             self.yhjMessageLabel.text = nil;
             
         }
     }];
}
#pragma mark -获取我的虚拟账户信息
- (void)loadWealthAccount
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"0" forKey:@"wealth_type"];
    [MKNetworking MKSeniorGetApi:@"/marketing/wealth_account/list" paramters:param
                      completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         
         NSArray *db = [[response mkResponseData] HYNSArrayValueForKey:@"wealth_account_list"];
         
         if (db && db.count > 0)
         {
             for (NSDictionary *d in db)
             {
                 MKWealthAcountInfo *item = [MKWealthAcountInfo objectWithDictionary:d];
                 //余额
                 if (item.type == 1) {
                     
                     
                        self.yangIntegralNumLabel.text = [NSString stringWithFormat:@"%@",[MKBaseItemObject priceString:item.amount]];

                     if ([MKBaseItemObject priceString:item.amount].intValue > 99999999) {
                         
                         self.yangIntegralNumLabel.text = @"99999999+";
                     }
                     
                 }
                 //嗨币
                 if (item.type == 3)
                 {
                     
                     
                     [self.dbDict setObject:[NSString stringWithFormat:@"%ld",item.amount] forKey:@"credits"];
                     if (self.yangIntegralNumLabel.text.length > 8) {

                         //self.yangIntegralNumLabel.text = @"99999999+";
                     }
                     self.hiCoinLabel.text = [NSString stringWithFormat:@"%ld个",item.amount];
                     
                 }
             }
         }
         else
         {
             //self.vouchersLabel.text = @"0";
            // self.yangIntegralNumLabel.text = @"0";
         }
     }];
}

- (void)loadData
{
    
    [MKNetworking MKSeniorGetApi:@"/trade/order/statistic/get" paramters:nil completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
             return ;
         }
         
         NSDictionary *orderNum = [response mkResponseData];
       //  NSLog(@"%@",orderNum);
         //待收货
         NSInteger deliveredNum = [[orderNum HYValueForKey:@"delivered_order_num"] integerValue];
         if (deliveredNum != 0) {
             self.goodsLabel.hidden = NO;
             
            
             self.goodsLabel.text = deliveredNum>99?@"99+":[NSString stringWithFormat:@"%li",(long)deliveredNum];
         }
         else
         {
             self.goodsLabel.hidden = YES;
         }
         //待付款
         NSInteger paymentNum = [[orderNum HYValueForKey:@"initial_order_num"] integerValue];
         if (paymentNum != 0) {
             self.paymentLabel.hidden = NO;
             
             self.paymentLabel.text = paymentNum>99?@"99+":[NSString stringWithFormat:@"%li",(long)paymentNum];
         }
         else
         {
             self.paymentLabel.hidden = YES;
         }
         
         //待发货
         NSInteger goodsNum = [[orderNum HYValueForKey:@"payed_order_num"] integerValue];
         if (goodsNum != 0) {
             self.deliveryLabel.hidden = NO;
             
             self.deliveryLabel.text = goodsNum>99?@"99+":[NSString stringWithFormat:@"%li",(long)goodsNum];
             
         }
         else
         {
             self.deliveryLabel.hidden = YES;
         }
         
         //售后
         NSInteger commentNum = [[orderNum HYValueForKey:@"refunding_order_num"] integerValue];
         if (commentNum != 0) {
             self.commentLabel.hidden = NO;
             
             self.commentLabel.text = commentNum>99?@"99+":[NSString stringWithFormat:@"%li",(long)commentNum];
         }
         else
         {
             self.commentLabel.hidden = YES;
         }
         
     }];
}
/**
 *  待付款
 */
- (IBAction)paymentButtonAction:(id)sender
{
   // NSLog(@"待付款");
    MKOrdersViewController *orders = [MKOrdersViewController create];
    orders.orderStatus = MKOrderStatusUnpaid;
    self.isControlRefresh = YES;
    [self.navigationController pushViewController:orders animated:YES];
}

/**
 *  待发货
 */
- (IBAction)deliveryButtonAction:(id)sender
{
    //NSLog(@"待发货");
    MKOrdersViewController *orders = [MKOrdersViewController create];
    orders.orderStatus = MKOrderStatusPaid;
    self.isControlRefresh = YES;
    
    [self.navigationController pushViewController:orders animated:YES];
    
}
/**
 *  待收货
 */
- (IBAction)goodsButtonAction:(id)sender
{
    MKOrdersViewController *orders = [MKOrdersViewController create];
    orders.orderStatus = MKOrderStatusDeliveried;
    self.isControlRefresh = YES;
    
    [self.navigationController pushViewController:orders animated:YES];
}
/**
 *  售后
 */
- (IBAction)commentButtonAction:(id)sender
{
   
    MKOrderListViewController *orderListViewController = [[MKOrderListViewController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    orderListViewController.title = @"售后订单";
    orderListViewController.orderStatus = MKOrderStatusRefundApply;
    orderListViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderListViewController animated:YES];
    
}

//头像上面btn，点击直接进入个人资料页面
- (IBAction)txuBtn:(id)sender {
    
    PersonZLViewController *p = [[PersonZLViewController alloc] init];
    
    [self.navigationController pushViewController:p animated:YES];
    
}
//点击昵称进入个人资料页面
- (IBAction)ncBtn:(id)sender {
    
    PersonZLViewController *p = [[PersonZLViewController alloc] init];
    
    [self.navigationController pushViewController:p animated:YES];

}
//设置按钮
- (IBAction)editorBtn:(id)sender {
    
    XTSettingViewController *m = [[XTSettingViewController alloc] init];
    m.title = @"系统设置";
    m.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:m animated:YES];
}

//今日收益(嗨客)
- (IBAction)blanceBtn:(UIButton *)sender {
    

    
//    getMoneyViewController * getMoneyTableVC=[getMoneyViewController create];
//    
//    [self.navigationController pushViewController:getMoneyTableVC animated:YES];
    

}

//余额（嗨客）
- (IBAction)haibiBtn:(id)sender {

//    MyHBViewController *hb = [[MyHBViewController alloc] init];
//    
//    [self.navigationController pushViewController:hb animated:YES];
    
    getMoneyViewController * getMoneyTableVC=[getMoneyViewController create];
    
    [self.navigationController pushViewController:getMoneyTableVC animated:YES];
    
}
//我的粉丝（嗨客）
- (IBAction)couponButtonAction:(id)sender
{
//    NSLog(@"我的优惠券");

//    preferenceViewController *  preferenceVC=[preferenceViewController create];
//    preferenceVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:preferenceVC animated:YES];
    
    fansViewController * fansVC=[[fansViewController alloc]init];
    
    [self.navigationController pushViewController:fansVC animated:YES];
    

    
}

#pragma mark - Table view delegate data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return 13;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     //NSString *role = [NSString stringWithFormat:@"%@",getUserCenter.userInfo.roleMark];
    if (indexPath.row == 0||indexPath.row == 3||indexPath.row == 10) {
        
        return 10;
    }
    if (indexPath.row == 2) {
        
        return 60;
    }

//    if (indexPath.row == 4&&![role isEqualToString:@"2"]) {
//        
//        return 0;
//    }

    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.isControlRefresh = NO;
    //我的订单
    if (indexPath.row == 1)
    {
        MKOrdersViewController *orders = [MKOrdersViewController create];
        orders.hidesBottomBarWhenPushed = YES;
        self.isControlRefresh = YES;
        [self.navigationController pushViewController:orders animated:YES];
    }
    //嗨客计划
    if (indexPath.row == 4)
    {
        MKWebViewController *vc = [[MKWebViewController alloc] init];
        [vc loadUrls:[NSString stringWithFormat:@"%@/haike-plan.html",BaseHtmlURL]];
        [vc webViewTitle:@"嗨客计划"];
        [self.navigationController pushViewController:vc animated:YES];
    }

    //嗨币兑换
   /* if (indexPath.row == 5)
    {
        [self.dbDict setObject:[NSString stringWithFormat:@"%ld",getUserCenter.userInfo.userId] forKey:@"uid"];
        
        
        [MKNetworking MKSeniorGetApi:@"/duiba/build/creditAutoLog" paramters:self.dbDict
                          completion:^(MKHttpResponse *response)
         
         {
             if (response.errorMsg != nil)
             {
                 [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];

                 return ;
             }
             if ([[response.responseDictionary HYValueForKey:@"msg"] isEqualToString:@"success"]) {
                 
                 NSString *dbURL = [[response.responseDictionary HYNSDictionaryValueForKey:@"data"] HYValueForKey:@"login_url"];
                 CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrlByPresent:dbURL];
                 CreditNavigationController *nav=[[CreditNavigationController alloc]initWithRootViewController:web];
                 [nav setNavColorStyle:[UIColor colorWithRed:195/255.0 green:0 blue:19/255.0 alpha:1]];
                 [self presentViewController:nav animated:YES completion:nil];
             }
            
             
         }];

//        MyHBViewController *hb = [[MyHBViewController alloc] init];
//        
//        [self.navigationController pushViewController:hb animated:YES];
        
    }*/
    //优惠劵
    if (indexPath.row == 6)
    {
        preferenceViewController *  preferenceVC=[preferenceViewController create];
        preferenceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:preferenceVC animated:YES];
    }
    //嗨云课堂
    if (indexPath.row == 7)
    {
        //[MBProgressHUD showMessageIsWait:@"即将上线 敬请期待" wait:YES];

        HYKTViewController *vc = [[HYKTViewController alloc] init];
        vc.title = @"嗨云课堂";
        [self.navigationController pushViewController:vc animated:YES];
    }

    //我的收藏
    if (indexPath.row == 8)
    {
        HScollectionViewController *m = [HScollectionViewController create];
        m.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:m animated:YES];
    }

    //浏览记录
    if (indexPath.row == 9)
    {
        MKHistoryViewController *m = [MKHistoryViewController create];
        [self.navigationController pushViewController:m animated:YES];
    }
    //联系客服
    if (indexPath.row == 11)
    {
        
       
        QYSource *source = [[QYSource alloc] init];
        source.title =  @"嗨云app-iOS";
        source.urlString = @"";
//        QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
//        commodityInfo.title = self.order.orderSn;
//        commodityInfo.desc = item.itemName;
//        commodityInfo.pictureUrlString = item.iconUrl;
//        commodityInfo.urlString = @"";
//        commodityInfo.note = [NSString stringWithFormat:@"订单实付金额:￥%@",[MKBaseItemObject priceString:_order.totalAmount]];
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        sessionViewController.sessionTitle = @"嗨云客服";
        sessionViewController.source = source;
       // sessionViewController.commodityInfo = commodityInfo;
        sessionViewController.hidesBottomBarWhenPushed = YES;
        
        [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [UIColor blackColor];
        [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [UIColor blackColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"session_bg"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;
        
        [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:getUserCenter.userInfo.headerUrl]]];
        
        [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"HYShare"];
        
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:sessionViewController animated:YES];
    }

    //帮助中心
    if (indexPath.row ==12)
    {
        MKWebViewController *vc = [[MKWebViewController alloc] init];
        [vc loadUrls:[NSString stringWithFormat:@"%@/guide-center.html",BaseHtmlURL]];
        [vc webViewTitle:@"帮助中心"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *mobileNumber = @"400-003-2002";
   
    NSString *mobileNumberStr = [@"tel://" stringByAppendingString:mobileNumber];
    
    NSURL *mobileNumberUrl = [NSURL URLWithString:mobileNumberStr];
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:mobileNumberUrl];
    }
}

#pragma mark- 百度统计进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"个人中心"];
    
}

#pragma mark- 百度统计退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"个人中心"];
}
@end
