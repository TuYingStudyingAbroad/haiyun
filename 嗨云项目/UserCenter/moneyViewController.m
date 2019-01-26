//
//  moneyViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "moneyViewController.h"
#import "WXHBankCardViewController.h"
#import "bankDetailViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"

@interface moneyViewController ()<WXHBankCardViewControllerDelegate,UITextFieldDelegate>
{
    NSString * withdrawalsNumber;
    BOOL isHaveDian;
}
//银行卡logo
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImgV;
//银行卡名字
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
//银行卡尾号
@property (weak, nonatomic) IBOutlet UILabel *bankNumLab;
//提现金额
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
//银行卡类型
@property (weak, nonatomic) IBOutlet UILabel *bankStyleLab;
//默认银行卡
@property (weak, nonatomic) IBOutlet UILabel *isDefaultLab;
//提示最低提多少
@property (weak, nonatomic) IBOutlet UILabel *showLab;


@end

@implementation moneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提现";
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain
                                                                       target:self action:@selector(completeBtnClick:)];
   
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.moneyTF.placeholder= [NSString stringWithFormat:@"最多可提现金额为%@元",self.order.wdConfigMaxnum];
    self.showLab.text=self.order.wdConfigText;

    [self getData];
   
    
}
-(void)getData{
    NSLog(@"%@",self.order);
    self.bankNumLab.text=[NSString stringWithFormat:@"尾号 %@",self.order.bankLastNO];
    self.bankNameLab.text=self.order.bankName;
   
    if ([[NSString stringWithFormat:@"%@",self.order.bankIsdefault]isEqualToString:@"0"]) {
        self.isDefaultLab.hidden=NO;
    }else{
        self.isDefaultLab.hidden=YES;
    }
    
    if ([[NSString stringWithFormat:@"%@",self.order.bankType]isEqualToString:@"1"]) {
        self.bankStyleLab.text=@"储蓄卡";
    }else{
        self.bankStyleLab.text=@"信用卡";
    }
    self.bankLogoImgV.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.order.bankName]];

}



//选折银行卡的按钮点击
- (IBAction)selectBankBtnClick:(id)sender {
    WXHBankCardViewController * wxhBankCardVC=[[WXHBankCardViewController alloc]init];
    wxhBankCardVC.canSelected=YES;
    wxhBankCardVC.changeTitle=YES;
    wxhBankCardVC.delegate=self;
    [self.navigationController pushViewController:wxhBankCardVC animated:YES];
}

-(void)didSelectBank:(WXHBankListObject *)bankListObject{
    self.order=(WXHBankListObject *)bankListObject;
    [self getData];

    
}

//提交
-(void)completeBtnClick:(id)sender{
    if (self.moneyTF.text.length==0) {
        [MBProgressHUD showMessageIsWait:@"请输入提现金额"  wait:YES];
        return;
    }
    if (self.moneyTF.text.floatValue==0) {
        [MBProgressHUD showMessageIsWait:@"提现金额不能为0元"  wait:YES];
        return;
    }
    NSLog(@"%f",self.order.wdConfigMaxnum.floatValue);
    NSLog(@"%f",self.moneyTF.text.floatValue);
    if (self.moneyTF.text.length>18) {
        [MBProgressHUD showMessageIsWait:@"可提现余额不足"  wait:YES];
        return;
        
    }
    
    NSString * bankNo=self.order.bankNO;
    
    NSLog(@"%@",bankNo);
    NSString * moneyAmoun=[NSString stringWithFormat:@"%@",self.moneyTF.text];
    NSLog(@"%@",moneyAmoun);
    NSMutableDictionary *param =
    [NSMutableDictionary dictionaryWithDictionary:@{@"withdrawals_no" : bankNo,
                                                    @"withdrawals_amount" : moneyAmoun}];
     MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
     [MKNetworking MKSeniorPostApi:@"/myaccount/withdrawals/apply" paramters:param completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         if (response.errorMsg != nil)
         {
             NSLog(@"%@",response.errorMsg);
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             // self.tableView.hidden = YES;
             return ;
         }
         NSLog(@"提交%@",response.responseDictionary);
         withdrawalsNumber=response.responseDictionary[@"data"][@"withdrawals_number"];
         bankDetailViewController * bankDetailVC=[[bankDetailViewController alloc]init];
         bankDetailVC.withdrawalsNumber=withdrawalsNumber;
         bankDetailVC.showComplete=YES;
         bankDetailVC.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:bankDetailVC animated:YES];
         
         
     }];

    
    
    }


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [MBProgressHUD showMessageIsWait:@"亲，第一个数字不能为小数点" wait:YES];
                   
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
           //     [MBProgressHUD showMessageIsWait:@"亲，第一个数字不能为0" wait:YES];
//
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
                    
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [MBProgressHUD showMessageIsWait:@"亲，您已经输入过小数点了" wait:YES];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        [MBProgressHUD showMessageIsWait:@"亲，您最多输入两位小数" wait:YES];

                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [MBProgressHUD showMessageIsWait:@"亲，您输入的格式不正确" wait:YES];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


@end
