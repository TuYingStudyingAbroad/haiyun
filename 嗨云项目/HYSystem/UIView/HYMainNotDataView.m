//
//  HYMainNotDataView.m
//  嗨云项目
//
//  Created by haiyun on 16/5/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYMainNotDataView.h"

@interface HYMainNotDataView ()
{
    UIImageView         *_mainImageView;
    UILabel             *_titleLabel;
    UILabel             *_titleLabel1;
    UILabel             *_titleLabel2;
    
    UIButton            *_reloadBtn;
}

@end

@implementation HYMainNotDataView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kHEXCOLOR(0xf7f7f7);
    }
    return self;
}



- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    CGRect rect = CGRectMake(0, 0, 103.0f, 103.0f);
    rect.origin.x = (frame.size.width - rect.size.width)/2;
    rect.origin.y = (Main_Screen_Height - rect.size.height - 132.0f-64.0f)/2;
    if (_mainImageView == nil)
    {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.frame = rect;
        _mainImageView.image = [UIImage imageNamed:@"Loginwuwangluo"];
        _mainImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainImageView];
    }else
    {
        _mainImageView.frame = rect;
    }
    
    rect.origin.y += rect.size.height + 12.0f;
    rect.size.height = 18.0f;
    rect.origin.x = 0.0f;
    rect.size.width = frame.size.width;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.frame = rect;
        _titleLabel.text = @"网络请求失败~";
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kHEXCOLOR(0x999999);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height + 8.0f;
    if ( _titleLabel1 == nil )
    {
        _titleLabel1 = NewObject(UILabel);
        _titleLabel1.frame = rect;
        _titleLabel1.text = @"请检查您的网络";
        _titleLabel1.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel1.backgroundColor = [UIColor clearColor];
        _titleLabel1.textColor = kHEXCOLOR(0xc2c2c2);
        _titleLabel1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel1];
    }else
    {
        _titleLabel1.frame = rect;
    }
    rect.origin.y += rect.size.height +  3.0f;
    if ( _titleLabel2 == nil )
    {
        _titleLabel2 = NewObject(UILabel);
        _titleLabel2.frame = rect;
        _titleLabel2.text = @"重新加载吧";
        _titleLabel2.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel2.backgroundColor = [UIColor clearColor];
        _titleLabel2.textColor = kHEXCOLOR(0xc2c2c2);
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel2];
    }else
    {
        _titleLabel2.frame = rect;
    }
    
    rect.origin.y += rect.size.height +  20.0f;
    rect.size.width = 134.0f;
    rect.size.height = 35.0f;
    rect.origin.x = (frame.size.width - rect.size.width)/2.0;
    if ( _reloadBtn == nil)
    {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_reloadBtn setTitleColor:kHEXCOLOR(0x666666) forState:UIControlStateNormal];
        _reloadBtn.frame = rect;
        _reloadBtn.userInteractionEnabled = YES;
        _reloadBtn.layer.cornerRadius = 6.0;
        _reloadBtn.layer.masksToBounds = YES;
        _reloadBtn.layer.borderWidth = 1.0f;
        _reloadBtn.layer.borderColor = kHEXCOLOR(0xcccccc).CGColor;
        _reloadBtn.backgroundColor = [UIColor clearColor];
        [_reloadBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_reloadBtn];
    }
    else
    {
        _reloadBtn.frame = rect;
    }
}

-(void)onButton:(id)sender
{
    if ( sender == _reloadBtn )
    {
        if ( _delegate && [_delegate respondsToSelector:@selector(reloadDataView:)])
        {
            [_delegate reloadDataView:self];
        }
    }
}
@end
