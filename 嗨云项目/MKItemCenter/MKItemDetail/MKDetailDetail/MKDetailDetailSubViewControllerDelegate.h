//
//  MKDetailDetailSubViewControllerDelegate.h
//  YangDongXi
//
//  Created by cocoa on 15/6/1.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MKDetailDetailSubViewControllerProtocol <NSObject>

- (UIScrollView *)getScrollView;

@end


@protocol MKDetailDetailSubViewControllerDelegate <NSObject>

- (void)subViewControllerViewDidLoad:(UIViewController<MKDetailDetailSubViewControllerProtocol> *)viewController;

@end

