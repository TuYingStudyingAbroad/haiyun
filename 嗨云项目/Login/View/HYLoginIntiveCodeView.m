//
//  HYLoginIntiveCodeView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYLoginIntiveCodeView.h"
#import "HYLoginTextFieldView.h"
#import "HYSystemLoginMsg.h"

@interface HYLoginIntiveCodeView()
{
    
    HYLoginTextFieldView        *_inviteView;//邀请码
    UIButton                    *_loginBtn;//登录
    UIButton                    *_inviteImageBtn;//邀请码说明
    
}
@end

@implementation HYLoginIntiveCodeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor whiteColor];
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
    
    rect.origin.y = _inviteView.frame.origin.y;
    rect.origin.x = _inviteView.frame.origin.x;
    rect.size.height = _inviteView.frame.size.height;
    rect.origin.y += rect.size.height + 30.0f;
    rect.size.height = 44.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
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
    if ( sender == _loginBtn )
    {
        NSString *msg = nil;
        if ( _inviteView.textName.length<6 )
        {
            msg = @"请输入邀请码";
        }
        if ( msg != nil)
        {
            [MBProgressHUD showMessageIsWait:msg wait:YES];
            return;
        }
        
        [HYSystemLoginMsg sendUpdateUserLoginInfoMiss:@{
                                                        @"mobile":@"",
                                                        @"password":@"",
                                                        @"verify_code":@"",
                                                        @"invitation_code":_inviteView.textName}];
    }
    else if ( sender == _inviteImageBtn )
    {
        AfxMessageTitle(@"嗨云是基于社交的私密购物圈，您可以通过已注册的嗨云用户邀请进入嗨云，也许你身边的Ta已开通嗨云，赶紧联系Ta索取邀请码吧！",@"提示");
    }
}



@end
