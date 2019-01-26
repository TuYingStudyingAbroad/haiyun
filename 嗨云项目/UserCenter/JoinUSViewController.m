//
//  JoinUSViewController.m
//  嗨云项目
//
//  Created by 小辉 on 16/9/1.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "JoinUSViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKWebViewController.h"
@interface JoinUSViewController ()

@end

@implementation JoinUSViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title=@"成为嗨客";
    self.sureBtn.selected=YES;
    self.joinBtn.userInteractionEnabled=YES;
    self.joinBtn.backgroundColor=[UIColor colorWithHexString:@"ff2741"];
    
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"我已阅读并同意《嗨客推广合作协议》"];
    
 
    [AttributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(7, 10)];
     [AttributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, 7)];
    [AttributedStr addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}range:NSMakeRange(8, 8)];

    [self.ruleBtn setAttributedTitle:AttributedStr forState:0];
    
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sureBtnClick:(id)sender {
    if (!self.sureBtn.selected) {
         self.sureBtn.selected=YES;
         self.joinBtn.userInteractionEnabled=YES;
        self.joinBtn.backgroundColor=[UIColor colorWithHexString:@"ff2741"];
    }else{
        self.sureBtn.selected=NO;
        self.joinBtn.userInteractionEnabled=NO;
        self.joinBtn.backgroundColor=[UIColor colorWithHexString:@"A6A6A7"];

    }
  
}
- (IBAction)joinBtnClick:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/create/seller/haike" paramters:nil completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
          [MBProgressHUD showMessageIsWait:@"恭喜您成为嗨客" wait:YES];
             [self.navigationController popToRootViewControllerAnimated:YES];
     }];
   
}
- (IBAction)ruleBtnClick:(id)sender {
    MKWebViewController *vc = [[MKWebViewController alloc] init];
    [vc loadUrls:[NSString stringWithFormat:@"%@/haike-agreement.html",BaseHtmlURL]];
    [vc webViewTitle:@"嗨客推广合作协议"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
