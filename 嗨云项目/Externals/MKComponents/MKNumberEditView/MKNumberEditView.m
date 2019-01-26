//
//  MKNumberEditView.m
//  YangDongXi
//
//  Created by cocoa on 15/4/28.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKNumberEditView.h"
#import <PureLayout.h>
#import "UIColor+MKExtension.h"

@interface MKNumberEditView ()



@property (nonatomic, strong) UITextField *numberTextField;

@property (nonatomic, strong) UIView *seperatorLine1;

@property (nonatomic, strong) UIView *seperatorLine2;


@end


@implementation MKNumberEditView

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"tag"];
    [self removeObserver:self forKeyPath:@"autoCount"];
    [self removeObserver:self forKeyPath:@"continuousChangeNumber"];
    [self removeObserver:self forKeyPath:@"canEditNumber"];
    [self removeObserver:self forKeyPath:@"min"];
    [self removeObserver:self forKeyPath:@"max"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.min = 1;
    self.max = NSIntegerMax;
    
    self.plusEnableImage = [UIImage imageNamed:@"plus_13x13"];
    self.plusDisableImage = [UIImage imageNamed:@"plus_gray_13x13"];
    self.minusEnableImage = [UIImage imageNamed:@"minus_13x1"];
    self.minusDisableImage = [UIImage imageNamed:@"minus_gray_13x1"];
    
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = [UIColor colorWithHex:0x666666].CGColor;
    self.clipsToBounds = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.plusImageView = [[UIImageView alloc] initWithImage:self.plusEnableImage];
    self.plusImageView.contentMode = UIViewContentModeCenter;
    self.plusImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.plusImageView];
    [self.plusImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.plusImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//    [UIView autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^
//     {
         [self.plusImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.plusImageView];
//     }];
    
    self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.plusButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.plusButton];
    [self.plusButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.plusImageView];
    [self.plusButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.plusButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.plusButton];
    [self.plusButton autoSetDimension:ALDimensionHeight toSize:40 relation:NSLayoutRelationGreaterThanOrEqual];
//    [UIView autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^
//     {
         [self.plusButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.plusImageView];
//     }];
    
    self.minusImageView = [[UIImageView alloc] initWithImage:self.minusEnableImage];
    self.minusImageView.contentMode = UIViewContentModeCenter;
    self.minusImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.minusImageView];
    [self.minusImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.minusImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//    [UIView autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^
//     {
         [self.minusImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.minusImageView];
//     }];
    
    self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.minusButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.minusButton];
    [self.minusButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.minusImageView];
    [self.minusButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.minusButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.minusButton];
    [self.minusButton autoSetDimension:ALDimensionHeight toSize:40 relation:NSLayoutRelationGreaterThanOrEqual];
//    [UIView autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^
//     {
         [self.minusButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.minusImageView];
//     }];
    
    self.numberTextField = [[UITextField alloc] init];
    self.numberTextField.textAlignment = NSTextAlignmentCenter;
    self.numberTextField.font = [UIFont systemFontOfSize:12];
    self.numberTextField.enabled = NO;
    [self updateNumber:1];
    [self addSubview:self.numberTextField];
    [self.numberTextField autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.numberTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    NSDictionary *tvs = @{@"minus" : self.minusImageView, @"plus" : self.plusImageView, @"text" : self.numberTextField};
    NSArray *cs = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[minus][text][plus(==minus)]|" options:0 metrics:nil views:tvs];
    [self addConstraints:cs];
    
    self.seperatorLine1 = [self createSeperator];
    self.seperatorLine2 = [self createSeperator];
    [self.seperatorLine1 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.minusImageView];
    [self.seperatorLine2 autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.plusImageView];
    
    [self addObserver:self forKeyPath:@"tag" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"autoCount" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"continuousChangeNumber" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"canEditNumber" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"max" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"min" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"tag"])
    {
        self.plusButton.tag = self.tag;
        self.minusButton.tag = self.tag;
    }
    else if ([keyPath isEqualToString:@"autoCount"])
    {
        if (self.autoCount)
        {
            [self.plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self.minusButton addTarget:self action:@selector(minusButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [self.plusButton removeTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self.minusButton removeTarget:self action:@selector(minusButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if ([keyPath isEqualToString:@"continuousChangeNumber"])
    {
        
    }
    else if ([keyPath isEqualToString:@"canEditNumber"])
    {
        
    }
    else if ([keyPath isEqualToString:@"min"] || [keyPath isEqualToString:@"max"])
    {
        NSInteger number = [self.numberTextField.text integerValue];
        [self updateNumber:number];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.plusButton.frame, point) ||
        CGRectContainsPoint(self.minusButton.frame, point))
    {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

- (UIView *)createSeperator
{
    UIView *seperator = [[UIView alloc] init];
    seperator.backgroundColor = [UIColor colorWithHex:0x666666];
    [self addSubview:seperator];
    [seperator autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [seperator autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [seperator autoSetDimension:ALDimensionWidth toSize:0.3];
    return seperator;
}

- (void)addPlusTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.plusButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addMinusTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.minusButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)updateNumber:(NSInteger)number
{
    if (number <= self.min)
    {
        number = self.min;
    }
    if (number >= self.max)
    {
        number = self.max;
    }
    self.numberTextField.text = [NSString stringWithFormat:@"%li", (long)number];
    [self plusButtonEnable:number < self.max];
    [self minusButtonEnable:number > self.min];
}

- (NSInteger)getNumber
{
    return [self.numberTextField.text integerValue];
}

- (void)enableEditNumber:(BOOL)enable
{
    self.numberTextField.enabled = NO;
}

- (void)enableEditButton:(BOOL)enable
{
    self.plusButton.enabled = enable;
    [self minusButtonEnable:enable];
}

- (void)minusButtonEnable:(BOOL)enable
{
    self.minusButton.enabled = enable;
    self.minusButtonEnable = enable;
    self.minusImageView.image = enable ? self.minusEnableImage : self.minusDisableImage;
}

- (void)plusButtonEnable:(BOOL)enable
{
    self.plusButton.enabled = enable;
    self.plusButtonEnable = enable;
    self.plusImageView.image = enable ? self.plusEnableImage : self.plusDisableImage;
}

- (void)setTextFiedWidth:(CGFloat)width
{
    [self.numberTextField autoSetDimension:ALDimensionWidth toSize:width];
}

- (void)updateBorderColor:(UIColor *)color
{
    self.seperatorLine1.backgroundColor = color;
    self.seperatorLine2.backgroundColor = color;
    self.layer.borderColor = color.CGColor;
}

- (void)plusButtonClick
{
    NSInteger n = [self.numberTextField.text integerValue];
    if (n >= self.max)
    {
        return;
    }
    n ++ ;
    self.numberTextField.text = [NSString stringWithFormat:@"%li", (long)n];
    [self plusButtonEnable:n < self.max];
    [self minusButtonEnable:n > self.min];
}

- (void)minusButtonClick
{
    NSInteger n = [self.numberTextField.text integerValue];
    if (n <= self.min)
    {
        return;
    }
    n -- ;
    self.numberTextField.text = [NSString stringWithFormat:@"%li", (long)n];
    [self plusButtonEnable:n < self.max];
    [self minusButtonEnable:n > self.min];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.plusButton.enabled && [self.plusButton pointInside:[self convertPoint:point toView:self.plusButton] withEvent:nil])
    {
        return self.plusButton;
    }
    if (!self.minusButton.enabled && [self.minusButton pointInside:[self convertPoint:point toView:self.minusButton] withEvent:nil])
    {
        return self.minusButton;
    }
    return [super hitTest:point withEvent:event];
}

@end
