//
//  HYSystemInit.h
//  嗨云项目
//
//  Created by YanLu on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYNavigationController.h"

@interface HYSystemInit : NSObject
{
    UIWindow *_window;
    HYNavigationController * _navigationController;
}

@property (nonatomic ,strong)UIWindow * window;
@property (nonatomic ,strong)HYNavigationController * navigationController;
@property (nonatomic ,assign) BOOL bShowStart;

+ (instancetype)sharedInstance;


//获取TabBar内容
-(void)GetServerNetworking;
/**
 *  拉起登陆界面
 *
 */
-(void)pullupLoginView;

/**
 *  判断是否登陆
 *
 *  @return YES登陆，NO没有登陆
 */
-(BOOL)isLogin;
/**
 *  推出登陆界面,1登陆，2注册
 */
-(void)dismissLoginView:(NSInteger)isLogin;

-(void)OnMain;

-(void)sellerMessageBaseUrl;

@end
