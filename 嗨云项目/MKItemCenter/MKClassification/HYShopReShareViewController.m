//
//  HYShopReShareViewController.m
//  嗨云项目
//
//  Created by haiyun on 16/8/24.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYShopReShareViewController.h"
#import "HYShopReShareView.h"
#import "MKNetworking+BusinessExtension.h"

@interface HYShopReShareViewController ()<HYBaseViewDelegate>
{
    HYShopReShareView       *_pView;
}

@end

@implementation HYShopReShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ( self.shopShareType )
    {
        self.title = @"新手注册";
    }else
    {
        self.title = @"开店二维码";
    }
    [self initsubView];
    [self updateIsSeller];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initsubView
{
    CGRect rect = CGRectMake(0, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    rect.size.height = self.view.frame.size.height - rect.origin.y;
    if ( _pView == nil )
    {
        _pView = NewObject(HYShopReShareView);
        _pView.frame = rect;
        _pView.baseDelegate = self;
        _pView.shopShareType = self.shopShareType;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.frame = rect;
    }
}

#pragma mark -获取店铺信息
-(void)updateIsSeller
{
    [MKNetworking MKSeniorGetApi:@"/seller/center/get" paramters:nil completion:^(MKHttpResponse *response) {
        
        if (response.errorMsg) {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        if ( _pView )
        {
            self.QRCodeStr = [NSString stringWithFormat:@"%@",response.mkResponseData[@"seller_info"][@"inviter_code_url"]];
            [_pView setQRCodeStr:self.QRCodeStr];
        }
    }];
    
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
