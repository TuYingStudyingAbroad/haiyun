//
//  MainTabBarViewController.h
//  YangDongXi
//
//  Created by windy on 15/4/8.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKHomePageViewController.h"
#import "MKShoppingCartViewController.h"
#import "UserCenterViewController.h"
#import "MKClassificationViewController.h"
#import "MKOrdersViewController.h"
#import "YLOrderDetailViewController.h"

@class HYNavigationController;
@interface MainTabBarViewController : UITabBarController

@property (nonatomic,strong) HYNavigationController *selectedNav;
@property (nonatomic,strong) UIViewController *selectedTopVC;


+ (instancetype)sharedInstance;
//初始化TabBar
-(void)initTabbars;

- (void)selectTab:(Class)tabClass;

- (void)guideToOrderDetailWithOrderUid:(NSString *)orderUid throughOrderStatus:(MKOrderStatus)status;

- (void)guideToOrderListStatus:(MKOrderStatus)status;

- (void)guideToHome;
@end
