//
//  MKUrlGuideItem.h
//  YangDongXi
//
//  Created by cocoa on 15/1/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define share_command @"sharesdk.html"

/**
 @brief 用于url跳转的配置
 */
@interface MKUrlGuideItem : NSObject

/**
 @brief 跳转的主命令，如cart.html
 */
@property (nonatomic, strong) NSString *command;

/**
 @brief 跳转到的控制器类名，如ShoppingCartViewController
 */
@property (nonatomic, strong) NSString *className;

/**
 @brief 创建方法，主要用于兼容老版本的create创建方法
 */
@property (nonatomic, strong) NSString *createMethod;

/**
 @brief 跳转到的控制器参数 (MKUrlGuideParamItem数组)，如控制器需要title参数等
 */
@property (nonatomic, strong) NSArray *params;

/**
 @brief 首页、分类、个人中心三个主tab的首控制器，不会新开控制器，而是直接切换tab到对应页；
        之前会将当前tab的navigationViewController pop to root。
 */
@property (nonatomic, assign) BOOL isMainTab;

/**
 @brief 强制使用presentModelViewController，默认会套一个UINavigationController
 */
@property (nonatomic, assign) BOOL isModal;

/**
 @brief 需要登录
 */
@property (nonatomic, assign) BOOL needLogin;

/**
 @brief 从MKUrlGuide.plist中加载数据，然后这里初始化
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
