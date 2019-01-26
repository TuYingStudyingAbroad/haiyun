//
//  MKActivityView.h
//  YangDongXi
//
//  Created by cocoa on 15/5/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MKActivityButtonView : UIView

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *imageButton;

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image;

@end


@interface MKActivityView : UIView

- (instancetype)initWithButtons:(NSArray *)buttons;

- (void)show;

- (void)hide;

@end
