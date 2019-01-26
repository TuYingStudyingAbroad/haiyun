//
//  MKClassificationViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/5/8.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "HYClassificationViewController.h"
#import "UIViewController+MKExtension.h"
#import "MKSearchViewController.h"
#import "MKProductListViewController.h"
#import "MKSearchBar.h"
#import "UIColor+MKExtension.h"
#import <PureLayout.h>
#import "AppDelegate.h"


@interface HYClassificationViewController () <MKSearchViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MKSearchBar *searchBar;

@property (nonatomic, strong) MKSearchViewController *searchViewController;

@property (nonatomic,strong)UIBarButtonItem *closeItem;

@property (nonatomic,strong) UIBarButtonItem *backItem;

@property (nonatomic,strong)UIButton *backBut;

@end


@implementation HYClassificationViewController

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
    
//    NSLog(@"%@",getAppConfig.commonToken);
    
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        barView.backgroundColor = [UIColor whiteColor];
        [barView autoSetDimension:ALDimensionHeight toSize:64];
    
        self.searchBar = [[MKSearchBar alloc] init];
        self.searchBar.delegate = self;
        self.searchBar.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        [self.searchBar enableBorder:YES];
    
    
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHex:0xe9e9e9];
        [barView addSubview:lineView];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
        [lineView autoSetDimension:ALDimensionHeight toSize:1.0f];
        [lineView autoSetDimension:ALDimensionWidth toSize:Main_Screen_Width];
    
        if (!self.isBacks)
        {
            self.backBut = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [_backBut setImage:[UIImage imageNamed:@"AllBack"] forState:(UIControlStateNormal)];
            [_backBut addTarget:self action:@selector(backButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
            [barView addSubview:_backBut];
            [_backBut autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:12];
            [_backBut autoAlignAxis:ALAxisHorizontal toSameAxisOfView:barView withOffset:10];
        }
    
    
    
        [barView addSubview:self.searchBar];
    if (!self.isBacks)
    {
        [self.searchBar autoPinEdge:(ALEdgeLeft) toEdge:(ALEdgeRight) ofView:_backBut withOffset:12];
    }else
    {
        [self.searchBar autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:12];
    }
    
        [self.searchBar autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:12];
        [self.searchBar autoSetDimension:ALDimensionHeight toSize:25];
        [self.searchBar autoAlignAxis:ALAxisHorizontal toSameAxisOfView:barView withOffset:10];
    
    
    
        [self customTopView:barView];
    
//    self.backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AllBack"]
//                                                     style:UIBarButtonItemStylePlain target:self
//                                                    action:@selector(backButtonClick)];
//    
//    self.navigationItem.leftBarButtonItems = nil;
    
    
    
    [self loadUrls:categoriesfenleiUrl];
}
- (void)backButtonClick
{
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
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urls = request.URL.absoluteString;
    if ([urls isEqualToString:categoriesfenleiUrl])
    {
        return YES;
    }
    return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
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
}
- (void)searchViewController:(MKSearchViewController *)searchViewController needSearchWord:(NSString *)word
{
     [self.searchViewController dismiss];
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
