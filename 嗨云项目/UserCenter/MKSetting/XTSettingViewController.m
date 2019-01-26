//
//  XTSettingViewController.m
//  嗨云项目
//
//  Created by 唯我独尊 on 16/8/29.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "XTSettingViewController.h"
#import "MKWebViewController.h"
#import <PureLayout.h>
#import "BaiduMobStat.h"
#import "MKNetworking+BusinessExtension.h"
#import "PersonZLViewController.h"
#import "HYAccounSafeViewController.h"
#import "HYSystemLoginMsg.h"
#import "MKConsigneeListViewController.h"
#import "UIViewController+MKExtension.h"
#import "SDImageCache.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKItemDetailViewController.h"
#import "HYShareKit.h"
#import "HYShareInfo.h"
#import "HYShareActivityView.h"
#import "QYSDK.h"
#import "AppDelegate.h"
#import "HYCommon.h"
@interface XTSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bbhLabel;
@property (weak, nonatomic) IBOutlet UILabel *hcLabel;

@end

@implementation XTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%@",IosAppVersion);
    self.bbhLabel.text = [NSString stringWithFormat:@"嗨云V%@",IosAppVersion];
    self.hcLabel.text = [NSString stringWithFormat:@"%.1fMB",[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0];
    // Do any additional setup after loading the view from its nib.
}
//清除缓存
- (IBAction)qchcBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定清除缓存吗？" message:[NSString stringWithFormat:@"当前图片缓存 %.1fMB",[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];//图片缓存
    alert.tag = 110;
    [alert show];

}
//关于嗨云
- (IBAction)gyhyBtn:(id)sender {
    
    MKWebViewController *vc = [[MKWebViewController alloc] init];
    [vc loadUrls:[NSString stringWithFormat:@"%@/about.html",BaseHtmlURL]];
    [vc webViewTitle:@"关于嗨云"];
    [self.navigationController pushViewController:vc animated:YES];
}
//退出登录
- (IBAction)LogOutBtn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您确定退出当前账号吗？"
                                                       delegate:self cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"退出", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1 && alertView.tag == 110) {
        
        //[[SDImageCache sharedImageCache] clearDisk];//清除本地磁盘的缓存数据
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
            
            [MBProgressHUD showMessageIsWait:@"清除成功" wait:YES];
            self.hcLabel.text = @"0M";
            // 清除完毕的处理。
            
        }];
        return;
        
    }
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        [getUserCenter loginoutGotoMain];
    }
    
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
