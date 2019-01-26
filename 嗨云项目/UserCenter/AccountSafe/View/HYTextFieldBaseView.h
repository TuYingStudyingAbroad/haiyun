//
//  HYTextFieldBaseView.h
//  嗨云项目
//
//  Created by YanLu on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTextFieldBaseView;
@protocol HYTextFieldBaseViewDelegate <NSObject>

@optional
-(void)HYTextFieldBaseView:(HYTextFieldBaseView *)textView textField:(NSString *)textFieldName;
@end

@interface HYTextFieldBaseView : UIView

@property (nonatomic,copy) NSString *iconImageName;
@property (nonatomic,copy) NSString *textName;
@property (nonatomic,copy) NSString *textPlaceName;//提示内容
@property (nonatomic) UIKeyboardType keyboardType;//键盘
@property (nonatomic) BOOL textIsEnabled;//是否可以编辑
@property (nonatomic) NSInteger textMaxLength;
@property (nonatomic) NSInteger textMinLength;
@property (nonatomic) BOOL secureTextEntry;
@property (nonatomic) CGFloat textRightWidth;
@property (nonatomic) BOOL rightHide;
@property (nonatomic) BOOL bottomHide;
@property (nonatomic,weak) __weak id <HYTextFieldBaseViewDelegate>  delegate;
-(void)setNowTextName:(NSString *)text;

@end
