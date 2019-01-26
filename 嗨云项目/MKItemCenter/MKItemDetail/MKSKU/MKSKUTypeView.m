//
//  MKSKUTypeView.m
//  YangDongXi
//
//  Created by cocoa on 14/12/5.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "MKSKUTypeView.h"
#import "MKSKUPropertyObject.h"
#import <PureLayout.h>
#import "UIColor+MKExtension.h"

#define normalColor [UIColor colorWithHex:0x333333]
#define selectedColor [UIColor colorWithHex:0xff2741]
#define normalBorderColor [UIColor colorWithHex:0xf5f5f5]

#define horizontalMargin 5
#define verticalMargin 15
#define buttonHeight 26

@interface MKSKUTypeView ()

@property (nonatomic, strong) UIButton *selectedButton;

@end


@implementation MKSKUTypeView

- (void)buildItemsWithProperties:(NSArray *)props
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    if ([[props[0] name] isEqualToString:@""]) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",[props[0] name]];
    }else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@:",[props[0] name]];
    }
    
    UIView *layoutTopView = self.titleLabel;
    UIView *layoutLeftView = nil;
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:props.count];
    int index = 0;
    CGFloat abc = 60;
    for (MKSKUPropertyObject *attr in props)
    {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.titleLabel.textAlignment = NSTextAlignmentCenter;
        bt.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        
        [bt setTitle:attr.value forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:13];
        [bt setTitleColor:normalColor forState:UIControlStateNormal];
        [bt setTitleColor:selectedColor forState:UIControlStateSelected];
        CGSize titleSize = [attr.value sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}];
        
        [bt setImage:[UIImage imageNamed:@"sku_unselected"] forState:UIControlStateNormal];
        [bt setImage:[UIImage imageNamed:@"sku_selected"] forState:UIControlStateSelected];
        bt.titleEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 7);
        bt.imageEdgeInsets = UIEdgeInsetsMake(5,titleSize.width+10,-5,-11);
        bt.layer.borderWidth = 1;
        bt.layer.borderColor = normalBorderColor.CGColor;
        bt.layer.cornerRadius = 2;
        bt.layer.masksToBounds = YES;
        bt.tag = index ++ ;
        [bt addTarget:self action:@selector(attributeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        [buttons addObject:bt];
        
        [bt sizeToFit];
        [self layoutIfNeeded];

        if (layoutLeftView != nil && layoutLeftView.frame.origin.x + layoutLeftView.frame.size.width
            + bt.frame.size.width + horizontalMargin > width)
        {
            layoutTopView = layoutLeftView;
            layoutLeftView = nil;
        }
        
        [bt autoSetDimension:ALDimensionHeight toSize:buttonHeight];
        if (layoutLeftView == nil)
        {
            abc += 20+verticalMargin;
            [bt autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:12.5];
        }
        else
        {
            [bt autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:layoutLeftView withOffset:horizontalMargin];
        }
        
        [bt autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:layoutTopView withOffset:verticalMargin];
        if ([attr.name isEqualToString:@""]) {
            [bt autoSetDimension:(ALDimensionWidth) toSize:0];
            [bt autoSetDimension:(ALDimensionHeight) toSize:0];
        }
        layoutLeftView = bt;
    }
    self.abc = abc;
    self.propertyButtons = [buttons copy];
    [layoutLeftView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
}

- (void)buildItemsProperties:(NSArray *)props
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.titleLabel.text = @"历史纪录";
    
    UIView *layoutTopView = self.titleLabel;
    UIView *layoutLeftView = nil;
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:props.count];
    int index = 0;
    CGFloat abc = 60;
    for (NSString *attr in props)
    {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.titleLabel.textAlignment = NSTextAlignmentCenter;
        bt.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        
        [bt setTitle:attr forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:13];
        [bt setTitleColor:normalColor forState:UIControlStateNormal];
        [bt setTitleColor:selectedColor forState:UIControlStateSelected];
        CGSize titleSize = [attr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}];
        
        [bt setImage:[UIImage imageNamed:@"sku_unselected"] forState:UIControlStateNormal];
        [bt setImage:[UIImage imageNamed:@"sku_selected"] forState:UIControlStateSelected];
        bt.titleEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 7);
        bt.imageEdgeInsets = UIEdgeInsetsMake(5,titleSize.width+10,-5,-11);
        bt.layer.borderWidth = 1;
        bt.layer.borderColor = normalBorderColor.CGColor;
        bt.layer.cornerRadius = 2;
        bt.layer.masksToBounds = YES;
        bt.tag = index ++ ;
        [bt addTarget:self action:@selector(attributeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        [buttons addObject:bt];
        
        [bt sizeToFit];
        [self layoutIfNeeded];
        
        if (layoutLeftView != nil && layoutLeftView.frame.origin.x + layoutLeftView.frame.size.width
            + bt.frame.size.width + horizontalMargin > width)
        {
            layoutTopView = layoutLeftView;
            layoutLeftView = nil;
        }
        
        [bt autoSetDimension:ALDimensionHeight toSize:buttonHeight];
        if (layoutLeftView == nil)
        {
            abc += 20+verticalMargin;
            [bt autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:12.5];
        }
        else
        {
            [bt autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:layoutLeftView withOffset:horizontalMargin];
        }
        
        [bt autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:layoutTopView withOffset:verticalMargin];
        if ([attr isEqualToString:@""]) {
            [bt autoSetDimension:(ALDimensionWidth) toSize:0];
            [bt autoSetDimension:(ALDimensionHeight) toSize:0];
        }
        layoutLeftView = bt;
    }
    self.abc = abc;
    self.propertyButtons = [buttons copy];
    [layoutLeftView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
}

- (NSInteger)getSelectedIndex
{
    if (self.selectedButton == nil)
    {
        return -1;
    }
    return self.selectedButton.tag;
}

- (void)selectIndex:(NSInteger)index
{
    for (UIButton *b in self.propertyButtons)
    {
        if (b.tag == index)
        {
            [self attributeButtonClick:b];
            break;
        }
    }
}

- (void)attributeButtonClick:(UIButton *)button
{
    NSInteger from = -1;
    NSInteger to = -1;
    if (self.selectedButton != nil)
    {
        self.selectedButton.selected = NO;
        self.selectedButton.layer.borderColor = normalBorderColor.CGColor;
        from = self.selectedButton.tag;
    }
    if (button == self.selectedButton)
    {
        self.selectedButton = nil;
    }
    else
    {
        button.selected = YES;
        button.layer.borderColor = selectedColor.CGColor;
        self.selectedButton = button;
        to = button.tag;
    }
    if ( self.delegate && [self.delegate respondsToSelector:@selector(skuTypeView:changeFromIndex:toIndex:)] )
    {
        [self.delegate skuTypeView:self changeFromIndex:from toIndex:to];
    }
}
- (void)setButton:(NSInteger)index enable:(BOOL)enable
{
    UIButton *b = self.propertyButtons[index];
    
    b.enabled = enable;
    
    if (enable) {
        [b setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        b.backgroundColor = [UIColor whiteColor];
    }else{
        [b setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        b.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    }
}

@end
