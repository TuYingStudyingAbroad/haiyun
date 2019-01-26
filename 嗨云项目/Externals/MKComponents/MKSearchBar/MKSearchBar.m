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
        self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12 ,10)];
        self.leftViewMode=UITextFieldViewModeAlways;
        [self mkSearchBarInit];
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15 ,13)];
    self.leftViewMode=UITextFieldViewModeAlways;
    [self mkSearchBarInit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = 15.0f;
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
    self.placeHolderLabel.font = [UIFont systemFontOfSize:13];
    self.placeHolderLabel.textColor = [UIColor colorWithHex:0xa8a8a8];
    self.placeHolderLabel.text = @"商品关键词";
    [self.placeHolderView addSubview:self.placeHolderLabel];
    [self.placeHolderLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeading];
    [self.placeHolderLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.searchIconView withOffset:10.0f];
    
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
    return CGRectInset(bounds, 23, 0);
}

//-(CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 25, 0);
//}
//左视图
//- (CGRect)leftViewRectForBounds:(CGRect)bounds{
//    CGRect rect = [super leftViewRectForBounds:bounds];
//
//    rect = CGRectMake(rect.origin.x + 10, rect.origin.y, rect.size.width, rect.size.height);
//        return rect;
//
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
    
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shangpinliebiao_sousuo"]];

 
    if(self.text.length){
         self.leftView=image;
       }else{
           self.leftView=nil;

    }
    
}

- (void)handleEndEditNoitifaction:(NSNotification *)notification
{
    
}

@end
