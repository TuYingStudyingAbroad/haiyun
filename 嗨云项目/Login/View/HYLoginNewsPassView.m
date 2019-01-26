//
//  HYLoginNewsPassView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYLoginNewsPassView.h"
#import "HYLoginTextFieldView.h"
#import "HYSystemLoginMsg.h"

@interface HYLoginNewsPassView()
{
    
    HYLoginTextFieldView        *_passwView;//密码
    UIButton                    *_loginBtn;//登录
    
}
@end

@implementation HYLoginNewsPassView

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
    if ( _passwView == nil )
    {
        _passwView = [[HYLoginTextFieldView alloc] init];
        _passwView.textMinLength = 6;
        _passwView.textMaxLength = 15;
        _passwView.iconImageName = @"Loginmima";
        _passwView.textPlaceName = @"请输入密码(只限英文字母和数字)";
        _passwView.keyboardType = UIKeyboardTypeDefault;
        _passwView.textIsEnabled = YES;
        _passwView.secureTextEntry = YES;
        _passwView.frame = rect;
        [self.pBaseView addSubview:_passwView];
    }else
    {
        _passwView.frame = rect;
    }
    rect.origin.y += rect.size.height + 30.0f;
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
    if ( sender == _loginBtn )
    {
        NSString *msg = nil;
        if ( _passwView.textName.length<6 || _passwView.textName.length > 15 )
        {
            msg = @"请输入6-15位密码";
        }
        else if ( !HYJudgePassword(_passwView.textName)  )
        {
            msg =  @"密码只限英文字母或数字";
        }
        if ( msg != nil)
        {
            [MBProgressHUD showMessageIsWait:msg wait:YES];
            return;
        }
        
        [HYSystemLoginMsg sendUpdateUserLoginInfoMiss:@{
                                                        @"password":_passwView.textName,
                                                        }];
    }
    
}

@end
