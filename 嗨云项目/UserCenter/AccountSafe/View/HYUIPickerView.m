//
//  HYUIPickerView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYUIPickerView.h"

@interface HYUIPickerView()
{
    UIPickerView    * _Picker;
    UIButton        * _OKBtn;
    UIButton        * _cancelBtn;
    UIView          * _bgView;
}
@end


@implementation HYUIPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    self.backgroundColor = [UIColor clearColor];
    
    CGRect rect = CGRectMake(0 , frame.size.height - 200, frame.size.width , 44.0f);
    if (_bgView == nil)
    {
        _bgView = NewObject(UIView);
        _bgView.backgroundColor = kHEXCOLOR(0xf8f8f8);
        _bgView.frame = rect;
        [self addSubview:_bgView];
    }else
    {
        _bgView.frame = rect;
    }
    
    rect = CGRectMake(10, rect.origin.y + 10, 60, 30);
    if (_cancelBtn == nil)
    {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
        _cancelBtn.frame = rect;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor clearColor]];
        [_cancelBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
    }else
    {
        _cancelBtn.frame = rect;
    }
    
    rect.origin.x = frame.size.width - rect.size.width - 10;
    if (_OKBtn == nil)
    {
        _OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_OKBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
        _OKBtn.frame = rect;
        _OKBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_OKBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_OKBtn setBackgroundColor:[UIColor clearColor]];
        [_OKBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_OKBtn];
    }else
    {
        _OKBtn.frame = rect;
    }
    
    rect = CGRectMake(0, _bgView.frame.origin.y + 40.0f, frame.size.width, 200 - 44.0f);
    
    if (_Picker == nil)
    {
        _Picker = [[UIPickerView alloc] init];
        _Picker.backgroundColor = [UIColor whiteColor];
        _Picker.dataSource = self;
        _Picker.delegate = self;
        _Picker.showsSelectionIndicator = YES;
        _Picker.frame = rect;
        [self addSubview:_Picker];
    }else
    {
        _Picker.frame = rect;
    }
}

-(void)selectDatePickerChange:(id)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectDatePickerChange:)])
    {
        [self.delegate selectDatePickerChange:sender];
    }
}
-(void)onButton:(id)sender
{
    if (_OKBtn == sender)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(OnSelectOKPickerview)])
        {
            [self.delegate OnSelectOKPickerview];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onColosePickerView)])
    {
        return [self.delegate onColosePickerView];
    }
}
- (void)reloadComponent:(NSInteger)component
{
    if (_Picker)
    {
        [_Picker reloadComponent:component];
    }
}
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    if (_Picker)
    {
        [_Picker selectRow:row inComponent:component animated:animated];
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)])
    {
        return [self.delegate pickerView:pickerView numberOfRowsInComponent:component];
    }
    return 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfComponentsInPickerView:)])
    {
        return [self.delegate numberOfComponentsInPickerView:pickerView];
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)])
    {
        return [self.delegate pickerView:pickerView titleForRow:row forComponent:component];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
    {
        [self.delegate pickerView:pickerView didSelectRow:row inComponent:component];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (point.y < self.frame.size.height - 185)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(HiddenPicker:)])
        {
            [self.delegate HiddenPicker:self.delegate];
        }
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
        return [self.delegate pickerView:pickerView viewForRow:row forComponent:component reusingView:view];
    }
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
@end
