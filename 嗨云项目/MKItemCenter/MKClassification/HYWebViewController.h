//
//  HYWebViewController.h
//  嗨云项目
//
//  Created by haiyun on 16/9/24.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKTestJSObject.h"
#import "MKWebAppClientObject.h"

@interface HYWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,strong)MKTestJSObject *testJO;
@property (nonatomic,strong)MKWebAppClientObject *appClient;
@property (nonatomic, assign) BOOL disablePullRefresh;
@property (nonatomic, assign) BOOL isConfiguration;
- (void)loadUrls:(NSString *)urlString;

- (void)webViewTitle:(NSString *)title;

- (void)customTopView:(UIView *)view;

@end
