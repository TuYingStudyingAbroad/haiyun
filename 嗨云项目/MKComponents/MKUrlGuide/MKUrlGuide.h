//
//  MKUrlGuide.h
//  YangDongXi
//
//  Created by cocoa on 15/1/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 MKUrlGuide ——> MKUrlGuideItem ——> MKUrlGuideParamItem
 */

#define GUIDE_HOST_NAME "m.yangdongxi.com"

//#define GUIDE_PATH "/app-yangdongxi/html"
#define GUIDE_PATH ""

#define GUIDE_SCHEME "yangdongxi://"

@interface MKUrlGuide : NSObject

+ (MKUrlGuide *)commonGuide;

/**
 @brief  是否可以处理这个字符串，目前判断前缀
 */
- (BOOL)canHandle:(NSString *)string;

/**
 @brief 非跳转url默认会拉起webVC
        目前使用MKWebViewController
 @param urlString 导航的url
 @return YES:native页，NO:webVC
 */
- (BOOL)guideForUrl:(NSString *)urlString;

/**
 @brief 非跳转url不会拉起webVC
 @param urlString 导航的url
 @return 是否跳转到新的native页面
 */
- (BOOL)guideIgnoreWebVCForUrl:(NSString *)urlString;

@end
