//
//  HYRegisterView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYRegisterView.h"
#import "HYLoginTextFieldView.h"
#import "HYSystemLoginMsg.h"
//#import "HYRegAddress.h"
#import "UIAlertView+Blocks.h"
#import "HYSystemInit.h"

@interface HYRegisterView()<HYLoginTextFieldViewDelegate>
{
    HYLoginTextFieldView        *_phoneView;//手机号码
    HYLoginTextFieldView        *_codeView;//验证码
    HYLoginTextFieldView        *_inviteView;//邀请码
    HYLoginTextFieldView        *_passwView;//密码
    UIButton                    *_loginBtn;//登录
    UIButton                    *_codeBtn;//获取验证码
    UIButton                    *_inviteImageBtn;//邀请码信息提示
    NSTimer                     *_codeTimer;//定时器
    NSInteger                   _nTimerCount;//倒计时
    BOOL                        _isCodeType;//YES短信验证码，NO语音验证码
    UIButton                    *_inviteBtn;//获取手机通讯录Btn
    
    UILabel                     *_inviteLable;//嗨客提示
    
    UIButton                    *_changeBtn;//已有账号登陆

}
@end

@implementation HYRegisterView

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
        _phoneView.textMinLength = 4;
        _phoneView.textMaxLength = 11;
        _phoneView.iconImageName = @"Loginshouji";
        _phoneView.textPlaceName = @"请輸入手机号";
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
        _codeView.delegate = self;
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
        [_codeBtn setTitle:(_isCodeType?@"获取验证码":@"语音验证码") forState:UIControlStateNormal];
        [_codeBtn setTitleColor:(_isCodeType?kHEXCOLOR(kRedColor):kHEXCOLOR(0x05be03)) forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _codeBtn.frame = rect;
        _codeBtn.backgroundColor = [UIColor clearColor];
        [_codeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self.pBaseView addSubview:_codeBtn];
    }
    else
    {
        [_codeBtn setTitle:(_isCodeType?@"获取验证码":@"语音验证码") forState:UIControlStateNormal];
        [_codeBtn setTitleColor:(_isCodeType?kHEXCOLOR(kRedColor):kHEXCOLOR(0x05be03)) forState:UIControlStateNormal];
        _codeBtn.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.origin.x = _codeView.frame.origin.x;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    if ( _passwView == nil )
    {
        _passwView = [[HYLoginTextFieldView alloc] init];
        _passwView.textMinLength = 6;
        _passwView.textMaxLength = 15;
        _passwView.iconImageName = @"Loginmima";
        _passwView.textPlaceName = @"请设置6-15位密码";
        _passwView.keyboardType = UIKeyboardTypeDefault;
        _passwView.textIsEnabled = YES;
        _passwView.secureTextEntry = YES;
        _passwView.delegate = self;
        _passwView.frame = rect;
        [self.pBaseView addSubview:_passwView];
    }else
    {
        _passwView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _inviteView == nil )
    {
        _inviteView = [[HYLoginTextFieldView alloc] init];
        _inviteView.textMinLength = 6;
        _inviteView.textMaxLength = 11;
        _inviteView.iconImageName = @"Loginyaoqingma";
        _inviteView.textPlaceName = @"请输入邀请码(非必填)";
        _inviteView.keyboardType = UIKeyboardTypeNumberPad;
        _inviteView.textIsEnabled = YES;
        _inviteView.secureTextEntry = NO;
        _inviteView.delegate = self;
        _inviteView.textRightWidth = 80.0f;  //116.0f;
        _inviteView.frame = rect;
        [self.pBaseView addSubview:_inviteView];
    }else
    {
        _inviteView.frame = rect;
    }
    
    //    rect.size.width = 111.0f;
    //    rect.size.height = 22.0f;
    //    rect.origin.y += (_inviteView.frame.size.height - rect.size.height)/2.0f;
    //    rect.origin.x = frame.size.width - rect.size.width - _inviteView.frame.origin.x;
    //    rect.size.width = 86.0f;
    //    if ( _inviteBtn == nil)
    //    {
    //        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _inviteBtn.frame = rect;
    //        _inviteBtn.backgroundColor = [UIColor clearColor];
    //        [_inviteBtn setTitle:@"获取注册邀请码" forState:UIControlStateNormal];
    //        [_inviteBtn setTitleColor:kHEXCOLOR(kRedColor) forState:UIControlStateNormal];
    //        _inviteBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    //        [_inviteBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
    //        [self.pBaseView addSubview:_inviteBtn];
    //    }
    //    else
    //    {
    //        _inviteBtn.frame = rect;
    //    }
    
    //    rect.origin.x += rect.size.width + 3.0f;
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
        _inviteLable.text = @"向身边的嗨客获取邀请码入驻可获赠5元优惠券";
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
        [_loginBtn setTitle:@"注册并登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _loginBtn.frame = rect;
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.layer.cornerRadius = 5.0;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.backgroundColor = kColor(219.0f, 219.0f, 219.0f);
        [_loginBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.pBaseView addSubview:_loginBtn];
    }
    else
    {
        _loginBtn.frame = rect;
    }
    
    rect.origin.y += rect.size.height + 3.0f;
    rect.size.width = 120.0f;
    rect.origin.x = frame.size.width-rect.size.width -30.0f;
    rect.size.height = 30.0f;
    if ( _changeBtn == nil)
    {
        
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:@"已有账号，登录" forState:UIControlStateNormal];
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
        _changeBtn.frame = rect;
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
    else if ( sender == _loginBtn )
    {
        [self clickRegiserBtn];
    }
    else if ( sender == _inviteImageBtn )
    {
        AfxMessageTitle(@"嗨云是基于社交的私密购物圈，您可以通过已注册的嗨云用户邀请进入嗨云，也许你身边的Ta已开通嗨云，赶紧联系Ta索取邀请码吧！",@"提示");
    }else if ( sender == _changeBtn )
    {
        [[HYSystemInit sharedInstance].navigationController popViewControllerAnimated:YES];
    }
//    else if ( sender == _inviteBtn )
//    {
//        [HYRegAddress checkAddressBookAuthorization:^(bool isAuthorized){
//            if( isAuthorized )
//            {
//                [HYSystemLoginMsg OnDealMes:HYSystemRegisterContact wParam:0 animated:YES];
//            }
//            else
//            {
//                [UIAlertView showWithTitle:@"提示"
//                                   message:@"授权手机通讯录，找到朋友注册验证码"
//                         cancelButtonTitle:@"取消"
//                         otherButtonTitles:@[@"确定"]
//                                  tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//                                      if ( buttonIndex == 1  )
//                                      {
//                                          NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                                          if([[UIApplication sharedApplication] canOpenURL:url])
//                                          {
//                                              NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                                              [[UIApplication sharedApplication] openURL:url];
//                                          }
//                                      }
//                                      
//                                  }];
//            }
//        }];
//        
//    }
}

#pragma mark -HYLoginTextFieldViewDelegate
-(void)HYLoginTextFieldView:(HYLoginTextFieldView *)textView
                  textField:(NSString *)textFieldName
{
    if ( HYJudgeMobile(_phoneView.textName)
        && !(_passwView.textName.length<6 || _passwView.textName.length > 15)
        && HYJudgePassword(_passwView.textName)
        && !( _codeView.textName.length < 4 || _codeView.textName.length > 6))
    {
        _loginBtn.backgroundColor = kHEXCOLOR(kRedColor);
    }
    else
    {
        _loginBtn.backgroundColor = kColor(219.0f, 219.0f, 219.0f);
    }
}

#pragma mark -点击注册
-(void)clickRegiserBtn
{
    NSString *msg = nil;
    
    if ( !HYJudgeMobile(_phoneView.textName) )
    {
        msg = @"请输入正确的手机号码";
    }
    else if ( _passwView.textName.length<6 || _passwView.textName.length > 15 )
    {
        msg = @"请输入6-15位密码";
    }
    else if ( !HYJudgePassword(_passwView.textName)  )
    {
        msg =  @"密码只限英文字母或数字";
    }
    else if ( _codeView.textName.length < 4 || _codeView.textName.length > 6 )
    {
        msg = @"请输入正确的验证码";
    }
//    else if ( _inviteView.textName.length<6 )
//    {
//        msg = @"请输入正确的邀请码";
//    }
    if ( msg != nil)
    {
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return;
    }
    [HYSystemLoginMsg regiserWidth:@{@"mobile":_phoneView.textName,
                                     @"invitation_code":_inviteView.textName,
                                     @"password":_passwView.textName,
                                     @"verify_code":_codeView.textName,
                                     @"register_flag":@"0"} protocolIds:self.protocolIds];
}

#pragma mark -验证码倒计时
-(void)clickCodeBtn
{
    if ( HYJudgeMobile(_phoneView.textName) )
    {
        [HYSystemLoginMsg sendVerificationCode:@{@"mobile":_phoneView.textName,
                                                 @"handle_type":@"register"}
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
//    _isCodeType = !_isCodeType;
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
        [_codeBtn setTitle:(_isCodeType?@"获取验证码":@"语音验证码") forState:UIControlStateNormal];
        [_codeBtn setTitleColor:(_isCodeType?kHEXCOLOR(kRedColor):kHEXCOLOR(0x05be03)) forState:UIControlStateNormal];
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

@end
