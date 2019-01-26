//
//  haiKeProtocolViewController.m
//  嗨云项目
//
//  Created by 小辉 on 16/10/13.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "haiKeProtocolViewController.h"
#import "MKWebViewController.h"
#import "UIColor+MKExtension.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
@interface haiKeProtocolViewController ()

@end

@implementation haiKeProtocolViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title=@"嗨客协议";
    self.ProtocolSureBtn.selected=YES;
    self.ProtocolRuleBtn.userInteractionEnabled=YES;
    self.ProtocolJoinBtn.backgroundColor=[UIColor colorWithHexString:@"ff2741"];
    
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"我已阅读并同意《嗨客推广合作协议》"];
    
    
    [AttributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"484643"]} range:NSMakeRange(7, 10)];
    [AttributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"484643"]} range:NSMakeRange(0, 7)];
    [AttributedStr addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}range:NSMakeRange(8, 8)];
    
    [self.ProtocolRuleBtn setAttributedTitle:AttributedStr forState:0];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)ProtocolJoinBtnClick:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/create/haike/protocol" paramters:nil completion:^(MKHttpResponse *response)
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
- (IBAction)ProtocolSureBtnClick:(id)sender {
    if (!self.ProtocolSureBtn.selected) {
        self.ProtocolSureBtn.selected=YES;
          [self.ProtocolSureBtn setImage:[UIImage imageNamed:@"xuanzhongProtocol"] forState:UIControlStateNormal];
        self.ProtocolJoinBtn.userInteractionEnabled=YES;
        self.ProtocolJoinBtn.backgroundColor=[UIColor colorWithHexString:@"ff2741"];
    }else{
        self.ProtocolSureBtn.selected=NO;
        self.ProtocolJoinBtn.userInteractionEnabled=NO;
        self.ProtocolJoinBtn.backgroundColor=[UIColor colorWithHexString:@"A6A6A7"];
        [self.ProtocolSureBtn setImage:[UIImage imageNamed:@"noxuanzhongProtocol"] forState:UIControlStateNormal];
    }

}
- (IBAction)ProtocolRuleBtnClick:(id)sender {
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
