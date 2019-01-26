//
//  getMoneyTableViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "getMoneyTableViewController.h"
#import "incomDetailViewController.h"
#import "UIViewController+MKExtension.h"
#import "WXHBankCardViewController.h"
#import "moneyViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "WXHBankListObject.h"
#import "haiBiObject.h"
#import <UIAlertView+Blocks.h>
#import "YLSafeBandCardViewController.h"
#import "PersonalInfo.h"
#import "YLSafeBandViewController.h"
#import "WXHDownRefreshHeader.h"
#import "PersonZLViewController.h"
#import "BaiduMobStat.h"
#import "LSSAlertView.h"
@interface getMoneyTableViewController ()
{
    //判断账户的可提现金额是不是0；
    NSString*  isZero;
}
@property (nonatomic,copy) NSString * abc;

@property (nonatomic, assign) UIStatusBarStyle myStatusBarStyle;
@end

@implementation getMoneyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    self.title=@"我的账户";
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    
    WXHDownRefreshHeader * header=[WXHDownRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.header=header;
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
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
         // 拿到当前的下拉刷新控件，结束刷新状态
         [self.tableView.header endRefreshing];
         // 拿到当前的上拉刷新控件，结束刷新状态
         [self.tableView.footer endRefreshing];
         
         if (response.errorMsg != nil)
         {
             self.tableView.footer.hidden = YES;
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         NSDictionary * dic=[response mkResponseData][@"wealth_account"];
         isZero=dic[@"amount"];
         haiBiObject * haibiOBJ=[haiBiObject objectWithDictionary:dic];
         
      
         if ([NSString stringWithFormat:@"%@",dic[@"amount"]].length>10) {
             self.cUsedLab.text=@"99999999+";
         }else{
             self.cUsedLab.text=[NSString stringWithFormat:@"%.2f",haibiOBJ.amount/100.0];
         }
         if ([NSString stringWithFormat:@"%@",dic[@"transition_amount"]].length>10) {
             self.CnUsedLab.text=@"99999999+";
         }else{
         self.CnUsedLab.text=[NSString stringWithFormat:@"%.2f",haibiOBJ.transitionAmount/100.0];
     }
     if([NSString stringWithFormat:@"%@",dic[@"total_amount"]].length>10){
         self.allMoneyLab.text=@"99999999+";

     }else{
         self.allMoneyLab.text=[NSString stringWithFormat:@"%.2f",(long)haibiOBJ.totalAmount/100.0];
     }
     }];
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        
        incomDetailViewController *incomDetail = [incomDetailViewController create];
        incomDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:incomDetail animated:YES];
    }
    if (indexPath.row==3) {
        //判断买卖家和是否实名认证
        [MKNetworking MKSeniorGetApi:@"/myaccount/bank/list" paramters:nil completion:^(MKHttpResponse *response){
            if (response.errorType == MKHttpErrorTypeLocal) {
                [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                return ;
            }
            if ( response.originData ) {
                NSDictionary * getDic=[NSJSONSerialization JSONObjectWithData:response.originData options:NSJSONReadingMutableContainers error:nil];
                [self bankMangerDic:getDic];
            }            
        }];
        
    }
}

//提现按钮
- (IBAction)getMoneyBtnClick:(id)sender {
    
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
-(void)bankMangerDic:(NSDictionary *)dic{
    NSString * code=[NSString stringWithFormat:@"%@",dic[@"code"]];
    NSString * msg=dic[@"msg"];
    if ([code isEqualToString:@"32087"]) {
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return;

    }
    if ([code isEqualToString:@"32091"]) {
        [UIAlertView showWithTitle:@"提示" message:msg cancelButtonTitle:@"取消" otherButtonTitles:@[@"去认证"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                
            }else{
                PersonZLViewController * YLSafeBandCardViewVC=[[PersonZLViewController alloc]init];
                [self.navigationController pushViewController:YLSafeBandCardViewVC animated:YES];
                
            }
            
        }];

        return;
    }
    if ([code isEqualToString:@"10000"]) {
        PersonalInfo * personlInfo=[PersonalInfo sharedModel];
        if (((NSArray*)dic[@"data"]).count) {
            NSDictionary * firstBankDic=dic[@"data"][0];
             personlInfo.nameStr=firstBankDic[@"bank_realname"];
            
           
        }
       
        WXHBankCardViewController * wxhBankCardVC=[[WXHBankCardViewController alloc]init];
        wxhBankCardVC.hidesBottomBarWhenPushed = YES;
        wxhBankCardVC.canSelected=NO;
        [self.navigationController pushViewController:wxhBankCardVC animated:YES];
        
    }
    
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

@end
