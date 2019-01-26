//
//  MKMarketingComponentTitleView.h
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MKExtension.h"

@interface MKMarketingComponentTitleView : UIView

@property (nonatomic, strong) IBOutlet UIView *indicatorView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) IBOutlet UIImageView *moreImagView;

@property (nonatomic, strong) IBOutlet UIButton *button;

@end
