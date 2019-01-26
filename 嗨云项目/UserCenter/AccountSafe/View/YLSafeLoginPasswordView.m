//
//  YLSafeLoginPasswordView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeLoginPasswordView.h"
#import "HYTextFieldBaseView.h"
#import "YLSafeTool.h"

@interface YLSafeLoginPasswordView ()<HYTextFieldBaseViewDelegate>
{
    HYTextFieldBaseView     *_phoneView;
    HYTextFieldBaseView     *_codeView;
    HYTextFieldBaseView     *_passwView;
    UIButton                *_codeBtn;
    NSTimer                     *_codeTimer;
    NSInteger                   _nTimerCount;
}

@end

@implementation YLSafeLoginPasswordView

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
        _phoneView.textPlaceName = @"请输入手机号码";
        _phoneView.textName = self.nsPhoneNum;
        _phoneView.keyboardType = UIKeyboardTypeNumberPad;
        _phoneView.textIsEnabled = NO;
        _phoneView.secureTextEntry = NO;
        _phoneView.frame = rect;
        _phoneView.delegate = self;
        [self addSubview:_phoneView];
    }else
    {
        _phoneView.textName = self.nsPhoneNum;
        _phoneView.textIsEnabled = NO;
        _phoneView.frame = rect;
    }
    rect.origin.y += rect.size.height;
    if ( _codeView == nil )
    {
        _codeView = [[HYTextFieldBaseView alloc] init];
        _codeView.textMinLength = 4;
        _codeView.textMaxLength = 6;
        _codeView.iconImageName = @"HYSafeyanzhengma";
        _codeView.textPlaceName = @"请输入验证码";
        _codeView.keyboardType = UIKeyboardTypeNumberPad;
        _codeView.textIsEnabled = YES;
        _codeView.secureTextEntry = NO;
        _codeView.rightHide = NO;
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
    
    rect.origin.y += rect.size.height;
    rect.origin.x = 0.0f;
    rect.size.width = frame.size.width;
    if ( _passwView == nil )
    {
        _passwView = [[HYTextFieldBaseView alloc] init];
        _passwView.textMinLength = 6;
        _passwView.textMaxLength = 15;
        _passwView.iconImageName = @"HYSafexinmima";
        _passwView.textPlaceName = @"请输入6-15位密码";
        _passwView.keyboardType = UIKeyboardTypeDefault;
        _passwView.textIsEnabled = YES;
        _passwView.secureTextEntry = YES;
        _passwView.delegate = self;
        _passwView.bottomHide = NO;
        _passwView.frame = rect;
        [self addSubview:_passwView];
    }else
    {
        _passwView.frame = rect;
    }
}

-(void)onButton:(id)sender
{
    if ( sender == _codeBtn )
    {
        [self clickCodeBtn];
    }
}

#pragma mark -点击完成
-(void)onButtonClickRight
{
    CloseKeyBord(YES);
    NSString *msg = nil;
     if ( !HYJudgeMobile(_phoneView.textName) )
    {
        msg = @"请输入正确的手机号码";
    }
    else if ( _codeView.textName.length < 4 ||  _codeView.textName.length > 6 )
    {
        msg = @"请输入正确的验证码";
    }
    else if ( _passwView.textName.length<6 || _passwView.textName.length > 15 )
    {
        msg = @"请输入6-15位密码";
    }
    else if ( !HYJudgePassword(_passwView.textName)  )
    {
        msg = @"密码只限英文字母或数字";
    }
    if ( msg != nil)
    {
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return;
    }
    NSString *mFlag = @"1";
    if ( self.nsIsChange )
    {
        mFlag = @"0";
    }
    [YLSafeTool sendUpdatePwd:@{@"mobile":_phoneView.textName,
                                @"password":_passwView.textName,
                                @"verify_code":_codeView.textName,
                                @"mFlag":mFlag}
                      success:^{
                          if ( self.nsIsChange )
                          {
                              [MBProgressHUD showMessageIsWait:@"密码修改成功" wait:YES];
                          }else
                          {
                              [MBProgressHUD showMessageIsWait:@"密码设置成功" wait:YES];
                          }
                          [self rightClickSuccess];
    }];
}
#pragma mark -HYTextFieldBaseViewDelegate
-(void)HYTextFieldBaseView:(HYTextFieldBaseView *)textView
                 textField:(NSString *)textFieldName
{
    
}

#pragma mark -验证码倒计时
-(void)clickCodeBtn
{
    if ( HYJudgeMobile(_phoneView.textName) )
    {
        NSString *type = self.nsIsChange?@"modify_password":@"set_password";
        [YLSafeTool sendVerificationCode:@{@"mobile":_phoneView.textName,@"handle_type":type}
                                  success:^{
                                      [self sendGetCode];
                                  }];
    }
    else if ( _phoneView.textName.length <= 0 )
    {
        [MBProgressHUD showMessageIsWait:@"请輸入手机号" wait:YES];
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

#pragma mark -绑定成功
-(void)rightClickSuccess
{
    if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)])
    {
        [self.baseDelegate OnPushController:0 wParam:nil];
    }
}
@end
