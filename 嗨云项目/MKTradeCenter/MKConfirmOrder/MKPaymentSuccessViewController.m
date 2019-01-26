//
//  MKPaymentSuccessViewController.m
//  YangDongXi
//
//  Created by windy on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKPaymentSuccessViewController.h"
#import "MKBaseLib.h"
#import "MKItemObject.h"
#import "AppDelegate.h"
#import "MKOrdersViewController.h"
#import "UIViewController+MKExtension.h"
#import "UIColor+MKExtension.h"
#import "MKRegionModel.h"
#import "MKPlaceTheOrderController.h"
#import "MKOrdersViewController.h"
#import "BaiduMobStat.h"
#import "HYPaySuccessView.h"
#import "MKNetworking+BusinessExtension.h"
#import "JoinUSViewController.h"

@interface MKPaymentSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *myUserBut;

@property (weak, nonatomic) IBOutlet UIButton *orderDetailBut;

@property (weak, nonatomic) IBOutlet UIButton *shoppingBut;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameValue;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *noId;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *idNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *succce;

@end


@implementation MKPaymentSuccessViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"支付结果";
   self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.myUserBut.layer.borderColor = [[UIColor colorWithHex:0xe5e5e5] CGColor];
    self.myUserBut.layer.borderWidth = 1.0f;
    self.myUserBut.layer.cornerRadius = 3.0f;
    self.myUserBut.layer.masksToBounds = YES;
    self.orderDetailBut.layer.borderColor = [[UIColor colorWithHex:0xe5e5e5] CGColor];
    self.orderDetailBut.layer.borderWidth = 1.0f;
    self.orderDetailBut.layer.cornerRadius = 3.0f;
    self.orderDetailBut.layer.masksToBounds = YES;
     NSMutableArray *viewArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (NSInteger i =viewArr.count-1 ; i>=0; i--) {
        if ([viewArr[i] isKindOfClass:[MKConfirmOrderViewController class]]) {
            [viewArr removeObject:viewArr[i]];
            break;
        }
    }
    self.navigationController.viewControllers = viewArr;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[MKBaseItemObject priceString:self.payAmount]];
    if (self.payType == 2) {
        self.succce.text = @"抵扣成功";
        self.payTypeLabel.text = @"嗨币";
        self.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)self.payAmount/100];
    }else
    {
        [self.priceLabel HYPriceChangeFont:12.0f colors:kHEXCOLOR(0x222222) isTop:YES];
    }
    
    self.orderNumber.text = self.orderSn;
    self.nameLabel.text = self.consigneeItem.consignee;
    self.nameValue.text = self.consigneeItem.mobile;
    [MKRegionModel firstAddressWithCode1:self.consigneeItem.provinceCode
                                cityCode:self.consigneeItem.cityCode
                                areaCode:self.consigneeItem.areaCode
                              completion:^(NSString *address)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             // 更新界面
             self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",address,self.consigneeItem.address];

         });
     }];

       if (self.consigneeItem.idNo.length) {
        if ([self.consigneeItem.idNo rangeOfString:@"****"].location == NSNotFound) {
            NSString *str = self.consigneeItem.idNo;
            
                self.noId.text = [NSString stringWithFormat:@"%@****************%@",[str substringToIndex:1],[str substringFromIndex:str.length -1]];
        }else{
            self.noId.text = self.consigneeItem.idNo;
        }
        
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"AllBack"] style:(UIBarButtonItemStylePlain) target:self action:@selector(handleBack:)];
    if (self.consigneeItem.idNo.length) {
        self.idNoLabel.hidden = NO;
    }else{
        self.idNoLabel.hidden = YES;
    }
    if ( [getUserCenter.userInfo.roleMark integerValue] == 5 )
    {
        [self showMessageView];
    }
    else if ( [getUserCenter.userInfo.roleMark integerValue] == 1 )
    {
        [self onRequrest];
    }
}


- (void)handleBack:(UIBarButtonItem *)sender{
    
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
    [appDelegate.mainTabBarViewController guideToOrderListStatus:MKOrderStatusPaid];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}





- (IBAction)gobuy:(id)sender
{
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
    [getMainTabBar guideToOrderListStatus:MKOrderStatusPaid];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 210;
    }
    if (indexPath.row == 1) {
        return 10;
    }
    if (indexPath.row == 2) {
        return 36;
    }
    if (indexPath.row == 3) {
        if (self.consigneeItem.idNo.length) {
            return 100;
        }else{
            return 70;
        }
    }
    if (indexPath.row == 4) {
        return 119;
    }
    return 0;
}

#pragma mark- 百度统计进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ( ISNSStringValid(self.title)  )
    {
        NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
        [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    }
    
}

#pragma mark- 百度统计退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ( ISNSStringValid(self.title) )
    {
        NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
        [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    }
}

#pragma mark -提示成为嗨客
-(void)showMessageView
{
    HYPaySuccessView * tipsView = NewObject(HYPaySuccessView);
    __weak typeof(self) weakSelf = self;
    tipsView.tipsselect = ^(NSInteger tipsIndex)
    {
        if ( tipsIndex == 1 ) {
            JoinUSViewController * joinUSVC=[[JoinUSViewController alloc]init];
            [weakSelf.navigationController pushViewController:joinUSVC animated:YES];
        }
    };
    tipsView.frame = [[UIScreen mainScreen] bounds];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:tipsView];
    //    [UIAppWindow addSubview:tipsView];
}

#pragma mark -判断是否具有嗨客资格
-(void)onRequrest
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/user/hikeCondition/query" paramters:nil completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         
         
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         if ( [[[response.responseDictionary HYNSDictionaryValueForKey:@"data"] HYValueForKey:@"role_mark"] integerValue] == 5 )
         {
             [self showMessageView];
         }
     }];
}
@end
