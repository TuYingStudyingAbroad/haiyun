//
//  YLSafeNewView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeNewView.h"
#import "HYTextFieldBaseView.h"

@interface YLSafeNewView ()<HYTextFieldBaseViewDelegate>
{
    HYTextFieldBaseView         *_phoneView;
    HYTextFieldBaseView         *_codeView;
    UIButton                    *_codeBtn;//获取验证码
    NSTimer                     *_codeTimer;
    NSInteger                   _nTimerCount;
}

@end

@implementation YLSafeNewView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
        _nTimerCount = 120;
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    
    CGRect rect = CGRectMake(0.0f, 10.0f, frame.size.width, 45.0f);
    if ( _phoneView == nil )
    {
        _phoneView = [[HYTextFieldBaseView alloc] init];
        _phoneView.textMinLength = 0;
        _phoneView.textMaxLength = 11;
        _phoneView.iconImageName = @"HYSafeshouji";
        _phoneView.textPlaceName = @"新手机号码";
        _phoneView.keyboardType = UIKeyboardTypeNumberPad;
        _phoneView.textIsEnabled = YES;
        _phoneView.secureTextEntry = NO;
        _phoneView.frame = rect;
        _phoneView.delegate = self;
        [self addSubview:_phoneView];
    }else
    {
        _phoneView.frame = rect;
    }
    rect.origin.y += rect.size.height;
    if ( _codeView == nil )
    {
        _codeView = [[HYTextFieldBaseView alloc] init];
        _codeView.textMinLength = 4;
        _codeView.textMaxLength = 6;
        _codeView.iconImageName = @"HYSafeyanzhengma";
        _codeView.textPlaceName = @"验证码";
        _codeView.keyboardType = UIKeyboardTypeNumberPad;
        _codeView.textIsEnabled = YES;
        _codeView.secureTextEntry = NO;
        _codeView.rightHide = NO;
        _codeView.bottomHide = NO;
        _codeView.delegate = self;
        _codeView.textRightWidth = 70.0f;
        _codeView.frame = rect;
        [self addSubview:_codeView];
    }else
    {
        _codeView.frame = rect;
    }
    
    rect.size.width = 70.0f;
    rect.origin.x = frame.size.width - rect.size.width - 12.0f;
    if ( _codeBtn == nil)
    {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:kHEXCOLOR(kRedColor) forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _codeBtn.frame = rect;
        _codeBtn.backgroundColor = [UIColor clearColor];
        [_codeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_codeBtn];
    }
    else
    {
        _codeBtn.frame = rect;
    }
    
}

-(void)onButton:(id)sender
{
    if ( sender == _codeBtn )
    {
        
    }
}

#pragma mark -点击完成
-(void)onButtonClickRight
{
    if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)]  )
    {
        [self.baseDelegate OnPushController:0 wParam:nil];
    }
}
#pragma mark -HYTextFieldBaseViewDelegate
-(void)HYTextFieldBaseView:(HYTextFieldBaseView *)textView
                 textField:(NSString *)textFieldName
{
    if ( textView == _phoneView )
    {
        
    }
    else if ( textView == _codeView )
    {
        
    }
    
}

#pragma mark -验证码倒计时
-(void)sendGetCode
{
    [_codeTimer invalidate];
    _codeTimer = nil;
    _nTimerCount = 120;
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setChangeCodeBtn) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_codeTimer forMode:NSDefaultRunLoopMode];
}
-(void)setChangeCodeBtn
{
    _nTimerCount--;
    if (_nTimerCount <= 0)
    {
        [_codeBtn setTitle:@"重发" forState:UIControlStateNormal];
        _codeBtn.enabled = YES;
        [_codeTimer invalidate];
        _codeTimer = nil;
        _nTimerCount = 120;
    }
    else
    {
        [_codeBtn setTitleColor:kHEXCOLOR(kRedColor) forState:UIControlStateNormal];
        _codeBtn.enabled = NO;
        [_codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)_nTimerCount] forState:UIControlStateNormal];
    }
}

@end
