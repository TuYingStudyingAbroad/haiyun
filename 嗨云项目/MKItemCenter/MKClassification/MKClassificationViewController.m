//
//  MKClassificationViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/5/8.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKClassificationViewController.h"
#import "UIViewController+MKExtension.h"
#import "MKSearchViewController.h"
#import "MKProductListViewController.h"
#import "MKSearchBar.h"
#import "UIColor+MKExtension.h"
#import <PureLayout.h>
#import "MKPlaceTheOrderController.h"
#import "AppDelegate.h"
#import "MKUrlGuide.h"
#import <PureLayout.h>
#import "MKWebViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"

@interface MKClassificationViewController () <MKSearchViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MKSearchBar *searchBar;

@property (nonatomic, strong) MKSearchViewController *searchViewController;

@property (nonatomic,strong)UIBarButtonItem *closeItem;

@property (nonatomic,strong) UIBarButtonItem *backItem;

@property (nonatomic,strong)NSString *success_callback;


@property (nonatomic,strong)NSDictionary *dic;
@property(nonatomic,assign)UIStatusBarStyle myStatusBarStyle;

@end


@implementation MKClassificationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AllBack"]
                                                     style:UIBarButtonItemStylePlain target:self
                                                    action:@selector(backButtonClick)];
    
    self.navigationItem.leftBarButtonItems = nil;
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-20.0f];
    self.myStatusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    [self loadUrls:categoriesUrl];
    
}



- (void)updataUrl{
    [self loadUrls:categoriesUrl];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.myStatusBarStyle;
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
- (void)closeButtonClick{
    if (self.navigationController.viewControllers[0] == self && self.presentingViewController != nil)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self updataUrl];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urls = request.URL.absoluteString;
    if ([urls rangeOfString:@"merchant-login.html"].location != NSNotFound || [urls isEqualToString:@"about:blank"])
    {
        self.myStatusBarStyle = UIStatusBarStyleDefault;
        [self setNeedsStatusBarAppearanceUpdate];
        return YES;
    }
    if ([urls isEqualToString:categoriesUrl]) {
        self.myStatusBarStyle = UIStatusBarStyleLightContent;
        [self setNeedsStatusBarAppearanceUpdate];
        return YES;
    }
    if ( [urls rangeOfString:@"merchant.html"].location != NSNotFound  ) {
        return [[MKUrlGuide commonGuide] guideForUrl:urls];
    }
    if ([[MKUrlGuide commonGuide] guideIgnoreWebVCForUrl:urls]) {
       return NO;
    }
   
    MKWebViewController *class = [[MKWebViewController alloc]init];
    [class loadUrls:urls];
    [self.navigationController pushViewController:class animated:YES];
    return NO;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.searchViewController = [[MKSearchViewController alloc] init];
    self.searchViewController.delegate = self;
    [self.searchViewController showInViewController:self withOriginSearchBar:self.searchBar];
    return NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    if (webView.canGoBack) {
        //显示
        if (self.isConfiguration) {
            self.navigationItem.leftBarButtonItems = @[self.backItem];
            
        }else {
            self.navigationItem.leftBarButtonItems = @[self.backItem];
        }
    }else{
        if (self.isConfiguration) {
            self.navigationItem.leftBarButtonItems = nil;
        }else {
            self.navigationItem.leftBarButtonItems = @[self.backItem];
        }
    }
    self.navigationItem.rightBarButtonItem = nil;
   
}

- (void)searchViewController:(MKSearchViewController *)searchViewController needSearchWord:(NSString *)word
{
    MKProductListViewController *vc = [MKProductListViewController create];
    vc.keyWord = word;
    vc.isSearch = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchViewControllerViewWillShow:(MKSearchViewController *)searchViewController
{
    
}

- (void)searchViewControllerViewDidDismiss:(MKSearchViewController *)searchViewController
{
}


@end
