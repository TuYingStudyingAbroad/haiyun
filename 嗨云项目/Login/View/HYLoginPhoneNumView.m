//
//  HYLoginPhoneNumView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYLoginPhoneNumView.h"
#import "HYLoginTextFieldView.h"
#import "HYSystemLoginMsg.h"

@interface HYLoginPhoneNumView()
{
    
    HYLoginTextFieldView        *_phoneView;
    HYLoginTextFieldView        *_codeView;
    UIButton                    *_loginBtn;//登录
    UIButton                    *_codeBtn;//获取验证码
    NSTimer                     *_codeTimer;
    NSInteger                   _nTimerCount;
    
}


@end


@implementation HYLoginPhoneNumView

-(void)removeFromSuperview
{
    [_codeTimer invalidate];
    _codeTimer = nil;
    [super removeFromSuperview];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor whiteColor];
        _nTimerCount = 120;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    
    CGRect rect = CGRectMake(30.0f, 57.0f, 0.0f, 50.0f);
    rect.size.width = frame.size.width - 2*rect.origin.x;
    
    if ( _phoneView == nil )
    {
        _phoneView = [[HYLoginTextFieldView alloc] init];
        _phoneView.textMinLength = 0;
        _phoneView.textMaxLength = 11;
        _phoneView.iconImageName = @"Loginshouji";
        _phoneView.textPlaceName = @"请输入手机号码";
        _phoneView.keyboardType = UIKeyboardTypeNumberPad;
        _phoneView.textIsEnabled = YES;
        _phoneView.secureTextEntry = NO;
        _phoneView.frame = rect;
        [self.pBaseView addSubview:_phoneView];
    }else
    {
        _phoneView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _codeView == nil )
    {
        _codeView = [[HYLoginTextFieldView alloc] init];
        _codeView.textMinLength = 4;
        _codeView.textMaxLength = 6;
        _codeView.iconImageName = @"Loginyanzhengma";
        _codeView.textPlaceName = @"请输入验证码";
        _codeView.keyboardType = UIKeyboardTypeNumberPad;
        _codeView.textIsEnabled = YES;
        _codeView.secureTextEntry = NO;
        _codeView.textRightWidth = 66.0f;
        _codeView.frame = rect;
        [self.pBaseView addSubview:_codeView];
    }else
    {
        _codeView.frame = rect;
    }
    
    rect.size.width = 66.0f;
    rect.origin.x = frame.size.width - rect.size.width - _codeView.frame.origin.x;
    if ( _codeBtn == nil)
    {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:kHEXCOLOR(kRedColor) forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _codeBtn.frame = rect;
        _codeBtn.backgroundColor = [UIColor clearColor];
        [_codeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self.pBaseView addSubview:_codeBtn];
    }
    else
    {
        _codeBtn.frame = rect;
    }
    
    rect.origin.y += _codeView.frame.size.height + 30.0f;
    rect.origin.x = 30.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 44.0f;
    if ( _loginBtn == nil)
    {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _loginBtn.frame = rect;
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.layer.cornerRadius = 5.0;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.backgroundColor = kHEXCOLOR(kRedColor);
        [_loginBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self.pBaseView addSubview:_loginBtn];
    }
    else
    {
        _loginBtn.frame = rect;
    }
    
    CGRect rectBaseView = _pBaseView.frame;
    rectBaseView.size.height = rect.origin.y + rect.size.height + 1.0f;
    _pBaseView.frame = rectBaseView;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.contentSize = CGSizeMake(0,_pBaseView.frame.size.height);
}

-(void)onButton:(id)sender
{
    if ( sender == _codeBtn )
    {
        [self sendGetCode];
    }
    else if ( sender == _loginBtn )
    {
        NSString *msg = nil;
        if ( !HYJudgeMobile(_phoneView.textName) )
        {
            msg = @"请输入正确的手机号码";
        }
        if ( _codeView.textName.length < 4 || _codeView.textName.length > 6 )
        {
            msg = @"请输入正确的验证码";
        }
        if ( msg != nil)
        {
            [MBProgressHUD showMessageIsWait:msg wait:YES];
            return;
        }
        [HYSystemLoginMsg sendUpdateUserLoginInfoMiss:@{
                                                        @"mobile":_phoneView.textName,
                                                        @"verify_code":_codeView.textName,
                                                        }];
    }
    
}


#pragma mark -验证码倒计时
-(void)clickCodeBtn
{
    if ( HYJudgeMobile(_phoneView.textName) )
    {
        [HYSystemLoginMsg sendVerificationCode:@{@"mobile":_phoneView.textName,
                                             @"handle_type":@"binding_mobile"}
                                   success:^{
                                       [self sendGetCode];
                                   }];
    }else
    {
        [MBProgressHUD showMessageIsWait:@"请输入正确的手机号码" wait:YES];
    }
}

-(void)sendGetCode
{
    [_codeTimer invalidate];
    _codeTimer = nil;
    _nTimerCount = 120;
    _codeBtn.enabled = NO;
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setChangeCodeBtn) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_codeTimer forMode:NSDefaultRunLoopMode];
}
-(void)setChangeCodeBtn
{
    _nTimerCount--;
    if (_nTimerCount <= 0)
    {
        [_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
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
