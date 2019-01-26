//
//  HYLoginPhoneNumAndInviteCodeView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYLoginPhoneNumAndInviteCodeView.h"
#import "HYLoginTextFieldView.h"
#import "HYSystemLoginMsg.h"

@interface HYLoginPhoneNumAndInviteCodeView()
{
    
    HYLoginTextFieldView        *_phoneView;
    HYLoginTextFieldView        *_codeView;//验证码
    HYLoginTextFieldView        *_inviteView;//邀请码
    UIButton                    *_inviteImageBtn;//
    UIButton                    *_loginBtn;//登录
    UIButton                    *_codeBtn;//获取验证码
    NSTimer                     *_codeTimer;
    NSInteger                   _nTimerCount;
    
    UILabel                     *_inviteLable;//邀请码提示
    
}


@end

@implementation HYLoginPhoneNumAndInviteCodeView

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
    
    rect.origin.x = _codeView.frame.origin.x;
    rect.size.height = _codeView.frame.size.height;
    rect.origin.y = _codeView.frame.origin.y +  rect.size.height;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    if ( _inviteView == nil )
    {
        _inviteView = [[HYLoginTextFieldView alloc] init];
        _inviteView.textMinLength = 6;
        _inviteView.textMaxLength = 11;
        _inviteView.iconImageName = @"Loginyaoqingma";
        _inviteView.textPlaceName = @"请输入邀请码";
        _inviteView.keyboardType = UIKeyboardTypeNumberPad;
        _inviteView.textIsEnabled = YES;
        _inviteView.secureTextEntry = NO;
        _inviteView.textRightWidth = 66.0f;
        _inviteView.frame = rect;
        [self.pBaseView addSubview:_inviteView];
    }else
    {
        _inviteView.frame = rect;
    }
    
    rect.size.width = 22.0f;
    rect.size.height = 22.0f;
    rect.origin.y += (_inviteView.frame.size.height - rect.size.height)/2.0f;
    rect.origin.x = frame.size.width - rect.size.width - _inviteView.frame.origin.x;
    if ( _inviteImageBtn == nil)
    {
        _inviteImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteImageBtn.frame = rect;
        _inviteImageBtn.backgroundColor = [UIColor clearColor];
        [_inviteImageBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [_inviteImageBtn setBackgroundImage:[UIImage imageNamed:@"Loginguize"] forState:UIControlStateNormal];
        [self.pBaseView addSubview:_inviteImageBtn];
    }
    else
    {
        _inviteImageBtn.frame = rect;
    }
    
    rect.origin.x = _inviteView.frame.origin.x;
    rect.origin.y = _inviteView.frame.origin.y;
    rect.size.height = _inviteView.frame.size.height;
    rect.origin.y += rect.size.height+10.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 17.0f;
    if ( _inviteLable == nil )
    {
        _inviteLable = NewObject(UILabel);
        _inviteLable.text = @"向身边的嗨客获取邀请码入驻可获取5元优惠券";
        _inviteLable.textColor = kHEXCOLOR(0x999999);
        _inviteLable.textAlignment = NSTextAlignmentLeft;
        _inviteLable.font = [UIFont systemFontOfSize:12.0f];
        _inviteLable.frame = rect;
        [self.pBaseView addSubview:_inviteLable];
    }else
    {
        _inviteLable.frame = rect;
    }
    
    rect.origin.y += rect.size.height + 28.0f;
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
        [self clickCodeBtn];
    }
    else if ( sender == _inviteImageBtn )
    {
        AfxMessageTitle(@"嗨云是基于社交的私密购物圈，您可以通过已注册的嗨云用户邀请进入嗨云，也许你身边的Ta已开通嗨云，赶紧联系Ta索取邀请码吧！",@"提示");
    }
    else if ( sender == _loginBtn )
    {
        NSString *msg = nil;
        if ( !HYJudgeMobile(_phoneView.textName) )
        {
            msg = @"请输入正确的手机号码";
        }
        else if ( _codeView.textName.length < 4 || _codeView.textName.length > 6 )
        {
            msg = @"请输入正确的验证码";
        }
//        else if ( _inviteView.textName.length<6 )
//        {
//            msg = @"请输入邀请码";
//        }
        if ( msg != nil)
        {
            [MBProgressHUD showMessageIsWait:msg wait:YES];
            return;
        }
        
        [HYSystemLoginMsg sendUpdateUserLoginInfoMiss:@{
                                                        @"mobile":_phoneView.textName,
                                                        @"verify_code":_codeView.textName,
                                                        @"invitation_code":_inviteView.textName}];
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
