//
//  HYSafeBandNumView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYSafeBandNumView.h"
#import "HYTextFieldBaseView.h"
#import "YLSafeTool.h"

@interface HYSafeBandNumView ()<HYTextFieldBaseViewDelegate>
{
    HYTextFieldBaseView         *_phoneView;
    HYTextFieldBaseView         *_codeView;
    UIButton                    *_codeBtn;//获取验证码
    NSTimer                     *_codeTimer;
    NSInteger                   _nTimerCount;
    UIButton                    *_numLoseBtn;
}

@end

@implementation HYSafeBandNumView

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
        if ( self.nsPhoneType == 2 )
        {
            _phoneView.textPlaceName = @"请输入新手机号码";
        }else
        {
            _phoneView.textPlaceName = @"请输入手机号码";
        }
        _phoneView.textName = self.nsPhoneNum;
        _phoneView.keyboardType = UIKeyboardTypeNumberPad;
        _phoneView.textIsEnabled = !ISNSStringValid(self.nsPhoneNum);
        _phoneView.secureTextEntry = NO;
        _phoneView.frame = rect;
        _phoneView.delegate = self;
        [self addSubview:_phoneView];
    }else
    {
        _phoneView.textName = self.nsPhoneNum;
        _phoneView.textIsEnabled = !ISNSStringValid(self.nsPhoneNum);
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
        _codeView.bottomHide = YES;
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
    
    rect.origin.y += rect.size.height+8.0f;
    rect.size.height = 22.0f;
    rect.size.width = 90.0f;
    rect.origin.x = frame.size.width - rect.size.width - 12.0f;
    if ( _numLoseBtn == nil)
    {
        _numLoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_numLoseBtn setTitle:@"原号码已丢失？" forState:UIControlStateNormal];
        [_numLoseBtn setTitleColor:kHEXCOLOR(0x666666) forState:UIControlStateNormal];
        _numLoseBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _numLoseBtn.frame = rect;
        _numLoseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _numLoseBtn.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"原号码已丢失？"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSForegroundColorAttributeName value:kHEXCOLOR(0x666666) range:strRange];  //设置颜色
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [_numLoseBtn setAttributedTitle:str forState:UIControlStateNormal];
        [_numLoseBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        _numLoseBtn.hidden = self.nsIsCard;
        [self addSubview:_numLoseBtn];
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
        [self clickCodeBtn];
    }
    else if ( sender == _numLoseBtn )
    {
        if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)]  )
        {
            [self.baseDelegate OnPushController:0 wParam:nil];
        }
    }
}

#pragma mark -点击完成
-(void)onButtonClickRight
{
    NSString *msg = nil;
    CloseKeyBord(YES);
     if ( !HYJudgeMobile(_phoneView.textName) )
    {
        msg = @"请输入正确的手机号码";
    }
    else if ( _codeView.textName.length < 4 ||  _codeView.textName.length > 6 )
    {
        msg = @"请输入正确的验证码";
    }
    if ( msg != nil)
    {
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return;
    }
    if ( ISNSStringValid(self.nsPhoneNum) )
    {
        [self checkOldPhoneNum];
    }else
    {
         if ( self.nsPhoneType == 2 || self.nsPhoneType == 4 )
         {
             [self bandNewPhoneNum:@"0"];
         }
         else
         {
              [self bandNewPhoneNum:@"1"];
         }
        
    }
    
}
#pragma mark -老手机号码验证
-(void)checkOldPhoneNum
{
    [YLSafeTool sendUserModifyUserMobileCheck:@{
                                                @"mobile":_phoneView.textName,
                                                @"verify_code":_codeView.textName,
                                                @"mFlag":@"0"}
                                      success:^{
        [self nextRightSuccess];
    }];
}
#pragma mark -新手机号码绑定
-(void)bandNewPhoneNum:(NSString *)mFlag
{
    [YLSafeTool sendUserMobileupdate:@{
                                       @"mobile":_phoneView.textName,
                                       @"verify_code":_codeView.textName,
                                       @"mFlag":mFlag
                                       }
                             success:^{
                                 [self nextRightSuccess];
                             }];
}
-(void)nextRightSuccess
{
    if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)])
    {
        NSInteger type = 1;
        if ( self.nsPhoneType == 4 )
        {
            type = 4;
        }
        else
        {
            if ( ISNSStringValid(self.nsPhoneNum) )
            {
                type = 2;
            }
        }
        
        [self.baseDelegate OnPushController:type wParam:nil];
    }
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
        NSString *type = @"binding_mobile";
        if ( self.nsPhoneType == 1 )
        {
            type = @"modify_mobile_old";
        }
        else if ( self.nsPhoneType == 2 || self.nsPhoneType == 4 )
        {
            type = @"modify_mobile_new";
        }
        [YLSafeTool sendVerificationCode:@{@"mobile":_phoneView.textName,@"handle_type":type}
                                 success:^{
                                     [self sendGetCode];
                                 }];
    }else if ( _phoneView.textName.length <= 0 )
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
