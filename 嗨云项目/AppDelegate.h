//
//  AppDelegate.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/5.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarViewController.h"
#import "MKBaseLib.h"
#import "MKAppConfig.h"
#import "MKUserCenter.h"
#import "MainTabBarViewController.h"


//appDelegate
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define getAppConfig appDelegate.appConfig
#define getUserCenter appDelegate.userCenter
#define getMainTabBar appDelegate.mainTabBarViewController

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MKAppConfig *appConfig;

@property (nonatomic, strong) MKUserCenter *userCenter;

@property (nonatomic, strong) MainTabBarViewController *mainTabBarViewController;

@end

