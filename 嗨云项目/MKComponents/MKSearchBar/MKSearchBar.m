//
//  MKSearchBar.m
//  YangDongXi
//
//  Created by cocoa on 15/5/5.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKSearchBar.h"
#import <PureLayout.h>
#import "UIColor+MKExtension.h"

@interface MKSearchBar ()

@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic, strong) UIImageView *searchIconView;

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) NSLayoutConstraint *placeHolderXPosition;

@end


@implementation MKSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self mkSearchBarInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self mkSearchBarInit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height / 2;
    [self layoutIfNeeded];
}

- (void)mkSearchBarInit
{
    self.font = [UIFont systemFontOfSize:12];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.returnKeyType = UIReturnKeySearch;
    
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
    self.placeHolderView = [[UIView alloc] init];
    self.placeHolderView.userInteractionEnabled = NO;
    [self addSubview:self.placeHolderView];
    [self.placeHolderView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.placeHolderXPosition = [self.placeHolderView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    self.searchIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    [self.placeHolderView addSubview:self.searchIconView];
    [self.searchIconView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.searchIconView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    self.placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel.font = [UIFont systemFontOfSize:12];
    self.placeHolderLabel.textColor = [UIColor colorWithHex:0xcccccc];
    self.placeHolderLabel.text = @"请输入关键词";
    [self.placeHolderView addSubview:self.placeHolderLabel];
    [self.placeHolderLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeading];
    [self.placeHolderLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.searchIconView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBeginEditNoitifaction:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeNoitifaction:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndEditNoitifaction:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:self];
}

- (void)enableBorder:(BOOL)enable
{
    if (enable)
    {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithHex:0xe5e5e5].CGColor;
    }
    else
    {
        self.layer.borderWidth = 0;
    }
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}

//-(CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 25, 0);
//}

- (void)handleBeginEditNoitifaction:(NSNotification *)notification
{
    [self removeConstraint:self.placeHolderXPosition];
    self.placeHolderXPosition = [self.placeHolderView autoPinEdgeToSuperviewEdge:ALEdgeLeading
                                                                       withInset:10];
    [UIView animateWithDuration:0.25f animations:^
    {
        [self layoutIfNeeded];
    }];
}

- (void)handleChangeNoitifaction:(NSNotification *)notification
{
    self.placeHolderView.hidden = self.text.length != 0;
}

- (void)handleEndEditNoitifaction:(NSNotification *)notification
{
    
}

@end
