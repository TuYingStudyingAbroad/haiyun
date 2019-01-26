//
//  UIAgreeWebViewController.m
//  嗨云项目
//
//  Created by haiyun on 2016/10/24.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "UIAgreeWebViewController.h"

@interface UIAgreeWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation UIAgreeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0.0f, Main_Screen_Width, Main_Screen_Height-64.0f)];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadHTMLString:self.htmlUrl baseURL:nil];
    [self.view addSubview:self.webView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"AllBack" highlightedIcon:@"AllBack" target:self action:@selector(leftBarButtonClicks)];
    self.title = self.titles;
}


-(void)leftBarButtonClicks
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
