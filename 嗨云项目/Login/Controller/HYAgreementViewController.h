//
//  HYAgreementViewController.h
//  嗨云项目
//
//  Created by haiyun on 2016/10/24.
//  Copyright © 2016年 haiyun. All rights reserved.
//

@class HYAgreementViewController;
@protocol HYAgreementViewControllerDelegate <NSObject>

@optional
- (void)agreementViewClose:(HYAgreementViewController *)agreementView;

@end

#import <UIKit/UIKit.h>

@interface HYAgreementViewController : UIViewController

@property (nonatomic, strong) NSString *titles;
@property (nonatomic, strong) NSString *messages;
@property (nonatomic, strong) NSMutableArray *argreeArr;
@property (nonatomic, assign) BOOL isClose;
@property (nonatomic, weak) __weak id<HYAgreementViewControllerDelegate>delegate;

@end
