//
//  YLWXLoginView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLWXLoginView.h"
#import "HYThreeDealMsg.h"
#import "HYSystemLoginMsg.h"

@interface YLWXLoginView()
{
    UIView              *_rightLine;
    UIView              *_leftLine;
    UIButton            *_bgWXBtn;
    UILabel             *_titleLabel;
    UILabel             *_nameLabel;
}

@end

@implementation YLWXLoginView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    CGRect rect = CGRectMake(0, 0, 1, 20.0f);
    float  fWidth = [@"第三方登录" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}].width;
    rect.size.width = fWidth +  30.0f;
    rect.origin.x = ( frame.size.width - rect.size.width )/2.0f;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.text = @"第三方登录";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kColor(102.0f,102.0f,102.0f);
        _titleLabel.frame = rect;
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    rect.size.width = rect.origin.x;
    rect.origin.x = 0.0f;
    rect.origin.y = (rect.size.height-1.0f)/2.0f;
    rect.size.height = 1.0f;
    if ( _leftLine == nil )
    {
        _leftLine = NewObject(UIView);
        _leftLine.backgroundColor = kColor(216.0f,216.0f,217.0f);
        _leftLine.frame = rect;
        [self addSubview:_leftLine];
    }else
    {
        _leftLine.frame = rect;
    }
    
    rect.origin.x = frame.size.width - rect.size.width;
    if ( _rightLine == nil )
    {
        _rightLine = NewObject(UIView);
        _rightLine.backgroundColor = kColor(216.0f,216.0f,217.0f);
        _rightLine.frame = rect;
        [self addSubview:_rightLine];
    }else
    {
        _rightLine.frame = rect;
    }
    
    rect.origin.x = 0.0f;
    rect.size.height = 20.0f;
    rect.size.width = frame.size.width;
    rect.origin.y = frame.size.height - rect.size.height;
    if ( _nameLabel == nil )
    {
        _nameLabel = NewObject(UILabel);
        _nameLabel.text = @"微信登录";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = kColor(102.0f,102.0f,102.0f);
        _nameLabel.frame = rect;
        [self addSubview:_nameLabel];
    }else
    {
        _nameLabel.frame = rect;
    }
    rect.origin.y -= 10.0f;
    rect.size.width = 46.0f;
    rect.size.height = 46.0f;
    rect.origin.x = (frame.size.width-rect.size.width)/2.0f;
    rect.origin.y -= rect.size.height;
    if ( _bgWXBtn == nil )
    {
        _bgWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgWXBtn.frame = rect;
        [_bgWXBtn setBackgroundImage:[UIImage imageNamed:@"Loginweixidenglu"] forState:UIControlStateNormal];
        [_bgWXBtn setBackgroundImage:[UIImage imageNamed:@"Loginweixidenglu"] forState:UIControlStateHighlighted];
        _bgWXBtn.backgroundColor = [UIColor clearColor];
        [_bgWXBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_bgWXBtn];

    }else
    {
        _bgWXBtn.frame = rect;
    }
}

-(void)onButton:(id)sender
{
    if ( sender == _bgWXBtn )
    {
        __weak typeof(self) weakSelf = self;
        [[HYThreeDealMsg sharedInstance]  LoginPayType:0 Result:^(NSString *bResultStr) {
            [weakSelf wxLoginNow:bResultStr];
        }];
    }
}
#pragma mark -微信登录
-(void)wxLoginNow:(NSString *)code
{
    [HYSystemLoginMsg sendUserWechatLogin:@{@"auth_code":code}];
}
@end
