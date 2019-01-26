//
//  HYLoginTextFieldView.h
//  嗨云项目
//
//  Created by YanLu on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYLoginTextFieldView;
@protocol HYLoginTextFieldViewDelegate <NSObject>

@optional
-(void)HYLoginTextFieldView:(HYLoginTextFieldView *)textView textField:(NSString *)textFieldName;
@end

@interface HYLoginTextFieldView : UIView

@property (nonatomic,copy) NSString *iconImageName;
@property (nonatomic,copy) NSString *textName;
@property (nonatomic,copy) NSString *textPlaceName;//提示内容
@property (nonatomic) UIKeyboardType keyboardType;//键盘
@property (nonatomic) BOOL textIsEnabled;//是否可以编辑
@property (nonatomic) NSInteger textMaxLength;
@property (nonatomic) NSInteger textMinLength;
@property (nonatomic) BOOL secureTextEntry;
@property (nonatomic) CGFloat textRightWidth;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic) BOOL bottomHide;

@property (nonatomic,weak) __weak id <HYLoginTextFieldViewDelegate>  delegate;

@end

