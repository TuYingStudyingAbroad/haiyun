//
//  MKDetailWebViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDetailWebViewController.h"
#import <PureLayout.h>

@interface MKDetailWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSString *url;

@end


@implementation MKDetailWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self.view addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    [self.delegate subViewControllerViewDidLoad:self];
}

- (UIScrollView *)getScrollView
{
    return self.webView.scrollView;
}

- (void)loadUrl:(NSString *)url
{
    self.url = url;
    if (self.webView != nil)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

@end
