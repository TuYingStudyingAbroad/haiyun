//
//  MKActivityView.m
//  YangDongXi
//
//  Created by cocoa on 15/5/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKActivityView.h"
#import <PureLayout.h>
#import "UIColor+MKExtension.h"


@implementation MKActivityButtonView

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.text = text;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:11];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.imageButton setImage:image forState:UIControlStateNormal];
        
        [self addSubview:self.textLabel];
        [self addSubview:self.imageButton];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = @{@"textLabel": self.textLabel, @"imageButton": self.imageButton};
        NSArray *constraints = nil;
        
        //label紧贴view的左右
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textLabel]|" options:0 metrics:nil views:views];
        [self addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[imageButton]-6-[textLabel]-10-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
        [self addConstraints:constraints];
    }
    return self;
}

@end

@interface MKActivityView ()

//内容窗口
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) int numberOfButtonPerLine;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *titleContent;

//按钮加载的view
@property (nonatomic, strong) UIView *iconView;

//button数组
@property (nonatomic, strong) NSArray *buttonViews;

//透明的关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

//取消按钮
@property (nonatomic, strong) UIButton *cancelButton;

//行数
@property (nonatomic, assign) NSUInteger lines;

//消失的时候移除
@property (nonatomic, strong) NSLayoutConstraint *contentViewPinBottomConstraint;

//是否已经显示
@property (nonatomic, assign) BOOL shown;

@end


@implementation MKActivityView

- (instancetype)initWithButtons:(NSArray *)buttons
{
    self = [super init];
    if (self)
    {
        self.buttonViews = buttons;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.lines = 0;
    self.numberOfButtonPerLine = 4;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    [self.closeButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.95f];
    [self addSubview:self.contentView];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setBackgroundColor:[UIColor colorWithHex:0xf9f9f9]];
    [self.contentView addSubview:self.cancelButton];
    
    self.iconView = [[UIView alloc] init];
    [self.contentView addSubview:self.iconView];
    
    self.titleContent = [[UIView alloc] init];
    [self.contentView addSubview:self.titleContent];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.titleContent addSubview:self.titleLabel];
    self.titleLabel.text = @"分享到";
    self.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UIView *sp1 = [[UIView alloc] init];
    sp1.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    [self.titleContent addSubview:sp1];
    
    UIView *sp2 = [[UIView alloc] init];
    sp2.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    [self.titleContent addSubview:sp2];
    
    NSDictionary *tvs = @{@"title" : self.titleLabel, @"sp1" : sp1, @"sp2" : sp2};
    NSArray *cs = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[sp1]-15-[title]-15-[sp2(==sp1)]-12-|" options:0 metrics:nil views:tvs];
    [self.titleContent addConstraints:cs];
    [sp1 autoSetDimension:ALDimensionHeight toSize:0.5];
    [sp2 autoSetDimension:ALDimensionHeight toSize:0.5];
    [sp1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleContent withOffset:6];
    [sp2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleContent withOffset:6];
    [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleContent withOffset:6];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleContent.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layoutViews
{
    [self prepareForShow];
    
    NSArray *constraints = nil;
    NSLayoutConstraint *constraint = nil;
    UIView *referView = [UIApplication sharedApplication].keyWindow;
    NSDictionary *views = @{@"title" : self.titleContent,
                            @"contentView": self.contentView,
                            @"cancelButton": self.cancelButton, @"iconView": self.iconView, @"view": self,
                            @"referView": referView};
    
    //view跟referView的宽高相等
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                 toItem:referView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [referView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                 toItem:referView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [referView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                                 toItem:referView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [referView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                 toItem:referView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [referView addConstraint:constraint];
    
    //contentView跟view的左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //titleContent跟view的左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[title]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    //cancelButton跟contentView左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cancelButton]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    //iconView跟contentView左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[iconView]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    //垂直方向titleLabel挨着iconView挨着cancelButton
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title(==40)][iconView][cancelButton(==45)]|"
                                                          options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    [self layoutIfNeeded];
    
    self.contentViewPinBottomConstraint = [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
}

- (void)prepareForShow
{
    //计算行数
    NSUInteger count = [self.buttonViews count];
    self.lines = count / self.numberOfButtonPerLine;
    if (count % self.numberOfButtonPerLine != 0)
    {
        self.lines++;
    }
    UIView *t = nil;
    UIView *b0 = nil;
    for (int i = 0; i < self.lines; ++ i)
    {
        NSMutableArray *lvs = [NSMutableArray array];
        for (int j = 0; j < self.numberOfButtonPerLine; ++j)
        {
            NSInteger index = i * self.numberOfButtonPerLine + j;
            UIView *bv;
            if (index >= count)
            {
                bv = [[UIView alloc] init];
            }
            else
            {
                bv = [self.buttonViews objectAtIndex:index];
            }
            [lvs addObject:bv];
            [self.iconView addSubview:bv];
            
            if (j == 0)
            {
                b0 = bv;
                [t autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:b0];
                t = b0;
            }
            else
            {
                [bv autoAlignAxis:ALAxisHorizontal toSameAxisOfView:b0];
            }
        }
        NSDictionary *vs = @{@"v0" : lvs[0], @"v1" : lvs[1], @"v2" : lvs[2], @"v3" : lvs[3]};
        NSString *fs = @"H:|-12-[v0(==v1)][v1(==v2)][v2(==v3)][v3]-12-|";
        NSArray *a = [NSLayoutConstraint constraintsWithVisualFormat:fs
                                                             options:0 metrics:nil views:vs];
    
        [self.iconView addConstraints:a];
        
        UIView *sp = [[UIView alloc] init];
        sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
        [self.iconView addSubview:sp];
        [sp autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:i == self.lines - 1 ? 0 : 12];
        [sp autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:i == self.lines - 1 ? 0 : 12];
        [sp autoSetDimension:ALDimensionHeight toSize:0.5];
        [sp autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:b0];
    }
    [[self.buttonViews firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [b0 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
}

- (void)show
{
    if (self.shown)
    {
        return;
    }
    self.shown = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self layoutViews];
    self.contentViewPinBottomConstraint.constant = self.contentView.frame.size.height;
    [self layoutIfNeeded];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.25f animations:^
    {
        self.contentViewPinBottomConstraint.constant = 0;
        self.alpha = 1;
        [self layoutIfNeeded];
    }];
}

- (void)hide
{
    if (!self.shown)
    {
        return;
    }
    
    [UIView animateWithDuration:0.25f animations:^
    {
        self.alpha = 0;
        self.contentViewPinBottomConstraint.constant = self.contentView.frame.size.height;
        [self layoutIfNeeded];
    }
                     completion:^(BOOL finished)
    {
        self.shown = NO;
        [self removeFromSuperview];
    }];
}

- (void)closeButtonClicked:(UIButton *)button
{
    [self hide];
}

@end
