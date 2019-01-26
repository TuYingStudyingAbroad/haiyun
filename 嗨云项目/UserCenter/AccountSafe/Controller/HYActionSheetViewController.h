//
//  HYActionSheetViewController.h
//  嗨云项目
//
//  Created by haiyun on 16/8/31.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

@class HYActionSheetViewController;
@protocol HYActionSheetViewControllerDelegate <NSObject>

/**
 *  获取相册，照相
 *
 *  @param actionSheet HYActionSheetViewController
 *  @param buttonIndex 1从相册获取  ，2拍照
 */
- (void)actionSheetView:(HYActionSheetViewController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

#import <UIKit/UIKit.h>


@interface HYActionSheetViewController : UIViewController

@property (nonatomic, weak) __weak id<HYActionSheetViewControllerDelegate> delegate;

@end
