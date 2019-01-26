//
//  YLSafeLoginPasswordView.h
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseView.h"

@interface YLSafeLoginPasswordView : HYBaseView

@property (nonatomic,copy) NSString *nsPhoneNum;

/**
 *  YES修改密码 NO 设置密码
 */
@property (nonatomic, assign) BOOL nsIsChange;


-(void)onButtonClickRight;

@end
