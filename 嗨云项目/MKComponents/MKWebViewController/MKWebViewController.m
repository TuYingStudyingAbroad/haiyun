//
//  MKWebViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/5/8.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKWebViewController.h"
#import "AppDelegate.h"
#import <MJRefresh.h>
#import "MKUrlGuide.h"
#import <PureLayout.h>
#import "MBProgressHUD+MKExtension.h"

@interface MKWebViewController ()

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSLayoutConstraint *webViewTopConstraint;

@property (nonatomic, strong) UIView *customTopView;

@property (nonatomic, strong) NSString *blankHTML;

@end


@implementation MKWebViewController

- (void)dealloc
{
    [self.webView.scrollView removeHeader];
    [self removeObserver:self forKeyPath:@"disablePullRefresh"];
    [self.webView.scrollView.header endRefreshing];
    [self.webView.scrollView removeHeader];
    self.webView.delegate = nil;
    [self.webView stopLoading];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] init];
    self.blankHTML = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blank" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:self.blankHTML baseURL:nil];
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = NO;
    [self.view addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    self.webViewTopConstraint = [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator autoCenterInSuperview];
    
    if (self.urlString != nil)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        });
    }
    
    [self updatePullRefreshStatus];
    [self addObserver:self forKeyPath:@"disablePullRefresh" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_back_toward_gray20x23"]
                                                                             style:UIBarButtonItemStylePlain target:self
                                                                            action:@selector(backButtonClick)];
}

- (void)backButtonClick
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
        return;
    }
    if (self.navigationController.viewControllers[0] == self && self.presentingViewController != nil)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"disablePullRefresh"])
    {
        [self updatePullRefreshStatus];
    }
}

- (void)loadUrls:(NSString *)urlString
{
    self.urlString = urlString;
    if (self.webView != nil)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        });
    }
}

- (void)customTopView:(UIView *)view
{
    [self.view removeConstraint:self.webViewTopConstraint];
    self.webViewTopConstraint = nil;
    [self.customTopView removeFromSuperview];
    
    [self.view addSubview:view];
    [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [view autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.webView];
    
    self.customTopView = view;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, getMainTabBar.tabBar.frame.size.height, 0);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urls = request.URL.absoluteString;
    return ![[MKUrlGuide commonGuide] guideIgnoreWebVCForUrl:urls];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView.scrollView.header endRefreshing];
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    
    if (self.title == nil)
    {
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.webView.scrollView.header endRefreshing];
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    
    if ([error code] == NSURLErrorCancelled) return;
    [MBProgressHUD showMessage:@"加载失败了" wait:NO];
    [self.webView loadHTMLString:self.blankHTML baseURL:nil];
}

- (void)webViewTitle:(NSString *)title
{
    self.title = title;
}

- (void)updatePullRefreshStatus
{
    if (self.disablePullRefresh)
    {
        [self.webView.scrollView removeHeader];
    }
    else
    {
        UIWebView *webView = self.webView;
        NSString *urlString = self.urlString;
        MJRefreshHeader *header = [self.webView.scrollView addLegendHeaderWithRefreshingBlock:^
        {
            if ([webView.request.URL.absoluteString isEqualToString:@"about:blank"])
            {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
            }
            else
            {
                [webView reload];
            }
        }];
        header.updatedTimeHidden = YES;
    }
}

@end
