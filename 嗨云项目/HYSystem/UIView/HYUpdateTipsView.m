//
//  HYUpdateTipsView.m
//  嗨云项目
//
//  Created by haiyun on 16/8/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYUpdateTipsView.h"

@interface HYUpdateTipsView()
{
    UIView *    _bgView;
    UIView *    _whiteBgView;
    UIView *    _lineBgView;
    
    UILabel *   _titleLabel;
    UILabel *   _contentLabel;
    
    UIButton    * _leftBtn;
    UIButton    * _rightBtn;
}


@end

@implementation HYUpdateTipsView

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
    
    float ftexthight = GetHeightOfString(@"嗨", 100, [UIFont systemFontOfSize:14.0f]);
    
    CGRect rect = CGRectMake(34,0 , frame.size.width - 68, 110);
    
    rect.size.height += (GetHeightOfString(self.nsTips, rect.size.width - 40, [UIFont systemFontOfSize:14.0f])/ftexthight) *(ftexthight + 3);
    
    rect.origin.y = (frame.size.height - rect.size.height)/2;
    if (_whiteBgView == nil)
    {
        _whiteBgView = NewObject(UIView);
        _whiteBgView.layer.cornerRadius = 8.0f;
        _whiteBgView.frame = rect;
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteBgView];
    }else
    {
        _whiteBgView.frame = rect;
    }
    
    rect = CGRectMake(84, rect.origin.y, frame.size.width - 84*2, 50);
    if (_titleLabel == nil)
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.frame = rect;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20.0f];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = self.nsTitle;
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    
    rect = CGRectMake(54, rect.origin.y + rect.size.height, _whiteBgView.frame.size.width - 40, _whiteBgView.frame.size.height - 110);
    if (_contentLabel == nil)
    {
        _contentLabel = NewObject(UILabel);
        _contentLabel.frame = rect;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.nsTips];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.nsTips length])];
        
        _contentLabel.attributedText = attributedString;
        
        [self addSubview:_contentLabel];
    }else
    {
        _contentLabel.frame = rect;
    }
    
    rect = CGRectMake(_whiteBgView.frame.origin.x,rect.origin.y + rect.size.height + 10 , _whiteBgView.frame.size.width, 1);
    if (_lineBgView == nil)
    {
        _lineBgView = NewObject(UIView);
        _lineBgView.backgroundColor =[UIColor redColor];
        _lineBgView.frame = rect;
        [self addSubview:_lineBgView];
    }else
    {
        _lineBgView.frame = rect;
    }
    
    rect.origin.y += 10;
    rect.origin.x = _contentLabel.frame.origin.x;
    rect.size.height = 30;
    rect.size.width = (_contentLabel.frame.size.width - 10)/2;
    if (_leftBtn == nil)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.backgroundColor = [UIColor whiteColor];
        _leftBtn.layer.cornerRadius = 5.0f;
        [_leftBtn setTitle:self.nsleft forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.frame = rect;
        [self addSubview:_leftBtn];
    }else
    {
        _leftBtn.frame = rect;
    }
    
    rect.origin.x += rect.size.width +  10;
    if (_rightBtn == nil)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = kHEXCOLOR(kRedColor);
        _rightBtn.layer.cornerRadius = 5.0f;
        [_rightBtn setTitle:self.nsright forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.frame = rect;
        [self addSubview:_rightBtn];
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
        self.tipsselect(1);
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
