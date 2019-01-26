//
//  HYLoginTextFieldView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYLoginTextFieldView.h"

@interface HYLoginTextFieldView()<UITextFieldDelegate>
{
    UIView              *_lineView;
    UIImageView         *_iconImage;
    UITextField         *_iputtextField;
}

@end

@implementation HYLoginTextFieldView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
        self.textName = @"";
        self.textRightWidth = 0.0f;
        self.textColor = kHEXCOLOR(0x252525);
        self.textFont = [UIFont systemFontOfSize:15.0f];
        self.keyboardType = UIKeyboardTypeDefault;
        self.textIsEnabled = YES;
        self.secureTextEntry = NO;
        self.bottomHide = NO;
        self.textMaxLength = 100;
        self.textMinLength = 0;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    CGRect rect = CGRectMake(0.0f, 13.0f, 24.0f, 24.0f);
    if ( _iconImage == nil )
    {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:self.iconImageName];
        _iconImage.frame = rect;
        [self addSubview:_iconImage];
    }else
    {
        _iconImage.image = [UIImage imageNamed:self.iconImageName];
        _iconImage.frame = rect;
    }
    rect.origin.x += rect.size.width + 11.0f;
    rect.size.width = frame.size.width - rect.origin.x - self.textRightWidth;
    if ( _iputtextField == nil )
    {
        _iputtextField = [[UITextField alloc] init];
        _iputtextField.textAlignment = NSTextAlignmentLeft;
        _iputtextField.textColor = self.textColor;
        _iputtextField.font = self.textFont;
        _iputtextField.backgroundColor = [UIColor clearColor];
        _iputtextField.placeholder = self.textPlaceName;
        _iputtextField.text = ISNSStringValid(self.textName)?self.textName:@"";
        _iputtextField.keyboardType = self.keyboardType;
        _iputtextField.userInteractionEnabled = self.textIsEnabled;
        _iputtextField.clearButtonMode = self.textIsEnabled ? UITextFieldViewModeWhileEditing:UITextFieldViewModeNever;
        _iputtextField.delegate = self;
        _iputtextField.frame = rect;
        _iputtextField.secureTextEntry = self.secureTextEntry;
        [self addSubview:_iputtextField];
        [_iputtextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }else
    {
        _iputtextField.placeholder = self.textPlaceName;
        _iputtextField.text = self.textName;
        _iputtextField.text = ISNSStringValid(self.textName)?self.textName:@"";
        _iputtextField.keyboardType = self.keyboardType;
        _iputtextField.userInteractionEnabled = self.textIsEnabled;
        _iputtextField.clearButtonMode = self.textIsEnabled ? UITextFieldViewModeWhileEditing:UITextFieldViewModeNever;
        _iputtextField.secureTextEntry = self.secureTextEntry;
        _iputtextField.frame = rect;
    }
    rect.origin.x = 0;
    rect.size.height = 0.5f;
    rect.origin.y = frame.size.height - rect.size.height-1.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    if ( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.frame = rect;
        _lineView.backgroundColor = kHEXCOLOR(0xe5e5e5);
        _lineView.hidden = self.bottomHide;
        [self addSubview:_lineView];
    }else
    {
        _lineView.hidden = self.bottomHide;
        _lineView.frame = rect;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( textField ==  _iputtextField )
    {
        if (  range.location > self.textMaxLength )
        {
            return NO;
        }
    }
    return YES;
}
-(void)textFieldDidChange:(id)sender
{
    if ( sender == _iputtextField  && self.textIsEnabled )
    {
        if ( _iputtextField.text.length > self.textMaxLength )
        {
            _iputtextField.text = [_iputtextField.text substringToIndex:self.textMaxLength];
        }
        self.textName = _iputtextField.text;
        if (  _delegate && [_delegate respondsToSelector:@selector(HYLoginTextFieldView:textField:)])
        {
            [_delegate HYLoginTextFieldView:self textField:_iputtextField.text];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
