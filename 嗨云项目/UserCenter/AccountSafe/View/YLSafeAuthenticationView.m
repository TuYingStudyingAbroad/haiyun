//
//  YLSafeAuthenticationView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeAuthenticationView.h"
#import "HYTextFieldBaseView.h"
#import "YLSafeTool.h"

@interface YLSafeAuthenticationView ()<HYTextFieldBaseViewDelegate>
{
    HYTextFieldBaseView         *_cardView;
}

@end

@implementation YLSafeAuthenticationView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    
    CGRect rect = CGRectMake(0.0f, 10.0f, frame.size.width, 45.0f);
    if ( _cardView == nil )
    {
        _cardView = [[HYTextFieldBaseView alloc] init];
        _cardView.textMinLength = 15;
        _cardView.textMaxLength = 18;
        _cardView.iconImageName = @"HYSafeshenfenzheng";
        _cardView.textPlaceName = @"请输入实名认证的身份证号码";
        _cardView.keyboardType = UIKeyboardTypeDefault;
        _cardView.secureTextEntry = NO;
        _cardView.textIsEnabled = YES;
        _cardView.frame = rect;
        _cardView.delegate = self;
        [self addSubview:_cardView];
    }else
    {
        _cardView.frame = rect;
    }
}



#pragma mark -点击完成
-(void)onButtonClickRight
{
    NSString *msg = nil;
    CloseKeyBord(YES);
    if ( !HYJudgeCard(_cardView.textName) )
    {
        msg = @"请输入正确的实名认证身份证号码";
    }
    if ( msg != nil)
    {
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return;
    }
    
    if ( ISNSStringValid(self.nsPassword) )
    {
        [YLSafeTool sendUserPayPwdReset:@{@"pay_pwd":self.nsPassword,
                                          @"once_pay_pwd":self.nsPassword,
                                          @"id_card":_cardView.textName,
                                          @"payFlag":@"0"}
                                success:^{
            [self checkSuccessCardType:1];
        } failure:^{
//            [self checkSuccessCardType:2];
        }];
        
    }else
    {
        [YLSafeTool sendUserModifyUserMobileCheck:@{@"bank_personal_id":_cardView.textName,
                                                    @"mFlag":@"1"} success:^{
            [self checkSuccessCardType:0];
        }];
    }
    
    
    
}
#pragma mark -验证成功
-(void)checkSuccessCardType:(NSInteger)type
{
    if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)]  )
    {
        [self.baseDelegate OnPushController:type wParam:nil];
    }
}
#pragma mark -HYTextFieldBaseViewDelegate
-(void)HYTextFieldBaseView:(HYTextFieldBaseView *)textView
                 textField:(NSString *)textFieldName
{
    if ( textView == _cardView )
    {
        
    }
    
}

@end
