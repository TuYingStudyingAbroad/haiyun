//
//  HYSearchNewView.m
//  嗨云项目
//
//  Created by haiyun on 16/9/19.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYSearchNewView.h"

@interface HYSearchNewView ()
{
    NSMutableArray     *_keywordsArr;
    
    NSMutableArray     *_hotWordsArr;
    
    UIView             *_lineView;
    
    UILabel            *_hisTitleLabel;
    
    UILabel            *_hotTitleLabel;
    
}

@end

@implementation HYSearchNewView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        if ( !_keywordsArr )
        {
            _keywordsArr = NewObject(NSMutableArray);
        }
        if ( _hotWordsArr == nil )
        {
            _hotWordsArr = NewObject(NSMutableArray);
        }
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect rect = CGRectMake(0, 0, 0, 1.0f);
    if ( _lineView == nil )
    {
        _lineView = NewObject(UIView);
        _lineView.frame = rect;
        _lineView.backgroundColor = kHEXCOLOR(0xe8e8e8);
        [self addSubview:_lineView];
    }
    else
    {
        _lineView.frame = rect;
    }
    if ( _keywordsArr.count )
    {
        
    }
    else
    {
        
    }
    
}

@end

@interface HYSearchShowView ()
{
    UIView              *_lineView;
    
    UILabel             *_titleLabel;
    
    UIImageView         *_rightImageView;
    
    UIButton            *_leftBtn;
}

@end

@implementation  HYSearchShowView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
//    CGRect rect = CGRectMake(0, 3.0f, frame.size.width-6.0f, 30.0f);
}

@end

/**********点击的字体***********/

@interface HYKeywordsView ()
{
    UILabel             *_keywordLabel;
   
    UIButton            *_keyBtn;
    
    UIButton            *_delBtn;
    
}

@end

@implementation HYKeywordsView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.isHide = YES;
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect rect = CGRectMake(0, 3.0f, frame.size.width-6.0f, 30.0f);
    if ( _keyBtn == nil )
    {
        _keyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _keyBtn.frame = rect;
        [_keyBtn setTitle:self.keyTitle forState:UIControlStateNormal];
        _keyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _keyBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [_keyBtn setTitleColor:kHEXCOLOR(0x333333) forState:UIControlStateNormal];
        _keyBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _keyBtn.backgroundColor = [UIColor clearColor];
        _keyBtn.layer.cornerRadius = 6.0;
        _keyBtn.layer.masksToBounds = YES;
        _keyBtn.layer.borderWidth = 1.0f;
        _keyBtn.layer.borderColor = kHEXCOLOR(0xe8e8e8).CGColor;
        [_keyBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_keyBtn];
    }else
    {
        [_keyBtn setTitle:self.keyTitle forState:UIControlStateNormal];
        _keyBtn.frame = rect;
    }
    rect.size.height = 14.0f;
    rect.size.width = rect.size.height;
    rect.origin.y = 0.0f;
    rect.origin.x = frame.size.width - rect.size.width;
    if ( _delBtn == nil )
    {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = rect;
        _delBtn.userInteractionEnabled = YES;
        _delBtn.backgroundColor = [UIColor clearColor];
        [_delBtn setBackgroundImage:[UIImage imageNamed:@"HYkuaijieshanchu"] forState:UIControlStateNormal];
        [_delBtn setBackgroundImage:[UIImage imageNamed:@"HYkuaijieshanchu"] forState:UIControlStateHighlighted];
        [_delBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.hidden = self.isHide;
        [self addSubview:_delBtn];

    }
    else
    {
        _delBtn.frame = rect;
        _delBtn.hidden = self.isHide;

    }
}

-(void)onButton:(id)sender
{
    if ( sender == _keyBtn ) {
        
    }else if( sender == _delBtn ){
        
    }
}
@end
