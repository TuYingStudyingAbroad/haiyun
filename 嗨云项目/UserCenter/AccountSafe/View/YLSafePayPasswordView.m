//
//  YLSafePayPasswordView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/14.
//  Copyright © 2016年 杨鑫. All rights reserved.
//



#import "YLSafePayPasswordView.h"

@interface YLSafePayPasswordView ()<UITextFieldDelegate>
{
    //6个黑色的原点
    UIImageView *digitImageViews[6];
}

/**
 *  输入支付密码
 */
@property (nonatomic,weak) UILabel *notionLabel;
/**
 *  密码展示
 */
@property (nonatomic) NSInteger numCount;
/**
 *  键盘响应者
 */
@property (nonatomic,weak) UITextField *responsder;

/** 密码框点击按钮 */
@property (nonatomic,weak) UIButton *fieldBtn;

/**
 *  密码框背景
 */
@property (nonatomic,weak) UIImageView   *fieldBgView;
/**
 *  忘记密码
 */
@property (nonatomic,weak) UIButton *forgetBtn;
@end

@implementation YLSafePayPasswordView

-(id)initWithFrame:(CGRect)frame hideForget:(BOOL)isHide
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
        self.numCount = 0;
        /** 响应者 */
        [self setupResponsder];
        /** 添加子控件 */
        [self setupSubViews];
        /*设置密码*/
        [self setupFieldBackgroundView:isHide];
    }
    return self;
}

#pragma mark -添加子控件
-(void)setupSubViews
{
    /**顶部提示**/
    CGRect  rect = CGRectMake((Main_Screen_Width - Main_Screen_Width * 0.846875)/2.0f, 23.0f, Main_Screen_Width, 20.0f);
    rect.size.width -= 2*rect.origin.x;
    UILabel *notionLabel = NewObject(UILabel);
    notionLabel.backgroundColor = [UIColor clearColor];
    notionLabel.text = @"请输入6位支付密码";
    notionLabel.textColor = kHEXCOLOR(0x999999);
    notionLabel.font = [UIFont systemFontOfSize:14.0f];
    notionLabel.textAlignment = NSTextAlignmentLeft;
    notionLabel.frame = rect;
    [self addSubview:notionLabel];
    self.notionLabel = notionLabel;
    
}

-(void)updateTitleLabel:(NSString *)title
{
    if ( self.notionLabel )
    {
        self.notionLabel.text = title;
    }
}
/** 响应者 */
- (void)setupResponsder
{
    UITextField *responsder = NewObject(UITextField);
    responsder.keyboardType = UIKeyboardTypeNumberPad;
    responsder.hidden = YES;
    responsder.delegate = self;
    [responsder becomeFirstResponder];
    [self addSubview:responsder];
    self.responsder = responsder;
    [self.responsder addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)setupFieldBackgroundView:(BOOL)isHide
{
    CGFloat y = 65.0f;//Main_Screen_Width * 0.40625 * 0.5
    CGFloat w = Main_Screen_Width * 0.846875;
    CGFloat h = Main_Screen_Width * 0.121875;
    CGFloat x = (Main_Screen_Width - w)/2.0f;//Main_Screen_Width * 0.096875 * 0.5
    UIImageView *fieldBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_in"]];
    fieldBgView.frame = CGRectMake(x, y, w, h);
    fieldBgView.backgroundColor = [UIColor whiteColor];
    fieldBgView.userInteractionEnabled = YES;
    [self addSubview:fieldBgView];
    self.fieldBgView = fieldBgView;
    
    CGFloat pointW = 16;
    CGFloat pointH = pointW;
    CGFloat pointY = (h - pointH)/2.0f;
    CGFloat pointX;
    CGFloat padding = (w/6.0f - pointW)/2.0f;
    for (int i = 0; i < 6; i++) {
        pointX =  padding + i * (pointW + 2 * padding);
        digitImageViews[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yuan"]];
        digitImageViews[i].frame = CGRectMake(pointX, pointY, pointW, pointH);
        digitImageViews[i].userInteractionEnabled = YES;
        digitImageViews[i].hidden = YES;
        [fieldBgView addSubview:digitImageViews[i]];
    }
    
    UIButton *fieldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fieldBtn = fieldBtn;
    fieldBtn.frame = CGRectMake(0, 0, w, h);
    [fieldBgView addSubview:fieldBtn];
    [fieldBtn addTarget:self action:@selector(inputBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记支付密码？"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:kHEXCOLOR(0x999999) range:strRange];  //设置颜色
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    self.forgetBtn = forgetBtn;
    [self.forgetBtn setTitleColor:kHEXCOLOR(0x999999) forState:UIControlStateNormal];
    [self.forgetBtn setAttributedTitle:str forState:UIControlStateNormal];
     self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
     self.forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     self.forgetBtn.frame = CGRectMake(Main_Screen_Width-100.0f-x, y+h+6.0f, 100.0f, 23.0f);
     self.forgetBtn.backgroundColor = [UIColor clearColor];
    [self.forgetBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
    self.forgetBtn.hidden = isHide;
    [self addSubview:forgetBtn];
}

#pragma mark -UITextField改变
-(void)textFieldDidChange:(id)sender
{
    if ( sender == self.responsder  )
    {
        NSString *passText = self.responsder.text;
        if ( passText.length > 6) {
            passText = [passText substringToIndex:6];
            self.responsder.text = passText;
        }
        for (int i=0;i<6;i++) {
            digitImageViews[i].hidden = i >= [passText length];
        }
        if ( passText.length == 6 )
        {
            self.responsder.text = @"";
            if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)] ) {
                [self.baseDelegate OnPushController:0 wParam:passText];
            }
        }
    }
}

-(void)onButton:(id)sender
{
    if ( sender == self.forgetBtn )
    {
        if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)] ) {
            [self.baseDelegate OnPushController:1 wParam:nil];
        }
    }
}

-(void)safePayPasswordClearAll
{
    self.responsder.text = @"";
    for (int i=0;i<6;i++)
    {
        digitImageViews[i].hidden = YES;
    }
    [self inputBtnClick];
}
#pragma mark -点击输入框
-(void)inputBtnClick
{
    [self.responsder becomeFirstResponder];
    
}

@end
