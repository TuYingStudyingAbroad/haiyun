//
//  HYUIPickerView.h
//  嗨云项目
//
//  Created by YanLu on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  HYUIPickerViewDelegate <NSObject>
@optional
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)onColosePickerView;
- (void)OnSelectOKPickerview;
-(void)HiddenPicker:(id)sender;
- (void)selectDatePickerChange:(id)sender;
@end

@interface HYUIPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,weak) id<HYUIPickerViewDelegate>  delegate;
- (void)reloadComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
@end

