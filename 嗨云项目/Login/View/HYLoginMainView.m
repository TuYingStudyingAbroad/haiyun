//
//  HYLoginMainView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYLoginMainView.h"
#import "HYLoginTextFieldView.h"
#import "HYSystemLoginMsg.h"
#import "YLWXLoginView.h"
#import "HYThreeDealMsg.h"

@interface HYLoginMainView()<HYLoginTextFieldViewDelegate>
{
    HYLoginTextFieldView            *_phoneView;//手机号码
    HYLoginTextFieldView            *_passwView;//密码
    UIButton                        *_loginBtn;//登录
    UIButton                        *_codeBtn;//获取验证码
    UIButton                        *_changeBtn;//更改登录方式
    UIButton                        *_regiserBtn;//注册
    NSTimer                         *_codeTimer;//倒计时定时器
    NSInteger                       _nTimerCount;
    BOOL                            _isCodeType;//YES短信验证码，NO语音验证码
    BOOL                            _loginState;//yes密码登录，NO验证码登录
    YLWXLoginView                   *_WXLoginView;//微信登录
}

@end

@implementation HYLoginMainView

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
        _loginState = YES;
        _isCodeType = YES;
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
        _phoneView.delegate = self;
        _phoneView.frame = rect;
        [self.pBaseView addSubview:_phoneView];
    }else
    {
        _phoneView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _passwView == nil )
    {
        _passwView = [[HYLoginTextFieldView alloc] init];
        _passwView.textMinLength = _loginState?1:4;
        _passwView.textMaxLength = _loginState?25:6;
        _passwView.iconImageName = _loginState?@"Loginmima":@"Loginyanzhengma";
        _passwView.textPlaceName = _loginState?@"请输入密码":@"请输入验证码";
        _passwView.keyboardType = _loginState?UIKeyboardTypeDefault:UIKeyboardTypeNumberPad;
        _passwView.textIsEnabled = YES;
        _passwView.secureTextEntry = _loginState;
        _passwView.delegate = self;
        _passwView.textRightWidth = _loginState?0.0f:66.0f;
        _passwView.frame = rect;
        [self.pBaseView addSubview:_passwView];
    }else
    {
        _passwView.textMinLength = _loginState?1:4;
        _passwView.textMaxLength = _loginState?25:6;
        _passwView.iconImageName = _loginState?@"Loginmima":@"Loginyanzhengma";
        _passwView.textPlaceName = _loginState?@"请输入密码":@"请输入验证码";
        _passwView.keyboardType = _loginState?UIKeyboardTypeDefault:UIKeyboardTypeNumberPad;
        _passwView.secureTextEntry = _loginState;
        _passwView.textRightWidth = _loginState?0.0f:66.0f;
        _passwView.textName = @"";
        _passwView.frame = rect;
    }
    
    rect.size.width = 66.0f;
    rect.origin.x = frame.size.width - rect.size.width - _passwView.frame.origin.x;
    if ( _codeBtn == nil)
    {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeBtn setTitle:(_isCodeType?@"获取验证码":@"语音验证码") forState:UIControlStateNormal];
        [_codeBtn setTitleColor:(_isCodeType?kHEXCOLOR(kRedColor):kHEXCOLOR(0x05be03)) forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _codeBtn.frame = rect;
        _codeBtn.backgroundColor = [UIColor clearColor];
        _codeBtn.userInteractionEnabled = YES;
        [_codeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        _codeBtn.hidden = _loginState;
        [self.pBaseView addSubview:_codeBtn];
    }
    else
    {
        _codeBtn.hidden = _loginState;
        [_codeBtn setTitle:(_isCodeType?@"获取验证码":@"语音验证码") forState:UIControlStateNormal];
        [_codeBtn setTitleColor:(_isCodeType?kHEXCOLOR(kRedColor):kHEXCOLOR(0x05be03)) forState:UIControlStateNormal];
        _codeBtn.frame = rect;
    }
    
    
    rect.origin.y += rect.size.height + 30.0f;
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
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.layer.cornerRadius = 3.0;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.backgroundColor = kColor(219.0f, 219.0f, 219.0f);
        [_loginBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self.pBaseView addSubview:_loginBtn];
    }
    else
    {
        _loginBtn.frame = rect;
    }
    
    rect.origin.y += rect.size.height + 3.0f;
    rect.size.width = 120.0f;
    rect.origin.x = frame.size.width-rect.size.width -30.0f;
    if ( _changeBtn == nil)
    {
        
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:(_loginState?@"使用验证码登录":@"使用密码登录") forState:UIControlStateNormal];
        [_changeBtn setTitleColor:kHEXCOLOR(0x666666) forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _changeBtn.frame = rect;
        _changeBtn.backgroundColor = [UIColor clearColor];
        [_changeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self.pBaseView addSubview:_changeBtn];
    }
    else
    {
        [_changeBtn setTitle:(_loginState?@"使用验证码登录":@"使用密码登录") forState:UIControlStateNormal];
        _changeBtn.frame = rect;
    }
    
    rect.size.width = 120.0f;
    rect.origin.x = 30.0f;
    if ( _regiserBtn == nil)
    {
        
        _regiserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_regiserBtn setTitle:@"快速注册" forState:UIControlStateNormal];
        [_regiserBtn setTitleColor:kHEXCOLOR(kRedColor) forState:UIControlStateNormal];
        _regiserBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _regiserBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _regiserBtn.frame = rect;
        _regiserBtn.backgroundColor = [UIColor clearColor];
        [_regiserBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self.pBaseView addSubview:_regiserBtn];
    }
    else
    {
        _regiserBtn.frame = rect;
    }
    
    rect.origin.x = 49.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 126.0f;
    rect.origin.y = frame.size.height - 64.0f - rect.size.height - 28.0f;
    if ( _WXLoginView == nil )
    {
        _WXLoginView = NewObject(YLWXLoginView);
        _WXLoginView.frame = rect;
        _WXLoginView.hidden = [HYThreeDealMsg WXLoginIsHide];
        [self.pBaseView addSubview:_WXLoginView];
    }else
    {
        _WXLoginView.frame = rect;
        _WXLoginView.hidden = [HYThreeDealMsg WXLoginIsHide];
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
    CloseKeyBord(YES);
    if ( sender == _codeBtn )
    {
        [self clickCodeBtn];
    }
    else if ( sender == _changeBtn )
    {
        [self endEditing:YES];
        [self changeLoginState];
    }
    else if ( sender == _loginBtn )
    {
        [self loginButtonClicks];
    }
    else if ( sender == _regiserBtn )
    {
        [HYSystemLoginMsg OnDealMes:HYSystemLoginRegister wParam:0 animated:YES];
    }
}

#pragma mark -HYLoginTextFieldViewDelegate
-(void)HYLoginTextFieldView:(HYLoginTextFieldView *)textView
                  textField:(NSString *)textFieldName
{
    if ( textView == _phoneView )
    {
        if ( [textFieldName length] == 11 )
        {
            _loginBtn.userInteractionEnabled = YES;
            _loginBtn.backgroundColor = kHEXCOLOR(kRedColor);
        }else
        {
            _loginBtn.userInteractionEnabled = NO;
            _loginBtn.backgroundColor = kColor(219.0f, 219.0f, 219.0f);
        }
    }
}

#pragma mark -验证码倒计时
-(void)clickCodeBtn
{
    if ( HYJudgeMobile(_phoneView.textName) )
    {
        [HYSystemLoginMsg sendVerificationCode:@{@"mobile":_phoneView.textName,
                                                 @"handle_type":@"login"}
                                  success:^{
            [self sendGetCode];
        }];
    }
    else if ( _phoneView.textName.length <= 0 )
    {
        [MBProgressHUD showMessageIsWait:@"请輸入手机号" wait:YES];
    }
    else
    {
        [MBProgressHUD showMessageIsWait:@"请输入正确的手机号码" wait:YES];
    }
}
-(void)sendGetCode
{
//    _isCodeType = !_isCodeType;
    [_codeTimer invalidate];
    _codeTimer = nil;
    _nTimerCount = 120;
    _codeBtn.userInteractionEnabled = NO;
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setChangeCodeBtn) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_codeTimer forMode:NSDefaultRunLoopMode];
}
-(void)setChangeCodeBtn
{
    _nTimerCount--;
    if (_nTimerCount <= 0)
    {
        [_codeBtn setTitle:(_isCodeType?@"获取验证码":@"语音验证码") forState:UIControlStateNormal];
        [_codeBtn setTitleColor:(_isCodeType?kHEXCOLOR(kRedColor):kHEXCOLOR(0x05be03)) forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = YES;
        _codeBtn.enabled = YES;
        [_codeTimer invalidate];
        _codeTimer = nil;
        _nTimerCount = 120;
    }
    else
    {
        _codeBtn.enabled = NO;
        [_codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)_nTimerCount] forState:UIControlStateNormal];
    }
}

#pragma mark -更改状态
-(void)changeLoginState
{
    _loginState = !_loginState;
    if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)]  )
    {
        [self.baseDelegate OnPushController:0 wParam:(_loginState?@"密码登录":@"验证码登录")];
    }
    [self setFrame:self.frame];
}

#pragma mark -点击登录Button
-(void)loginButtonClicks
{
    NSString *msg = nil;
    if ( !HYJudgeMobile(_phoneView.textName) )
    {
        msg = @"请输入正确手机号码";
    }
    else if ( _loginState && (_passwView.textName.length<1 || _passwView.textName.length>25 ) )
    {
        msg = @"请输入密码";
    }
    else if ( !_loginState && _passwView.textName.length<4 )
    {
        if ( _passwView.textName.length == 0 )
        {
            msg = @"请输入验证码";
        }else
        {
            msg = @"请输入正确的验证码";
        }
    }
    if ( msg != nil)
    {
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return;
    }
    NSString *type = @"1";
    if ( _loginState )
    {
        type = @"0";
    }
    [HYSystemLoginMsg loginWith:_phoneView.textName password:_passwView.textName type:type];
}

@end
