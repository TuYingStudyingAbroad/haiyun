//
//  MKBaseViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKBaseViewController : UIViewController

/**
 @brief 请在viewDidAppear中调用，如果在viewWillAppear中调用会崩溃
 */
- (void)enableSwipeBackWhenNavigationBarHidden;

@end
