//
//  getMoneyViewController.m
//  嗨云项目
//
//  Created by 小辉 on 16/8/29.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "getMoneyViewController.h"
#import "getMoneyHeardView.h"
#import <PureLayout.h>
#import "UIViewController+MKExtension.h"
#import "incomDetailViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "haiBiObject.h"
#import "WXHBankListObject.h"
#import "LSSAlertView.h"
#import <UIAlertView+Blocks.h>
#import "PersonZLViewController.h"
#import "WXHBankListObject.h"
#import "PersonalInfo.h"
#import "moneyViewController.h"
#import "bankEditViewController.h"
#import "haiKeProtocolViewController.h"
@interface getMoneyViewController ()</*incomDetailViewControllerDelegate*/UIScrollViewDelegate>

{
    //判断账户的可提现金额是不是0；
    NSString*  isZero;
}
@property (nonatomic,copy) NSString * abc;

@property (nonatomic, assign) UIStatusBarStyle myStatusBarStyle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong)getMoneyHeardView * geMoneyHView;
@property (nonatomic,strong)incomDetailViewController * incomeDetailVC;

@end

@implementation getMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的账户";
    [self layoutViews];

}

-(getMoneyHeardView *)geMoneyHView{
    if (!_geMoneyHView) {
        self.geMoneyHView=[getMoneyHeardView loadFromXib];
    }
    return _geMoneyHView;
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    [self loadNewData];
}




- (void)loadNewData
{
    [self loadDataIsNew:YES];
}
- (void)loadDataIsNew:(BOOL)isNew{
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/marketing/wealth_account/balance" paramters:nil completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
       
         
         if (response.errorMsg != nil)
         {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         NSDictionary * dic=[response mkResponseData][@"wealth_account"];
         isZero=dic[@"amount"];
         haiBiObject * haibiOBJ=[haiBiObject objectWithDictionary:dic];
         
         
         if ([NSString stringWithFormat:@"%@",dic[@"amount"]].length>10) {
             self.geMoneyHView.cUsedLab.text=@"99999999+";
         }else{
             self.geMoneyHView.cUsedLab.text=[NSString stringWithFormat:@"%.2f",haibiOBJ.amount/100.0];
         }
         if ([NSString stringWithFormat:@"%@",dic[@"transition_amount"]].length>10) {
             self.geMoneyHView.CnUsedLab.text=@"99999999+";
         }else{
             self.geMoneyHView.CnUsedLab.text=[NSString stringWithFormat:@"%.2f",haibiOBJ.transitionAmount/100.0];
         }
         if([NSString stringWithFormat:@"%@",dic[@"total_amount"]].length>10){
             self.geMoneyHView.allMoneyLab.text=@"99999999+";
             
         }else{
             self.geMoneyHView.allMoneyLab.text=[NSString stringWithFormat:@"%.2f",(long)haibiOBJ.totalAmount/100.0];
         }
     }];
}





-(void)layoutViews{
    self.scrollView.scrollEnabled=NO;
   [self.view addSubview:self.geMoneyHView];
   [self.geMoneyHView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.geMoneyHView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [self.geMoneyHView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.geMoneyHView autoSetDimension:ALDimensionHeight toSize:180];
    [self.geMoneyHView.tiXianBtn addTarget:self action:@selector(tiXianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.incomeDetailVC=[incomDetailViewController  create];
    UIView *v = self.incomeDetailVC.view;
    [self addChildViewController:self.incomeDetailVC];
    [self.view addSubview:v];
    
    [v autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    
    [v autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.geMoneyHView withOffset:5];
    
    [v autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];

     [v autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view ];

//    [v autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view withOffset:180];
    
     //self.incomeDetailVC.delegate = self;
   // [self.scrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:v];
    
}

//- (void)detailDetailViewControllerNeedScrollToTop
//{
//    
//   
//    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat y = scrollView.contentOffset.y;
//    if (y > scrollView.contentSize.height - scrollView.frame.size.height -
//        scrollView.frame.size.height * 0.25 && scrollView.scrollEnabled)
//    {
//        scrollView.scrollEnabled = NO;
//        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height) animated:YES];
//        [self.incomeDetailVC enableScroll:YES];
//    }
//    else 
//    if (y==0) {
//        scrollView.scrollEnabled = YES;
//        [self.incomeDetailVC enableScroll:NO];
//    }
////    
////    NSLog(@"yyyy%f",y);
////    NSLog(@"kkk%f",scrollView.contentSize.height - scrollView.frame.size.height - scrollView.frame.size.height * 0.5);
////    
//}

-(void)tiXianBtnClick{
    //判断是否实名认证
    [MKNetworking MKSeniorGetApi:@"/myaccount/withdrawals/choicebanklist" paramters:nil completion:^(MKHttpResponse *response){
        NSLog(@"%@",response.responseDictionary);
        if (response.errorType == MKHttpErrorTypeLocal) {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        
        if ( response.originData ) {
            NSDictionary * getDic=[NSJSONSerialization JSONObjectWithData:response.originData options:NSJSONReadingMutableContainers error:nil];
            
            [self checkWithDic:getDic];
        }
        
        
    }];

}
-(void)checkWithDic:(NSDictionary *)getDic {
    NSString * code=[NSString stringWithFormat:@"%@",getDic[@"code"]];
    NSString * msg=getDic[@"msg"];
    //没有手机号
    if ([code isEqualToString:@"32086"]) {
        //        [UIAlertView showWithTitle:@"提示" message:msg cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        //            if (buttonIndex==0) {
        //
        //            }else{
        //                YLSafeBandViewController *pVc = [[YLSafeBandViewController alloc] init];
        //                pVc.nsPhoneNum = nil;
        //                pVc.nsPhoneType = 6;
        //                pVc.nsIsCard = YES;
        //                [self.navigationController pushViewController:pVc animated:YES];
        //            }
        //
        //        }];
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        
        return ;
    }
    
    if ([[NSString stringWithFormat:@"%@",isZero] isEqualToString:@"0"]) {
        [MBProgressHUD showMessageIsWait:@"当前无余额可提现" wait:YES];
        return;
        
    }
    
    //没有在规定的时间操作
    if ([code isEqualToString:@"32076"]) {
        // [MBProgressHUD showMessageIsWait:msg wait:YES];
        LSSAlertView *alert = [[LSSAlertView alloc] initWithTitle:@"温馨提示" message:msg sureBtn:@"我知道了" cancleBtn:@"nil"];
        alert.returnIndex = ^(NSInteger index){
        };
        [alert showAlertView];
        
        return;
    }
    
    //没有实名认证
    if ([code isEqualToString:@"32071"]) {
        [UIAlertView showWithTitle:@"提示" message:msg cancelButtonTitle:@"取消" otherButtonTitles:@[@"去认证"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                
            }else{
                PersonZLViewController * YLSafeBandCardViewVC=[[PersonZLViewController alloc]init];
                [self.navigationController pushViewController:YLSafeBandCardViewVC animated:YES];
                
            }
            
        }];
        
        return ;
    }
    //已经实名认证但是没卡
    if ([code isEqualToString:@"32082"]) {
        [UIAlertView showWithTitle:@"提示" message:@"尚未绑定银行卡，是否去绑定银行卡？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                
            }else{
                bankEditViewController * bankEditVC=[bankEditViewController create];
                PersonalInfo * personlInfo=[PersonalInfo sharedModel];
                personlInfo.nameStr=msg;
                [self.navigationController pushViewController:bankEditVC animated:YES];
            }
        }];
        return;
    }
    //老用户没有遵守嗨云协议
    if ([code isEqualToString:@"33001"]) {
        [UIAlertView showWithTitle:@"提示" message:msg cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                
            }else{
                haiKeProtocolViewController *haiKeProtocolVC=[[haiKeProtocolViewController alloc]init];
                
                [self.navigationController pushViewController:haiKeProtocolVC animated:YES];
            }
        }];
        return;
    }
    
    
    //已经实名认证
    if ([code isEqualToString:@"10000"]) {
        NSArray *arr=getDic[@"data"];
        NSDictionary * realBankDic=[[NSDictionary alloc]init];
        if (arr.count) {
            realBankDic=arr[0];
        }else{
            [MBProgressHUD showMessageIsWait:@"网络错误" wait:YES];
             return;
        }
        
        NSLog(@"f%@",realBankDic);
        PersonalInfo * personlInfo=[PersonalInfo sharedModel];
        personlInfo.nameStr=realBankDic[@"bank_realname"];
        
        
        WXHBankListObject * realBankOBJ=[WXHBankListObject objectWithDictionary:realBankDic];
        moneyViewController * moneyVC=[moneyViewController create];
        moneyVC.hidesBottomBarWhenPushed=YES;
        moneyVC.order=realBankOBJ;
        [self.navigationController pushViewController:moneyVC animated:YES];
        return ;
    }
    //其他的错误
    else{
        
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return ;
    }
    
    
}


@end
