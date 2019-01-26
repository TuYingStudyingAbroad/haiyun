//
//  YLSafeBandCardView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeBandCardView.h"
#import "HYTextFieldBaseView.h"
#import "HYUIPickerView.h"
#import "YLSafeTool.h"

@interface YLSafeBandCardView ()<HYTextFieldBaseViewDelegate,HYUIPickerViewDelegate>
{
    UILabel                     *_bankLabel;
    /**
     *  银行卡
     */
    HYTextFieldBaseView         *_bankView;
    UIImageView                 *_bankRightImageView;
    UIButton                    *_bankBtn;
    HYUIPickerView              *_Picker;//银行卡选择
    NSInteger                   _nOneSelect;
       /**
     *  银行卡号
     */
    HYTextFieldBaseView        *_bankNumView;
    /**
     *  开户信息
     */
    UILabel                     *_cardLabel;
    HYTextFieldBaseView        *_nameView;//名字
    HYTextFieldBaseView        *_cardView;//身份证号
    HYTextFieldBaseView        *_cardNumView;//预留手机号码
    HYTextFieldBaseView        *_codeView;//验证码
    NSTimer                     *_codeTimer;
    NSInteger                   _nTimerCount;
    UIButton                    *_codeBtn;
}

@property (nonatomic, strong)  NSMutableArray       *pPickerArr;

@end

@implementation YLSafeBandCardView

- (NSMutableArray *)pPickerArr
{
    if ( _pPickerArr == nil ) {
        _pPickerArr = [NSMutableArray array];
    }
    return _pPickerArr;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"realbankLogo" ofType:@"plist"];
       NSDictionary *banksDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        _nOneSelect = 0;
        _nTimerCount = 120;
        [self.pPickerArr removeAllObjects];
        [self.pPickerArr addObjectsFromArray:[banksDic allKeys]];
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, frame.size.width, 30.0f);
    
    if ( _bankLabel == nil )
    {
        _bankLabel = NewObject(UILabel);
        _bankLabel.backgroundColor = [UIColor clearColor];
        _bankLabel.text = @"添加提现账户（仅支持储蓄卡），同时完成实名认证";
        _bankLabel.font = [UIFont systemFontOfSize:11.0f];
        _bankLabel.textColor = kHEXCOLOR(0x999999);
        _bankLabel.textAlignment = NSTextAlignmentCenter;
        _bankLabel.frame = rect;
        [self.pBaseView addSubview:_bankLabel];
    }else
    {
        _bankLabel.frame = rect;
    }
    /**
     *  银行
     */
    rect.origin.y += rect.size.height;
    rect.size.height = 44.0f;
    if ( _bankView == nil )
    {
        _bankView = NewObject(HYTextFieldBaseView);
        _bankView.textMinLength = 0;
        _bankView.textMaxLength = 100;
        _bankView.iconImageName = @"HYSafeyinhang";
        _bankView.textPlaceName = @"请选择发卡银行";
        _bankView.keyboardType = UIKeyboardTypeURL;
        _bankView.textIsEnabled = NO;
        _bankView.secureTextEntry = NO;
        _bankView.delegate = self;
        _bankView.textRightWidth = 30.0f;
        _bankView.frame = rect;
        [self.pBaseView addSubview:_bankView];
    }else
    {
        _bankView.frame = rect;
    }
    
    rect.size.height = 18.0f;
    rect.size.width = 18.0f;
    rect.origin.x = frame.size.width - rect.size.width - 8.0f;
    rect.origin.y += (_bankView.frame.size.height - rect.size.height)/2.0f;
    if (_bankRightImageView  == nil)
    {
        _bankRightImageView = NewObject(UIImageView);
        _bankRightImageView.image = [UIImage imageNamed:@"qiehuan"];
        _bankRightImageView.frame = rect;
        [self addSubview:_bankRightImageView];
    }else
    {
        _bankRightImageView.frame = rect;
    }
    
    rect = _bankView.frame;
    if ( _bankBtn == nil)
    {
        _bankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bankBtn.frame = rect;
        _bankBtn.backgroundColor = [UIColor clearColor];
        [_bankBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bankBtn];
    }
    else
    {
        _bankBtn.frame = rect;
    }
    /**
     *  银行卡号
     */
    rect.origin.y += rect.size.height;
    if ( _bankNumView == nil )
    {
        _bankNumView = [[HYTextFieldBaseView alloc] init];
        _bankNumView.textMinLength = 16;
        _bankNumView.textMaxLength = 23;
        _bankNumView.iconImageName = @"HYSafeyinhangka";
        _bankNumView.textPlaceName = @"请输入银行卡号";
        _bankNumView.keyboardType = UIKeyboardTypeNumberPad;
        _bankNumView.textIsEnabled = YES;
        _bankNumView.secureTextEntry = NO;
        _bankNumView.bottomHide = YES;
        _bankNumView.delegate = self;
        _bankNumView.frame = rect;
        [self.pBaseView addSubview:_bankNumView];
    }else
    {
        _bankNumView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.size.height = 30.0f;
    if ( _cardLabel == nil )
    {
        _cardLabel = NewObject(UILabel);
        _cardLabel.backgroundColor = [UIColor clearColor];
        _cardLabel.text = @"请填写银行卡认证信息（仅用于银行实名验证）";
        _cardLabel.font = [UIFont systemFontOfSize:11.0f];
        _cardLabel.textColor = kHEXCOLOR(0x999999);
        _cardLabel.textAlignment = NSTextAlignmentCenter;
        _cardLabel.frame = rect;
        [self.pBaseView addSubview:_cardLabel];
    }else
    {
        _cardLabel.frame = rect;
    }

    rect.origin.y += rect.size.height;
    rect.size.height = 44.0f;
    if ( _nameView == nil )
    {
        _nameView = NewObject(HYTextFieldBaseView);
        _nameView.textMinLength = 2;
        _nameView.textMaxLength = 12;
        _nameView.iconImageName = @"HYSafeyonghuming";
        _nameView.textPlaceName = @"开户人姓名";
        _nameView.keyboardType = UIKeyboardTypeDefault;
        _nameView.textIsEnabled = YES;
        _nameView.secureTextEntry = NO;
        _nameView.delegate = self;
        _nameView.frame = rect;
        [self.pBaseView addSubview:_nameView];
    }else
    {
        _nameView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _cardView == nil )
    {
        _cardView = NewObject(HYTextFieldBaseView);
        _cardView.textMinLength = 15;
        _cardView.textMaxLength = 18;
        _cardView.iconImageName = @"HYSafeshenfenzheng";
        _cardView.textPlaceName = @"开户人身份证号";
        _cardView.keyboardType = UIKeyboardTypeDefault;
        _cardView.textIsEnabled = YES;
        _cardView.secureTextEntry = NO;
        _cardView.delegate = self;
        _cardView.frame = rect;
        [self.pBaseView addSubview:_cardView];
    }else
    {
        _cardView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _cardNumView == nil )
    {
        _cardNumView = NewObject(HYTextFieldBaseView);
        _cardNumView.textMinLength = 1;
        _cardNumView.textMaxLength = 11;
        _cardNumView.iconImageName = @"HYSafeshouji";
        _cardNumView.textPlaceName = @"银行预留手机号";
        _cardNumView.keyboardType = UIKeyboardTypeNumberPad;
        _cardNumView.textIsEnabled = YES;
        _cardNumView.secureTextEntry = NO;
        _cardNumView.delegate = self;
        _cardNumView.frame = rect;
        [self.pBaseView addSubview:_cardNumView];
    }else
    {
        _cardNumView.frame = rect;
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
    
    CGRect rectBaseView = _pBaseView.frame;
    rectBaseView.size.height = rect.origin.y + rect.size.height + 1.0f;
    _pBaseView.frame = rectBaseView;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.contentSize = CGSizeMake(0,_pBaseView.frame.size.height);
    
}

-(void)onButton:(id)sender
{
    if ( sender == _bankBtn )
    {
        [self showPicker];
    }
    else if ( sender == _codeBtn )
    {
        [self clickCodeBtn];
    }
}

#pragma mark -HYLoginTextFieldViewDelegate
-(void)HYLoginTextFieldView:(HYTextFieldBaseView *)textView
                  textField:(NSString *)textFieldName
{
    if ( textView == _bankView )
    {
        
    }
}

-(void)onButtonClickRight
{
    NSString *msg = nil;
    CloseKeyBord(YES);
    if ( _bankView.textName.length <= 0 )
    {
        msg = @"请选择银行";
    }
    else if ( !HYJudgeBandCard(_bankNumView.textName) )
    {
        msg = @"请输入正确的银行卡号";
    }
    else if ( _nameView.textName.length < 2 || _nameView.textName.length > 12 )
    {
        msg = @"请输入正确的开户人姓名";
    }
    else if ( !HYJudgeIdCardCheckUtil(_cardView.textName) )
    {
        msg = @"请输入正确的预留身份证号";
    }
    else if ( !HYJudgeMobile(_cardNumView.textName) )
    {
        msg = @"请输入正确的银行预留手机号码";
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
    [YLSafeTool sendUserAuthonSave:@{@"bank_name":_bankView.textName,
                                     @"bank_no":_bankNumView.textName,
                                     @"bank_realname":_nameView.textName,
                                     @"bank_personal_id":_cardView.textName,
                                     @"bank_mobile":_cardNumView.textName,
                                     @"send_code":_codeView.textName}
                           success:^{
                    [self bandCardSuccess];
    }];
}

#pragma mark -绑定成功
-(void)bandCardSuccess
{
    if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)])
    {
        [self.baseDelegate OnPushController:0 wParam:nil];
    }
}

#pragma mark -验证码倒计时
-(void)clickCodeBtn
{
    if ( HYJudgeMobile(_cardNumView.textName) )
    {
        [YLSafeTool sendVerificationCode:@{@"mobile":_cardNumView.textName,@"handle_type":@"real_name_auth"}
                                  success:^{
                                      [self sendGetCode];
                                  }];
    }
    else if ( _cardNumView.textName.length <= 0 )
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

#pragma mark -
-(void)showPicker
{
    CloseKeyBord(YES);
    [self HiddenPicker:self];
    
    if ( _pPickerArr == nil || [_pPickerArr count] < 1 )
        return;
    
    if (_Picker == NULL)
    {
        _Picker = [[HYUIPickerView alloc] init];
        _Picker.backgroundColor = [UIColor whiteColor];
        _Picker.delegate = self;
        
        _Picker.frame = UIAppWindow.frame;
        
        [UIAppWindow addSubview:_Picker];
    }
    
    //加上动画效果，从底部弹出来
    CATransition *animation = [CATransition animation];//初始化动画
    animation.duration = 0.2f;//间隔的时间
    animation.timingFunction = UIViewAnimationCurveEaseInOut;//过渡效果
    animation.type = kCATransitionPush;//设置上面4种动画效果
    animation.subtype = kCATransitionFromTop;//设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
    [_Picker.layer addAnimation:animation forKey:@"animationID"];
}

-(void)HiddenPicker:(id)sender
{
    if (sender == self)
    {
        if (_Picker &&!_Picker.hidden)
        {
            
            CATransition *animation = [CATransition animation];//初始化动画
            animation.duration = 0.2f;//间隔的时间
            animation.timingFunction = UIViewAnimationCurveEaseInOut;//过渡效果
            animation.type = kCATransitionPush;//设置上面4种动画效果
            animation.subtype = kCATransitionFromBottom;//设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
            [_Picker.layer addAnimation:animation forKey:@"animationID"];
            _Picker.hidden = YES;
            
            [_Picker removeFromSuperview];
            _Picker = nil;
        }
    }
}

- (void)onColosePickerView
{
    [self HiddenPicker:self];
}

- (void)OnSelectOKPickerview
{
    if ( _nOneSelect < self.pPickerArr.count )
    {
        if ( _bankView )
        {
            _bankView.textName = self.pPickerArr[_nOneSelect];
            [_bankView setNowTextName:self.pPickerArr[_nOneSelect]];
        }
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return  self.pPickerArr.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if ( row >=0 && row < self.pPickerArr.count  ) {
        return self.pPickerArr[row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _nOneSelect = row;
    [self OnSelectOKPickerview];
}


@end
