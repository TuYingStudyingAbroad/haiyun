//
//  MKNumberEditView.h
//  YangDongXi
//
//  Created by cocoa on 15/4/28.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKNumberEditView : UIView

/**
 自动计数
 */
@property (nonatomic, assign) BOOL autoCount;

/**
 按着不动连续计数
 */
@property (nonatomic, assign) BOOL continuousChangeNumber;

/**
 最小值，小于等于这个值，减号变灰
 */
@property (nonatomic, assign) NSInteger min;

/**
 最大值，大于等于这个值，加号变灰
 */
@property (nonatomic, assign) NSInteger max;

@property (nonatomic, strong) UIImage *plusEnableImage;

@property (nonatomic, strong) UIImage *plusDisableImage;

@property (nonatomic, strong) UIImage *minusEnableImage;

@property (nonatomic, strong) UIImage *minusDisableImage;

@property (nonatomic, strong) UIImageView *plusImageView;

@property (nonatomic, strong) UIImageView *minusImageView;

@property (nonatomic, assign) BOOL plusButtonEnable;

@property (nonatomic, assign) BOOL minusButtonEnable;

@property (nonatomic, strong) UIButton *minusButton;

@property (nonatomic, strong) UIButton *plusButton;

/**
 是否可以直接输入数字
 */
@property (nonatomic, assign) BOOL canEditNumber;

- (void)addPlusTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)addMinusTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)updateNumber:(NSInteger)number;

- (NSInteger)getNumber;

- (void)minusButtonEnable:(BOOL)enable;

- (void)plusButtonEnable:(BOOL)enable;

- (void)updateBorderColor:(UIColor *)color;

/**
 设置文本框的宽度
 @discussion 默认加减号为正方形，改这个值就不是了
 */
- (void)setTextFiedWidth:(CGFloat)width;

@end
