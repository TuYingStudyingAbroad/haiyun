//
//  HYSystemInit.m
//  嗨云项目
//
//  Created by YanLu on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYSystemInit.h"
#import "MKAppConfig.h"
#import "UIViewController+MKExtension.h"
#import "YLLoginMainViewController.h"
#import "HYMainStartViewController.h"
#import "HYSystemFuntion.h"
#import "MainTabBarViewController.h"
#import "MKAccountInfo.h"
#import "AppDelegate.h"
#import "UIAlertView+Blocks.h"
#import "HYAgreementViewController.h"
#import "MKNetworking+BusinessExtension.h"
#import "HYAgreementObject.h"

@interface HYSystemInit ()<UIAlertViewDelegate>
{
    
}

@property (nonatomic, strong) NSString *appUrl;

@property (nonatomic, strong) YLLoginMainViewController *loginVC;
@end

@implementation HYSystemInit

@synthesize window = _window;
@synthesize navigationController = _navigationController;

+ (instancetype)sharedInstance {
    static HYSystemInit *g_GGMainInit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_GGMainInit = [[[self class] alloc] init];
        [g_GGMainInit MainInit];
    });
    return g_GGMainInit;
}


-(void)MainInit
{
    if ( ![getUserCenter isLogined] )
    {
        self.bShowStart = YES;
    }else
    {
        self.bShowStart = YES;
    }
}

-(void)GetServerNetworking
{
    [self OnMain];
    [self checkVersion];
}


-(void)OnMain
{
    _window.rootViewController = nil;
    if (_navigationController)
    {
        _navigationController = nil;
    }
    if ( [GetObjectforNSUserDefaultsByKey(@"HYStart_Show1.2.3") intValue] != 2  )
    {
        self.bShowStart = NO;
        HYMainStartViewController *pVC = [[HYMainStartViewController alloc] init];
        _navigationController = [[HYNavigationController alloc] initWithRootViewController:pVC];
        _window.rootViewController = _navigationController;
        [self.window makeKeyAndVisible];
        return;
    }
    MainTabBarViewController *tabBar = [MainTabBarViewController sharedInstance];
    _window.rootViewController = tabBar;
    _navigationController = tabBar.selectedViewController;
    [self.window makeKeyAndVisible];
    return;
}

#pragma mark -拉起登陆页面
-(void)pullupLoginView
{
    if (![getUserCenter isLogined] )//免登录
    {
        _loginVC = [[YLLoginMainViewController alloc] init];
        _navigationController = [[HYNavigationController alloc] initWithRootViewController:_loginVC];
        MainTabBarViewController *tabBar = [MainTabBarViewController sharedInstance];
        [tabBar.selectedNav presentViewController:_navigationController animated:YES completion:nil];
    }
}
-(void)dismissLoginView:(NSInteger)isLogin
{
    [_loginVC dismissViewControllerAnimated:YES completion:nil];
    if ( isLogin == 1 )
    {
        [self onRequest];
    }
}

#pragma mark -请求查看协议协议
-(void)onRequest
{
//    NSLog(@"------%ld==%@",getUserCenter.userInfo.userId,getUserCenter.accountInfo.userId);
    //@"user_id":@(getUserCenter.userInfo.userId)
    [MKNetworking MKSeniorGetApi:@"/get/protocol"
                       paramters:@{@"pro_model":@"1",@"user_id":getUserCenter.accountInfo.userId}
                      completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         NSMutableArray *arr1 = [NSMutableArray array];
         if ( [response.mkResponseData[@"posterity_list"] isKindOfClass:[NSArray class]] )
         {
             for( NSDictionary *dcis in response.mkResponseData[@"posterity_list"])
             {
                 HYAgreementObject *agres = [HYAgreementObject objectWithDictionary:dcis];
                 [arr1 addObject:agres];
             }
             [self createHYAgreementVc:arr1];
         }
         

     }];

    
    
}

-(void)createHYAgreementVc:(NSMutableArray *)agreeArr
{
    if ( agreeArr && agreeArr.count )
    {
        HYAgreementViewController *argreeVc = [[HYAgreementViewController alloc] init];
        argreeVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        argreeVc.titles = @"注册协议";
        argreeVc.messages = @"【审慎阅读】您在申请注册流程中点击同意前，应当认真阅读以下协议。请您务必审慎阅读、充分理解协议中相关条款内容，其中包括：\n1、与您约定免除或限制责任的条款；\n2、与您约定法律适用和管辖的条款；\n3、其他以粗体下划线标识的重要条款。\n如您对协议有任何疑问，可向平台客服咨询。\n【特别提示】当您按照注册页面提示填写信息、阅读并同意协议且完成全部注册程序后，即表示您已充分阅读、理解并接受协议的全部内容。如您因平台服务与嗨云发生争议的，适用《嗨云平台推广合作协议》处理。阅读协议的过程中，如果您不同意相关协议或其中任何条款约定，您应立即停止注册程序。";
        argreeVc.isClose = NO;
        argreeVc.argreeArr = [[NSMutableArray alloc] initWithArray:agreeArr];
        [getMainTabBar presentViewController:argreeVc animated:NO completion:nil];
    }
}
#pragma mark -判断是否登陆
-(BOOL)isLogin
{
    return [getUserCenter isLogined];
}
#pragma mark -检测更新
- (void)checkVersion
{
    [self checkVersionWithOutAlertIfLatest:YES CompletionHandler:NULL];
}

//版本更新
- (void)checkVersionWithOutAlertIfLatest:(BOOL)noAlertIfLatest CompletionHandler:(void (^)())handler
{//http://act.haiyn.com/data/haiyunappcheckupdate.json
    NSString *t = [NSString stringWithFormat:@"%i", (int)[[NSDate date] timeIntervalSince1970]];
    [MKNetworking MKSeniorGetApi:@"version/deploy/get" paramters:@{@"x" : t}
                completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
             return ;
         }
         NSDictionary *dict = [response.mkResponseData HYNSDictionaryValueForKey:@"ios"];
         NSString *needNormalUpdate = [dict HYValueForKey:@"is_update"];
         NSString *isForceUupdate = [dict HYValueForKey:@"is_force_update"];
         NSString *newVersion = [dict HYValueForKey:@"version"];
         NSString *desc = [[dict HYValueForKey:@"desc"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
         self.appUrl = [dict HYValueForKey:@"app_url"];
         
         if ([isForceUupdate isEqualToString:@"1"] && ![getAppConfig.getAppVersion isEqualToString:newVersion])
         {
             [UIAlertView showWithTitle:[NSString stringWithFormat:@"检测到新版本v%@", newVersion]
                                message:desc cancelButtonTitle:@"确认" otherButtonTitles:nil
                               tapBlock:^(UIAlertView * __nonnull alertView, NSInteger buttonIndex)
              {
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appUrl]];
                  dispatch_async(dispatch_get_main_queue(), ^
                                 {
                                     exit(0);
                                 });
              }];
             return;
         }
         if (![needNormalUpdate isEqualToString:@"1"])
         {
             return;
         }
         if ([getAppConfig.getAppVersion isEqualToString:newVersion])
         {
             return;
         }
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"检测到新版本v%@", newVersion]
                                                             message:desc delegate:self cancelButtonTitle:@"残忍地拒绝"
                                                   otherButtonTitles:@"快乐地升级", nil];
         [alertView show];
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appUrl]];
    }
}
#pragma makr -baseURL修改
-(void)sellerMessageBaseUrl
{
    [MKNetworking MKGETUrl:SellerBetaApi paramters:nil
                completion:^(MKHttpResponse *response)
     {
         if ([[response.responseDictionary HYValueForKey:@"msg"] isEqualToString:@"pre"]) //pre预防
         {
             [MKNetworking setBaseUrl:@"http://apibeta.haiyn.com"];//域名
         }else//online线上
         {
             [MKNetworking setBaseUrl:@"http://api.haiyn.com"];//域名
         }
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self  GetServerNetworking];
                        });

     }];
}
@end
