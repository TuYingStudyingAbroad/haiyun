//
//  HYPaySuccessView.m
//  嗨云项目
//
//  Created by haiyun on 16/8/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYPaySuccessView.h"

@interface HYPaySuccessView()
{
    UIView *    _bgView;
    UIView *    _whiteBgView;
    
    UILabel *   _titleLabel;
    UILabel *   _contentLabel;
    
    UIButton    * _leftBtn;
    UIButton    * _rightBtn;
}


@end

@implementation HYPaySuccessView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    if (_bgView == nil)
    {
        _bgView = NewObject(UIView);
        _bgView.alpha = 0.36;
        _bgView.frame = self.bounds;
        _bgView.backgroundColor = [UIColor blackColor];
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch:)]];
        [self addSubview:_bgView];
    }else
    {
        _bgView.frame = self.bounds;
    }
    
    
    CGRect rect = CGRectMake(0.0f,0 , 260.0f , 259.0f);
    
    rect.origin.x = (frame.size.width - rect.size.width)/2.0f;
    rect.origin.y = (frame.size.height - rect.size.height)/2;
    if (_whiteBgView == nil)
    {
        _whiteBgView = NewObject(UIView);
        _whiteBgView.layer.cornerRadius = 8.0f;
        _whiteBgView.frame = rect;
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteBgView];
    }
    else
    {
        _whiteBgView.frame = rect;
    }
    
    rect = CGRectMake(0, 77, _whiteBgView.frame.size.width, 20);
    if (_titleLabel == nil)
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.frame = rect;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.textColor = kHEXCOLOR(0x252525);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"恭喜你获得了嗨客的资格，";
        [_whiteBgView addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    
    if (_contentLabel == nil)
    {
        _contentLabel = NewObject(UILabel);
        _contentLabel.frame = rect;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:17.0f];
        _contentLabel.textColor = kHEXCOLOR(0x252525);
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.text = @"快来加入我们吧！";
        [_whiteBgView addSubview:_contentLabel];
    }else
    {
        _contentLabel.frame = rect;
    }
    
    
    rect.origin.y = 10;
    rect.size.height = 32.0f;
    rect.size.width = 32.0f;
    rect.origin.x = _whiteBgView.frame.size.width - rect.size.width - rect.origin.y;
    if (_leftBtn == nil)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.backgroundColor = [UIColor clearColor];
        [_leftBtn setImage:[UIImage imageNamed:@"X_19x19"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.frame = rect;
        [_whiteBgView addSubview:_leftBtn];
    }else
    {
        _leftBtn.frame = rect;
    }
    
    rect.size.height = 39.0f;
    rect.size.width = 191.0f;
    rect.origin.x = (_whiteBgView.frame.size.width - rect.size.width)/2.0f;
    rect.origin.y = _whiteBgView.frame.size.height - rect.size.height - 30.0f;
    if (_rightBtn == nil)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = kHEXCOLOR(kRedColor);
        _rightBtn.layer.cornerRadius = 5.0f;
        [_rightBtn setTitle:@"加入嗨客" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.frame = rect;
        [_whiteBgView addSubview:_rightBtn];
    }else
    {
        _rightBtn.frame = rect;
    }
    
}

-(void)onButton:(id)sender
{
    if (sender == _leftBtn)
    {
        [self removeFromSuperview];
    }else
    {
        if ( self.tipsselect )
        {
            self.tipsselect(1);
        }
        [self removeFromSuperview];

    }
}

- (void)onTouch:(UITapGestureRecognizer *)tap
{
    UITapGestureRecognizer *tmpTap = (UITapGestureRecognizer *)tap;
    if ([tmpTap view] == _bgView)
    {
        [self removeFromSuperview];
    }
}

@end
