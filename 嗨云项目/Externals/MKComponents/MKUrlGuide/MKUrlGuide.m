//
//  MKUrlGuide.m
//  YangDongXi
//
//  Created by cocoa on 15/1/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKUrlGuide.h"
#import "MKUrlGuideItem.h"
#import "MKUrlGuideParamItem.h"
#import "UIWindow+MKExtension.h"
#import "AppDelegate.h"
#import "MKWebViewController.h"
#import "MKItemDetailViewController.h"
#import "YLLoginMainViewController.h"

@interface MKUrlGuide ()

@property (nonatomic, strong) NSMutableArray *guideItems;

@property (nonatomic, strong) NSMutableArray *delayGuideActions;

@property (nonatomic, assign) BOOL isNavigating;

@property (nonatomic,strong)MKUrlGuideItem *items;

@end


@implementation MKUrlGuide

+ (MKUrlGuide *)commonGuide
{
    static MKUrlGuide *commonGuideInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      commonGuideInstance = [[MKUrlGuide alloc] init];
                      NSArray *data = [NSArray arrayWithContentsOfFile:
                                       [[NSBundle mainBundle] pathForResource:@"MKUrlGuide" ofType:@"plist"]];
                      
                      for (NSDictionary *d in data)
                      {
                          MKUrlGuideItem *item = [[MKUrlGuideItem alloc] initWithDictionary:d];
                          [commonGuideInstance.guideItems addObject:item];
                      }
                      //分享模块没有使用控制器，单独处理
                      MKUrlGuideItem *item = [[MKUrlGuideItem alloc] init];
                      item.command = share_command;
                      [commonGuideInstance.guideItems addObject:item];
                  });
    return commonGuideInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.guideItems = [NSMutableArray array];
        self.delayGuideActions = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavigationControllerWillShow:) name:@"UINavigationControllerWillShowViewControllerNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavigationControllerDidShow:) name:@"UINavigationControllerDidShowViewControllerNotification" object:nil];
    }
    return self;
}

- (void)handleNavigationControllerWillShow:(NSNotification *)noti
{
    self.isNavigating = YES;
}

- (void)handleNavigationControllerDidShow:(NSNotification *)noti
{
    self.isNavigating = NO;
    
    if (self.delayGuideActions.count > 0)
    {
        void(^block)() = [self.delayGuideActions firstObject];
        block();
        [self.delayGuideActions removeObjectAtIndex:0];
    }
}

- (BOOL)canHandle:(NSString *)string
{
    return [string hasPrefix:@"http://"] || [string hasPrefix:@"haiyn://"];
}

- (BOOL)guideForUrl:(NSString *)urlString
{
    NSString *str = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self guideUrl:str ignoreNormal:NO];
}

- (BOOL)guideIgnoreWebVCForUrl:(NSString *)urlString
{
    NSString *str = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self guideUrl:str ignoreNormal:YES];
}

- (BOOL)guideUrl:(NSString *)urlString ignoreNormal:(BOOL)ignore
{
    if ([urlString hasPrefix:@GUIDE_SCHEME])
    {
        NSString *newUrl = [urlString stringByReplacingOccurrencesOfString:@GUIDE_SCHEME withString:@"http://"];
        return [self guideUrl:newUrl ignoreNormal:NO];
    }
    NSRange range = [urlString rangeOfString:@"://"];
    if (range.location == NSNotFound)
    {
        return NO;
    }
    NSString *execStr = [urlString substringFromIndex:range.location + @"://".length];
    NSString *guidePrefix = [GenericDomainNames stringByAppendingString:@GUIDE_PATH];
    NSString *guidePrefixBate = [GenericDomainNamesBeta stringByAppendingString:@GUIDE_PATH];
    NSString *guidePrefixTest = [GenericDomainNamesTest stringByAppendingString:@GUIDE_PATH];
    do
    {
        if (!([execStr hasPrefix:guidePrefix] || [execStr hasPrefix:guidePrefixBate] || [execStr hasPrefix:guidePrefixTest] ) )
        {
            break;
        }
        if ( [execStr hasPrefix:guidePrefixBate] && execStr.length > guidePrefixBate.length +1 )
        {
            execStr = [execStr substringFromIndex:guidePrefixBate.length + 1];
        }
        else if (  [execStr hasPrefix:guidePrefixTest]  && execStr.length > guidePrefixTest.length +1 )
        {
            execStr = [execStr substringFromIndex:guidePrefixTest.length + 1];
        }
        else if( execStr.length > guidePrefix.length +1 )
        {
            execStr = [execStr substringFromIndex:guidePrefix.length + 1];
        }else
        {
            break;
        }
        MKUrlGuideItem *matchedItem = nil;
        for (MKUrlGuideItem *item in self.guideItems)
        {
            if ([execStr hasPrefix:item.command])
            {
                matchedItem = item;
                break;
            }
        }
        if (matchedItem == nil)
        {
            break;
        }
        NSDictionary *params = [self parseParam:execStr];
        if ([params[@"isForceWap"] isEqualToString:@"true"])
        {
            break;
        }
//        if (![getUserCenter isLogined] )
//        {
//            [getUserCenter loginoutPullView];
//        }
        else
        {
            [self guideToItem:matchedItem withParams:params];
        }
        return YES;
    }
    while (0);
    if (!ignore)
    {
        [self guideToWebViewControllerWithUrl:urlString];
    }
    return NO;
}



- (void)guideToItem:(MKUrlGuideItem *)item withParams:(NSDictionary *)params
{
    //分享模块没有使用控制器，单独处理
    if ([item.command isEqualToString:share_command])
    {
        [self dealWithShareCommandWithParam:params];
        return;
    }
    if (item.isMainTab)
    {
        if (self.isNavigating)
        {
            [self.delayGuideActions addObject:^
             {
                 [getMainTabBar selectTab:NSClassFromString(item.className)];
             }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               
                               [getMainTabBar selectTab:NSClassFromString(item.className)];
                           });
        }
        
        return;
    }
    
    Class vcClass = NSClassFromString(item.className);
    UIViewController *vc;
    if ([item.createMethod isEqualToString:@"create"])
    {
        vc = [vcClass performSelector:@selector(create)];
    }
    else
    {
        vc = [[vcClass alloc] init];
    }
    vc.hidesBottomBarWhenPushed = YES;
    for (MKUrlGuideParamItem *paramItem in item.params)
    {
        id v = params[paramItem.urlParamName];
        if (v == nil)
        {
            v = paramItem.defaultValue;
            if ([vc isKindOfClass:[MKHomePageViewController class]]) {
                v = @"110";
            }
            
        }
        if (v != nil)
        {
            [vc setValue:v forKey:paramItem.classParamName];
        }
    }
    self.items = item;
    [self guideToViewController:vc forceModel:item.isModal];
}

- (void)guideToViewController:(UIViewController *)viewController forceModel:(BOOL)isModal
{
    if (self.isNavigating)
    {
        __weak __typeof(&*self)weakSelf = self;
        [self.delayGuideActions addObject:^
         {
             [weakSelf guideToViewController:viewController forceModel:isModal];
         }];
        return;
    }
    //如果有alertview的时候keywindow就取不对了
    UIViewController *topViewController = [self getTopViewController];
    
    if (!isModal && topViewController.navigationController != nil)
    {
        if ([self.items.command isEqualToString:@"callapppay.html"]) {
            [topViewController.navigationController pushViewController:viewController animated:NO];
            return;
        }
        [topViewController.navigationController pushViewController:viewController animated:YES];
        return;
    }
    if ([viewController isKindOfClass:[YLLoginMainViewController class]] )
    {
        [getUserCenter loginoutPullView];
        return;
    }
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:viewController];
    [topViewController presentViewController:nv animated:YES completion:nil];
}

- (UIViewController *)getTopViewController
{
    //如果有alertview的时候keywindow就取不对了
    UIViewController *topViewController =  [[UIApplication sharedApplication].windows[0] topViewController];
    if ([topViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *t = (UITabBarController *)topViewController;
        topViewController = [t selectedViewController];
    }
    if ([topViewController isKindOfClass:[UINavigationController class]])
    {
        topViewController = [[(UINavigationController *)topViewController viewControllers] lastObject];
    }
    return topViewController;
}

- (void)guideToWebViewControllerWithUrl:(NSString *)urlString
{
    MKWebViewController *webViewController = [[MKWebViewController alloc] init];
    NSString * encodingString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [webViewController loadUrls:encodingString];
    [self guideToViewController:webViewController forceModel:NO];
}

- (NSDictionary *)parseParam:(NSString *)urlString;
{
    NSRange r = [urlString rangeOfString:@"?"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (r.location != NSNotFound)
    {
        NSString *paramStr = [urlString substringFromIndex:r.location + 1];
        NSArray *pps = [paramStr componentsSeparatedByString:@"&"];
        for (NSString *str in pps)
        {
            NSArray *p = [str componentsSeparatedByString:@"="];
            switch (p.count)
            {
                case 0:
                    continue;
                    break;
                case 1:
                    [params setObject:[NSNull null] forKey:[p[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    break;
                default:
                {
                    NSString *p1 = [p[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSString *p0 = [p[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [params setObject:p1 forKey:p0];
                    break;
                }
            }
        }
    }
    return params;
}

- (void)dealWithShareCommandWithParam:(NSDictionary *)params
{
    //    ShareInfo *shareInfo = [[ShareInfo alloc] init];
    //
    //    shareInfo.url = params[@"url"];
    //    shareInfo.content = params[@"text"];
    //    shareInfo.title = params[@"title"];
    //    shareInfo.image = params[@"image"];
    //
    //    NSString *app = params[@"app"];
    //    ShareType type = ShareTypeAny;
    //
    //    if ([app isEqualToString:@"weixin"])
    //    {
    //        type = ShareTypeWeixiSession;
    //    }
    //    else if ([app isEqualToString:@"pengyouquan"])
    //    {
    //        type = ShareTypeWeixiTimeline;
    //    }
    //    else if ([app isEqualToString:@"weibo"])
    //    {
    //        type = ShareTypeSinaWeibo;
    //    }
    //    [VEShareHelper readyToShareInfo:shareInfo toPlatform:type
    //           withNavigationController:[self getTopViewController].navigationController
    //                         completion:nil];
}

@end
