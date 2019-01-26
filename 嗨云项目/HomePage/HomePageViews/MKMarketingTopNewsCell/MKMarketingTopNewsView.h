//
//  MKMarketingTopNewsView.h
//  YangDongXi
//
//  Created by cocoa on 15/5/7.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "UIView+MKExtension.h"

@interface MKMarketingTopNewsView : UIView

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *oneButtonAlignY;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *twoButtonAlignY;

@property (nonatomic, strong) IBOutlet UIButton *oneButton;

@property (nonatomic, strong) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headlinesImageViewWidth;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

- (void)updateTitles:(NSArray *)titles;

- (void)animationSwitch;

@end
