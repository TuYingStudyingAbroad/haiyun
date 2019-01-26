//
//  MKWebViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/5/8.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseViewController.h"

@interface MKWebViewController : MKBaseViewController <UIWebViewDelegate>

@property (nonatomic, assign) BOOL disablePullRefresh;

- (void)loadUrls:(NSString *)urlString;

- (void)webViewTitle:(NSString *)title;

- (void)customTopView:(UIView *)view;

@end
