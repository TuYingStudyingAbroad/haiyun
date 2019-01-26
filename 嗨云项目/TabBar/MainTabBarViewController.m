//
//  MainTabBarViewController.m
//  YangDongXi
//
//  Created by windy on 15/4/8.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "UIViewController+MKExtension.h"
#import <PureLayout.h>
#import "AppDelegate.h"
#import <NYXImagesKit.h>
#import "HYNavigationController.h"
#import "SDWebImageManager.h"
#import "MKNagavitionBarObject.h"
#import "MKProductListViewController.h"
#import "MKItemDetailViewController.h"
#import "HYClassificationViewController.h"
#import "MKChildHomePageViewController.h"

@interface MainTabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) MKHomePageViewController *homePageViewController;

@property (nonatomic, strong) UITabBarItem *shoppingCartBarItem;


@property (nonatomic,strong)HYNavigationController *homeNav;
@property (nonatomic,strong)HYNavigationController *cfvcNav;
@property (nonatomic,strong)HYNavigationController *cartNav;
@property (nonatomic,strong)HYNavigationController *ucNav;
@property (nonatomic,strong)HYNavigationController *tsNav;



@end


@implementation MainTabBarViewController

+ (instancetype)sharedInstance {
    static MainTabBarViewController *tabBarVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarVC = [[[self class] alloc] init];
    });
    return tabBarVC;
}

- (void)dealloc
{
    [getUserCenter.shoppingCartModel removeObserver:self forKeyPath:@"itemCount"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
//    [self launchAction];
    [self initTabbars];
    [getUserCenter.shoppingCartModel addObserver:self forKeyPath:@"itemCount" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"itemCount"])
    {
        [self updateCartBadge];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)initTabbars
{
    //首页
    self.homePageViewController = [[MKHomePageViewController alloc] init];
    self.homeNav = [[HYNavigationController alloc]
                        initWithRootViewController:self.homePageViewController];
    _homeNav.tabBarItem =  [self createTabBarItem:@"首页"
                                      normalImage:@"tabbar_home_normal"
                                    selectedImage:@"tabbar_home_highlight"
                                          itemTag:0];
    self.selectedNav = self.homeNav;
    self.selectedTopVC = self.homePageViewController;
    //分类
     HYClassificationViewController *cfvc = [[HYClassificationViewController alloc] init];
    cfvc.isBacks = YES;
    self.cfvcNav = [[HYNavigationController alloc] initWithRootViewController:cfvc];
    _cfvcNav.tabBarItem = [self createTabBarItem:@"分类"
                                     normalImage:@"tabbar_classify_normal"
                                   selectedImage:@"tabbar_classify_highlight"
                                         itemTag:1];
    
    
    //TA说
    MKChildHomePageViewController *taShuo = [[MKChildHomePageViewController alloc]init];
    taShuo.title                          = @"TA说";
    taShuo.state                          = @"tashuo";
    taShuo.isHide = NO;
    self.tsNav = [[HYNavigationController alloc] initWithRootViewController:taShuo];
    _tsNav.tabBarItem = [self createTabBarItem:@"TA说"
                                     normalImage:@"tabbar_tashuo_normal"
                                   selectedImage:@"tabbar_tashuo_highlight"
                                         itemTag:2];
    //购物车
    MKShoppingCartViewController *cart1 = [MKShoppingCartViewController create];
    self.cartNav = [[HYNavigationController alloc] initWithRootViewController:cart1];
    _cartNav.tabBarItem = [self createTabBarItem:@"购物袋"
                                     normalImage:@"tabbar_shoppingcart_normal"
                                   selectedImage:@"tabbar_shoppingcart_highlight"
                                         itemTag:3];
    _cartNav.tabBarItem.imageInsets = UIEdgeInsetsMake(0.0f,-1.5f,0.0f,1.5f);
    self.shoppingCartBarItem = _cartNav.tabBarItem;
    [self updateCartBadge];
    //我的
    UserCenterViewController *uc = [UserCenterViewController create];
    self.ucNav = [[HYNavigationController alloc] initWithRootViewController:uc];
    _ucNav.tabBarItem = [self createTabBarItem:@"我的"
                                   normalImage:@"tabbar_mine_normal"
                                 selectedImage:@"tabbar_mine_highlight"
                                       itemTag:4];
   [self setViewControllers:@[_homeNav, _cfvcNav,_tsNav,_cartNav, _ucNav]];
    
}

- (UITabBarItem *)createTabBarItem:(NSString *)title
                       normalImage:(NSString *)normalImage
                     selectedImage:(NSString *)selectedImage
                           itemTag:(NSInteger)tag{
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 0.0f);
    UIColor *normalColor = kHEXCOLOR(kSectionHeadTitleColor);
    UIColor *selectedColor = kHEXCOLOR(kRedColor);
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title
                                                       image:nil
                                                         tag:tag];
   
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:normalColor, NSForegroundColorAttributeName,shadow,NSShadowAttributeName,nil]
                        forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:selectedColor, NSForegroundColorAttributeName,shadow,NSShadowAttributeName, nil]
                        forState:UIControlStateSelected];
    [item setTitlePositionAdjustment:UIOffsetMake(item.titlePositionAdjustment.horizontal,item.titlePositionAdjustment.vertical - 2.f)];
    [item setImage:[[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setSelectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
   
    return item;
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

- (void)setSelectedImageWithURL:(NSString *)str1 setUnselectedImageWithURL:(NSString *)str2 setTitle:(NSString *)title refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder navagertion:(UITabBarItem *)nav
{
    NSURL *url1 = [NSURL URLWithString:str1];
    NSURL *url2 = [NSURL URLWithString:str2];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [nav setTitle:title];
    [manager downloadImageWithURL:url1 options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        UIImage *ima2 = [UIImage imageWithCGImage:image.CGImage scale:image.size.width  * 2/44 orientation:UIImageOrientationUp];
        nav.selectedImage = [ima2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
    [manager downloadImageWithURL:url2 options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        UIImage *ima2 = [UIImage imageWithCGImage:image.CGImage scale:image.size.width * 2/44 orientation:UIImageOrientationUp];
        nav.image = [ima2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }];
}








- (void)selectTab:(Class)tabClass
{
    for (UINavigationController *vc in self.viewControllers)
    {
        if ([vc.viewControllers[0] isKindOfClass:tabClass])
        {
            self.selectedViewController = vc;
            UINavigationController *nv = (UINavigationController *)vc;
            self.selectedNav = (HYNavigationController *)nv;
            self.selectedViewController.tabBarController.tabBar.hidden = NO;
            self.selectedTopVC =(UIViewController *)vc.viewControllers[0];
            [nv popToRootViewControllerAnimated:NO];
        }
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           UINavigationController *nv = (UINavigationController *)vc;
                           [nv popToRootViewControllerAnimated:NO];
                       });
    }
}

- (void)guideToOrderDetailWithOrderUid:(NSString *)orderUid throughOrderStatus:(MKOrderStatus)status
{
    [self selectTabr:[UserCenterViewController class]];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        UINavigationController *nv = (UINavigationController *)self.selectedViewController;
        MKOrdersViewController *olv = [MKOrdersViewController create];
        olv.orderStatus = status;
        [nv pushViewController:olv animated:NO];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            YLOrderDetailViewController *odv = [[YLOrderDetailViewController alloc] init];
            odv.orderUid = orderUid;
            [nv pushViewController:odv animated:YES];
        });
    });
}

- (void)selectTabr:(Class)tabClass{
    for (UINavigationController *vc in self.viewControllers)
    {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
        UIViewController *co = vc.viewControllers[0];
        [co.navigationController popToRootViewControllerAnimated:NO];
                               });
//                [vc popToViewController:co animated:NO];
    }
    for (UINavigationController *vc in self.viewControllers)
    {
        if ([vc.viewControllers[0] isKindOfClass:tabClass])
        {
            UINavigationController *nv = (UINavigationController *)vc;
            self.selectedViewController = nv;
            self.selectedNav = (HYNavigationController *)nv;
            self.selectedTopVC =(UIViewController *)vc.viewControllers[0];
            [nv popToRootViewControllerAnimated:self.selectedViewController == vc];
            return;
            
        }
    }
}
- (void)guideToOrderListStatus:(MKOrderStatus)status
{
    [self selectTabr:[UserCenterViewController class]];
    dispatch_async(dispatch_get_main_queue(), ^
   {
           UINavigationController *nv = (UINavigationController *)self.selectedViewController;
           MKOrdersViewController *olv = [MKOrdersViewController create];
           olv.orderStatus = status;
           [nv pushViewController:olv animated:NO];
           
   });
}

- (void)guideToHome
{
//    self.tabBar.hidden = NO;
    [self selectTab:[MKHomePageViewController class]];

    [self.homePageViewController closeSearchView];
}

- (void)updateCartBadge
{
    NSInteger count = getUserCenter.shoppingCartModel.itemCount;
    MKAccountInfo *accountInfo = getUserCenter.accountInfo;
    if (count > 0 && accountInfo.accessToken.length > 0)
    {
        self.shoppingCartBarItem.badgeValue = [NSString stringWithFormat:@"%li", (long)count];
    }
    else
    {
        
        self.shoppingCartBarItem.badgeValue = nil;
        if (count > 0) {
            
            self.shoppingCartBarItem.badgeValue = [NSString stringWithFormat:@"%li", (long)count];
        }
    }
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self.selectedNav popToRootViewControllerAnimated:NO];
    self.tabBarController.selectedIndex = tabBarController.selectedIndex;
    self.selectedNav = (HYNavigationController *)tabBarController.selectedViewController;
    self.selectedTopVC = ((HYNavigationController *)tabBarController.selectedViewController).topViewController;
    self.selectedTopVC.tabBarController.tabBar.hidden = NO;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    [tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];
    if ( [viewController isEqual:self.ucNav] ) {
        if ( ![getUserCenter isLogined] ) {
            [getUserCenter loginoutPullView];
            return NO;
        }
    }
    return YES;
}

@end
