//
//  MKWebViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/5/8.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKTestJSObject.h"
#import "MKWebAppClientObject.h"


@interface MKWebViewController : MKBaseViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,strong)MKTestJSObject *testJO;
@property (nonatomic,strong)MKWebAppClientObject *appClient;
@property (nonatomic, assign) BOOL disablePullRefresh;
@property (nonatomic, assign) BOOL isConfiguration;
- (void)loadUrls:(NSString *)urlString;

- (void)webViewTitle:(NSString *)title;

- (void)customTopView:(UIView *)view;

@end
