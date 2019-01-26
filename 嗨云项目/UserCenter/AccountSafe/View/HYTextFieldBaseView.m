//
//  HYTextFieldBaseView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYTextFieldBaseView.h"

@interface HYTextFieldBaseView ()<UITextFieldDelegate>
{
    UIView              *_lineView;
    UIImageView         *_iconImage;
    UITextField         *_iputtextField;
    UIView              *_rightLineView;
}

@end
@implementation HYTextFieldBaseView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
        self.textRightWidth = 0.0f;
        self.rightHide = YES;
        self.bottomHide = NO;
        self.textName = @"";
        self.textMaxLength = INT_MAX;
        self.textMinLength = 0;
        self.keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(12.0f, 0, 20.0f, 20.0f);
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
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
    rect.origin.x += rect.size.width + 12.0f;
    rect.size.width = frame.size.width - rect.origin.x - self.textRightWidth-12.0f;
    if ( _iputtextField == nil )
    {
        _iputtextField = [[UITextField alloc] init];
        _iputtextField.textAlignment = NSTextAlignmentLeft;
        _iputtextField.textColor = [UIColor blackColor];
        _iputtextField.font = [UIFont systemFontOfSize:14.0f];
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
        _iputtextField.text = ISNSStringValid(self.textName)?self.textName:@"";
        _iputtextField.keyboardType = self.keyboardType;
        _iputtextField.userInteractionEnabled = self.textIsEnabled;
        _iputtextField.clearButtonMode = self.textIsEnabled ? UITextFieldViewModeWhileEditing:UITextFieldViewModeNever;
        _iputtextField.frame = rect;
    }
    
    rect.origin.y = 8.0f;
    rect.origin.x = frame.size.width - self.textRightWidth - 12.0f;
    rect.size.width = 0.5f;
    rect.size.height = frame.size.height - 2*rect.origin.y;
    if ( _rightLineView == nil )
    {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.frame = rect;
        _rightLineView.backgroundColor = kHEXCOLOR(0xe5e5e5);
        _rightLineView.hidden = self.rightHide;
        [self addSubview:_rightLineView];
    }else
    {
        _rightLineView.hidden = self.rightHide;
        _rightLineView.frame = rect;
    }
    
    rect.size.height = 0.5f;
    rect.origin.y = frame.size.height - rect.size.height;
    rect.origin.x = _iputtextField.frame.origin.x;
    rect.size.width = frame.size.width - rect.origin.x - 12.0f;
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
    if ( textField == _iputtextField )
    {
        if ( range.location > self.textMaxLength )
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
        if (  _delegate && [_delegate respondsToSelector:@selector(HYTextFieldBaseView:textField:)])
        {
            [_delegate HYTextFieldBaseView:self textField:_iputtextField.text];
        }
    }
}

-(void)setNowTextName:(NSString *)text
{
    if ( _iputtextField ) {
        _iputtextField.text = text;
    }
}

@end
