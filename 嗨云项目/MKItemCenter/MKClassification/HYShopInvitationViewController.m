//
//  HYShopInvitationViewController.m
//  嗨云项目
//
//  Created by haiyun on 16/8/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYShopInvitationViewController.h"
#import "HYShopInvitationView.h"
#import "HYShopReShareViewController.h"
#import "MKWebViewController.h"

@interface HYShopInvitationViewController ()<HYBaseViewDelegate>
{
    HYShopInvitationView    *_pView;
}

@end

@implementation HYShopInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请赚钱";
    [self initsubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initsubView
{
    CGRect rect = CGRectMake(0, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    rect.size.height = self.view.frame.size.height - rect.origin.y;
    if ( _pView == nil)
    {
        _pView = NewObject(HYShopInvitationView);
        _pView.frame = rect;
        _pView.baseDelegate = self;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.frame = rect;
    }
}

-(void)OnPushController:(NSInteger)nMsgType wParam:(id)wParam
{
    if ( nMsgType == 0 )
    {
        if ( [wParam integerValue] == 0 )
        {
            HYShopReShareViewController *shopVc = [[HYShopReShareViewController alloc] init];
            shopVc.shopShareType = 0;
            [self.navigationController pushViewController:shopVc animated:YES];
        }else if( [wParam integerValue] == 1 )
        {
            MKWebViewController *class = [[MKWebViewController alloc]init];
            [class loadUrls:[NSString stringWithFormat:@"http://m.haiyn.com/merchant-customer.html?disable-app-share=1&user_id=%@",self.shopUserId]];
            [self.navigationController pushViewController:class animated:YES];
        }
    }
    else if( nMsgType == 1 )
    {
        if ( [wParam integerValue] == 1 )
        {
            HYShopReShareViewController *shopVc = [[HYShopReShareViewController alloc] init];
            shopVc.shopShareType = 1;
            [self.navigationController pushViewController:shopVc animated:YES];
        }
    }
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
