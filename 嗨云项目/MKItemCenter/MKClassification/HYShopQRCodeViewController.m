//
//  HYShopQRCodeViewController.m
//  嗨云项目
//
//  Created by haiyun on 16/8/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYShopQRCodeViewController.h"
#import "HYShopQRCodeView.h"
#import "MKNetworking+BusinessExtension.h"

@interface HYShopQRCodeViewController ()<HYBaseViewDelegate>
{
    HYShopQRCodeView    *_pView;
}

@end

@implementation HYShopQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店铺二维码";
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
        _pView = NewObject(HYShopQRCodeView);
        _pView.QRCodeStr = self.QRCodeStr;
        _pView.frame = rect;
        _pView.baseDelegate = self;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.frame = rect;
    }
}



@end
