//
//  MKWebViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/5/8.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKWebViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "MKUrlGuide.h"
#import <PureLayout.h>
#import "MBProgressHUD+MKExtension.h"
#import "HYShareActivityView.h"
#import "HYShareInfo.h"
#import "HYShareKit.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SDWebImageManager.h"
#import "MKPlaceTheOrderController.h"
#import "WXHDownRefreshHeader.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "UIAlertView+Blocks.h"
#import "MKNetworking+BusinessExtension.h"

@interface MKWebViewController ()<MKPlaceTheOrderDelegate>

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) NSString *sttUrl;


@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSLayoutConstraint *webViewTopConstraint;

@property (nonatomic, strong) UIView *customTopView;

@property (nonatomic, strong) NSString *blankHTML;

@property (nonatomic, strong) HYShareActivityView *activityView;

@property (nonatomic, strong) HYShareActivityView *shareView;

@property (nonatomic, strong) NSString *appShareTitle;
@property (nonatomic, strong) NSString *appShareDesc;
@property (nonatomic, strong) NSString *appShareUrl;
@property (nonatomic, strong) NSString *appShareImage;

@property (nonatomic, strong) NSDictionary *dic;


@property (nonatomic,strong)UIBarButtonItem *closeItem;

@property (nonatomic,strong) UIBarButtonItem *backItem;


@property (nonatomic,strong)JSContext *context;
@end


@implementation MKWebViewController

- (void)dealloc
{
    self.webView.delegate = nil;
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    self.webView = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.dic = [NSDictionary dictionary];
    // Do any additional setup after loading the view.
    self.testJO=[[MKTestJSObject alloc]init];
    self.appClient = [[MKWebAppClientObject alloc]init];
    self.isFirst = true;
    self.webView = [[UIWebView alloc] init];
    self.blankHTML = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blank" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:self.blankHTML baseURL:nil];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = NO;
    self.webView.backgroundColor = [UIColor clearColor];
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
    
    //    [self addObserver:self forKeyPath:@"disablePullRefresh" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    self.backItem = [UIBarButtonItem itemWithIcon:@"AllBack" highlightedIcon:@"AllBack" target:self action:@selector(backButtonClick)];
//    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AllBack"]
//                                                                             style:UIBarButtonItemStylePlain target:self
//                                                                            action:@selector(backButtonClick)];
    
    self.closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"X_19x19"]
                                                                 style:UIBarButtonItemStylePlain target:self
                                                                action:@selector(closeButtonClick)];
    if (self.isConfiguration)
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    
}

- (void)weiShopnoTification:(NSDictionary *)text{
    self.dic = text;
    NSInteger shareContentType =[self.dic[@"data"][@"share_content_type"] integerValue];
    if ([self.dic[@"data"][@"app_share_type"] integerValue]) {
        NSInteger shareType = [self.dic[@"data"][@"app_share_type"] integerValue];
        switch (shareType) {
            case 1:
                [self shareHYPlatformType:HYPlatformTypeWeixiSession with:shareContentType];
                break;
            case 2:
                [self shareHYPlatformType:HYPlatformTypeWeixiTimeline with:shareContentType];
                break;
            case 3:
                [self shareHYPlatformType:HYPlatformTypeSinaWeibo with:shareContentType];
                break;
            case 4:
                [self shareHYPlatformType:HYPlatformTypeQQ with:shareContentType];
                break;
            case 5:
                [self shareHYPlatformType:HYPlatformTypeQQSpace with:shareContentType];
                break;
            default:
                break;
        }
        
        return;
    }
    if ( self.shareView == nil )
    {
        _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeQZone),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeQQFriend),@(HYSharePlatformTypeCopy)] shareTypeBlock:^(HYSharePlatformType type)
                                            {
                                                
                                                [self shareMoreActionClick1Type:type];
                                                
                                            }];
        [self.shareView show];
    }else
    {
         [self.shareView show];
    }
    
    
}

-(void)shareMoreActionClick1Type:(NSUInteger)type
{
    //复制链接
    if ( type == 4 )
    {
        [self.shareView hide];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *disStr = self.dic[@"data"][@"app_share_url"];
//        if ([disStr rangeOfString:@"distributor_id"].location == NSNotFound) {
//            if ([disStr rangeOfString:@"?"].location == NSNotFound) {
//                disStr = [NSString stringWithFormat:@"%@?distributor_id=%@",disStr,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//            }else{
//                disStr = [NSString stringWithFormat:@"%@&distributor_id=%@",disStr,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//            }
//        }
        pasteboard.string = disStr;
        [MBProgressHUD showMessageIsWait:@"复制成功" wait:YES];
        return;
    }
    if ( type == 8 )
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.dic[@"data"][@"app_copy_text"];
        NSURL *url = [NSURL URLWithString:self.dic[@"data"][@"app_share_image"]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [MBProgressHUD showMessageIsWait:@"图片素材已保存至手机相册，文字素材已复制到剪贴板，使用时直接粘贴即可" wait:YES];
        }];
    }else
    {
        [self shareHYPlatformType:(HYPlatformType)type with:5];
    }
}
- (void)shareHYPlatformType:(HYPlatformType )type with:(NSInteger )shareContentType{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ( shareContentType == 2 )
        {
            if ( self.dic && ISNSStringValid(self.dic[@"data"][@"app_share_image"]) )
            {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:self.dic[@"data"][@"app_share_image"]]
                                      options:SDWebImageRetryFailed
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize)
                 {
                 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     if ( image )
                     {
                         HYShareInfo *info = [[HYShareInfo alloc] init];
                         info.type = type;
                         info.title = [NSString stringWithFormat:@"%@",self.dic[@"data"][@"app_share_title"]];
                         info.content = self.dic[@"data"][@"app_share_desc"];
                         info.images = image;
                         info.url = self.dic[@"data"][@"app_share_url"];
                         info.type = HYPlatformTypeWeixiSession;
                         info.shareType    = HYShareDKContentTypeImage;
                         [HYShareKit shareImageWeChat:info  completion:^(NSString *errorMsg)
                          {
                              if ( ISNSStringValid(errorMsg) )
                              {
                                  [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
                              }
                          }];
                     }else
                     {
                         [MBProgressHUD showMessageIsWait:@"分享失败！" wait:YES];
                     }
                 }];
                
            }
            else
            {
                [MBProgressHUD showMessageIsWait:@"分享失败！" wait:YES];
            }
        }
        else
        {
            HYShareInfo *info = [[HYShareInfo alloc] init];
            if (shareContentType == 5)
            {
                info.shareType = HYShareDKContentTypeWebPage;
            }
            else if ( shareContentType == 1 )
            {
                info.shareType = HYShareDKContentTypeText;
            }
            else
            {
                info.shareType = HYShareDKContentTypeAuto;
            }
            
            info.type = type;
            info.title = [NSString stringWithFormat:@"%@",self.dic[@"data"][@"app_share_title"]];
            info.content = self.dic[@"data"][@"app_share_desc"];
            info.image = self.dic[@"data"][@"app_share_image"];
            info.url = self.dic[@"data"][@"app_share_url"];
//            if ([info.url rangeOfString:@"distributor_id"].location == NSNotFound) {
//                if ([self.appShareUrl rangeOfString:@"?"].location == NSNotFound) {
//                    info.url = [NSString stringWithFormat:@"%@?distributor_id=%@",info.url,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//                }else{
//                    info.url = [NSString stringWithFormat:@"%@&distributor_id=%@",info.url,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//                }
//            }
            
            [HYShareKit shareInfoWith:info completion:^(NSString *errorMsg)
             {
                 if ( ISNSStringValid(errorMsg) )
                 {
                     [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
                 }
                 [self.shareView hide];
             }];
        }
    });
    
}
- (void)saveMaterial:(NSString *)imageUrl{
    NSURL *url = [NSURL URLWithString:imageUrl];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [MBProgressHUD showMessageIsWait:@"图片素材已保存至手机相册" wait:YES];
    }];
}
- (void)closeButtonClick{
    if (self.navigationController.viewControllers[0] == self && self.presentingViewController != nil)
{
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonClick:(id)sender
{
    if ( self.activityView == nil )
    {
        _activityView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeQZone),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeQQFriend),@(HYSharePlatformTypeCopy)] shareTypeBlock:^(HYSharePlatformType type)
                         {
                             
                             [self shareMoreActionClickType:type];
                             
                         }];
        [self.activityView show];
    }else
    {
        [self.activityView show];
    }
}


- (void)shareMoreActionClickType:(NSInteger)types
{
    //复制链接
    if ( types == 4 )
    {
        [self.activityView hide];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
//        if ([self.appShareUrl rangeOfString:@"distributor_id"].location == NSNotFound) {
//            if ([self.appShareUrl rangeOfString:@"?"].location == NSNotFound) {
//                self.appShareUrl =[NSString stringWithFormat:@"%@?distributor_id=%@",self.appShareUrl,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//               
//            }
//            else{
//                self.appShareUrl =[NSString stringWithFormat:@"%@&distributor_id=%@",self.appShareUrl,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//            }
//        }
        pasteboard.string = self.appShareUrl;
        [MBProgressHUD showMessageIsWait:@"复制成功" wait:YES];
        return;
        
    }
    if ( types == 8 )
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.dic[@"data"][@"app_copy_text"];
        NSURL *url = [NSURL URLWithString:self.dic[@"data"][@"app_share_image"]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [MBProgressHUD showMessageIsWait:@"图片素材已保存至手机相册，文字素材已复制到剪贴板，使用时直接粘贴即可" wait:YES];
        }];
        return;
    }
    else
    {
        HYShareInfo *info = [[HYShareInfo alloc] init];
        info.title = self.appShareTitle;
        info.content = self.appShareDesc;
        info.image = self.appShareImage;
        info.url = self.appShareUrl;
//        if ([info.url rangeOfString:@"distributor_id"].location == NSNotFound) {
//            if ([self.appShareUrl rangeOfString:@"?"].location == NSNotFound) {
//                info.url = [NSString stringWithFormat:@"%@?distributor_id=%@",info.url,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//            }else{
//                info.url = [NSString stringWithFormat:@"%@&distributor_id=%@",info.url,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//            }
//        }
        info.type = (HYPlatformType)types;
        
        [HYShareKit shareInfoWith:info completion:^(NSString *errorMsg)
         {
             if ( ISNSStringValid(errorMsg) )
             {
                 [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
             }
             [self.activityView hide];

         }];
    }
}


- (void)backToHome:(id)sender
{
    [getMainTabBar guideToHome];
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
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urls = request.URL.absoluteString;
    self.sttUrl = urls;
    if ([urls rangeOfString:@"merchant.html"].location != NSNotFound) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return YES;
    }
    
    
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
    
    if (webView.canGoBack) {
        //显示
        if (self.isConfiguration) {
            self.navigationItem.leftBarButtonItems = @[self.backItem];
        }else {
            self.navigationItem.leftBarButtonItems = @[self.backItem,self.closeItem];
        }
        
    }else{
        if (self.isConfiguration) {
            self.navigationItem.leftBarButtonItems = nil;
        }else {
            self.navigationItem.leftBarButtonItems = @[self.backItem];
        }
    }
    self.appShareTitle = nil;
    self.appShareTitle = [webView stringByEvaluatingJavaScriptFromString:@" document.getElementById(\"app-share-title\").value"];
    self.appShareImage = [webView stringByEvaluatingJavaScriptFromString:@" document.getElementById(\"app-share-image\").value"];
    self.appShareUrl = [webView stringByEvaluatingJavaScriptFromString:@" document.getElementById(\"app-share-url\").value"];
    self.appShareDesc = [webView stringByEvaluatingJavaScriptFromString:@" document.getElementById(\"app-share-desc\").value"];
    
    NSString *string = [NSString stringWithFormat:@"%@",self.appShareTitle];
    NSString *urlstring = [NSString stringWithFormat:@"%@",self.appShareUrl];
    
    if (string == nil || [string isEqualToString:@""] ||!string) {
        self.appShareTitle = self.navigationItem.title;
    }
    if (urlstring == nil || [urlstring isEqualToString:@""] || !urlstring) {
        self.appShareUrl = self.urlString;
    }
    //创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    self.context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //创建新建类的对象，将他赋值给js的对象
    
    self.context[@"appNative"] = self.testJO;
    self.context[@"appClient"] = self.appClient;
    
    
    
    
    _testJO.returnStrUrl = ^(NSString *url,NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *js = [NSString stringWithFormat:@"var a = %@;a('%@')",dic[@"success_callback"],url];
            [webView stringByEvaluatingJavaScriptFromString:js];
        });
    };
    __weak typeof(self) weakSelf = self;
    
    self.appClient.returnStrUrl = ^(NSDictionary *dict){
        if (dict) {
           NSInteger method = [dict[@"method"] integerValue];
            NSString *url = dict[@"url"];
            NSString *params = dict[@"params"];
            NSString *strUrl = [NSString stringWithFormat:@"%@",params];
            NSData *jsonData = [strUrl dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dicParams = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers              error:&err];
            NSString *success_callback = dict[@"success_callback"];
            NSString *failure_callback = dict[@"failure_callback"];
            if (method == 0) {
                [MKNetworking MKSeniorGetApi:url paramters:dicParams?dicParams:nil completion:^(MKHttpResponse *response) {
                    if (response.errorMsg) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            JSValue *value = weakSelf.context[failure_callback];
                            [value callWithArguments:@[[[NSString alloc] initWithData:response.originData  encoding:NSUTF8StringEncoding]]];
                            return ;
                        });
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *js = [NSString stringWithFormat:@"var a = %@;a('%@')",success_callback,[[NSString alloc] initWithData:response.originData  encoding:NSUTF8StringEncoding]];
//                        [webView stringByEvaluatingJavaScriptFromString:js];
                        JSValue *value = weakSelf.context[success_callback];
                        [value callWithArguments:@[[[NSString alloc] initWithData:response.originData  encoding:NSUTF8StringEncoding]]];
                        return ;
                    });
                }];
            }else{
                [MKNetworking MKSeniorPostApi:url paramters:dicParams?dicParams:nil completion:^(MKHttpResponse *response) {
                    if (response.errorMsg) {
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            NSString *js = [NSString stringWithFormat:@"var a = %@;a('%@')",failure_callback,[[NSString alloc] initWithData:response.originData  encoding:NSUTF8StringEncoding]];
//                            [webView stringByEvaluatingJavaScriptFromString:js];
                            JSValue *value = weakSelf.context[failure_callback];
                            [value callWithArguments:@[[[NSString alloc] initWithData:response.originData  encoding:NSUTF8StringEncoding]]];
                            return ;
                        });
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *js = [NSString stringWithFormat:@"var a = %@;a('%@')",success_callback,[[NSString alloc] initWithData:response.originData  encoding:NSUTF8StringEncoding]];
//                        [webView stringByEvaluatingJavaScriptFromString:js];
                        JSValue *value = weakSelf.context[success_callback];
                        [value callWithArguments:@[[[NSString alloc] initWithData:response.originData  encoding:NSUTF8StringEncoding]]];
                    });
                }];
            }
        }
    };
    
    
    self.testJO.returnTextBlock = ^(NSDictionary *dic){
        if ([[NSString stringWithFormat:@"%@",dic[@"cmd"]] isEqualToString: @"1"]) {
            [weakSelf weiShopnoTification:dic];
        }
        if ([[NSString stringWithFormat:@"%@",dic[@"cmd"]] isEqualToString: @"3"]) {
            [weakSelf setWebViewTitle:dic];
        }
        if ([[NSString stringWithFormat:@"%@",dic[@"cmd"]] isEqualToString: @"6"]) {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                [UIAlertView showWithTitle:@"提示" message:@"请移步到系统设置开启相册访问权限" style:UIAlertViewStyleDefault cancelButtonTitle:@"确定" otherButtonTitles:@[@"取消"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                        return ;
                    }
                }
                }];
            }else{
                [weakSelf saveMaterial:dic[@"data"][@"img_url"]];
            }
        }
        if ([[NSString stringWithFormat:@"%@",dic[@"cmd"]] isEqualToString: @"5"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MKPlaceTheOrderController *orderController = [MKPlaceTheOrderController create];
                orderController.orderUid = dic[@"data"][@"order_uid"];
                orderController.totalPrice = [MKBaseItemObject priceString:[dic[@"data"][@"pay_amount"] integerValue]];
                orderController.time = [dic[@"data"][@"timeout"] integerValue];
                orderController.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:orderController animated:YES];
            });
        }
        if ([[NSString stringWithFormat:@"%@",dic[@"cmd"]] isEqualToString: @"4"]) {
//            [[MKSellerIdSingleton sellerIdSingleton]setSellerId:dic[@"data"][@"seller_id"]];
            getUserCenter.accountInfo.sellerId = dic[@"data"][@"seller_id"];
            MKAccountInfo *acc = [MKAccountInfo objectWithDictionary:getUserCenter.accountInfo.dictionarySerializer];
            [getUserCenter loginWithAccountInfo:acc];
        }
    };
    NSDictionary *urlDict = [[MKUrlGuide commonGuide]parseParam:self.urlString];
    if ([self.urlString rangeOfString:@"disable-app-share"].location != NSNotFound) {
        if ([urlDict[@"disable-app-share"] integerValue] == 0) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moreButtonNormal"]
                                                                                      style:UIBarButtonItemStylePlain target:self
                                                                                     action:@selector(moreButtonClick:)];
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.webView.scrollView.header endRefreshing];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    if ([error code] == NSURLErrorCancelled) return;
    [MBProgressHUD showMessageIsWait:@"加载失败了" wait:YES];
//  [self.webView loadHTMLString:self.blankHTML baseURL:nil];
}

- (void) setWebViewTitle:(NSDictionary *) dic {
    self.navigationItem.title = dic[@"data"][@"title"];
}

- (void)webViewTitle:(NSString *)title
{
    self.title = title;
}

- (void)updatePullRefreshStatus
{
    if (self.disablePullRefresh)
    {
        [self.webView.scrollView.header endRefreshing];
    }
    else
    {
        UIWebView *webView = self.webView;
        NSString *urlString = self.urlString;

        __unsafe_unretained UIScrollView *scrollView = self.webView.scrollView;
        
        // 添加下拉刷新控件
        
        WXHDownRefreshHeader*header= [WXHDownRefreshHeader headerWithRefreshingBlock:^{
            if ([webView.request.URL.absoluteString isEqualToString:@"about:blank"])
            {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
            }
            else{
                
                [webView reload];
            }
        }];
        scrollView.header=header;
        header.lastUpdatedTimeLabel.hidden=YES;
        header.stateLabel.hidden=YES;
    }

    
}
- (void)MKPlaceTheOrderResults:(MKPayResult)payResult withOrderUid:(NSString *)orderUid{
    if (payResult == MKPayResultSuccess) {
        [NSThread sleepForTimeInterval:1.00f];
//       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_sync(queue, ^{
//            [getMainTabBar changeTabar];
//            
//        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [getMainTabBar changeTabar];
//        });
    }
}

@end
