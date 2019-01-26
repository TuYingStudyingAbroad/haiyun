//
//  YLSafePayPasswordController.h
//  嗨云项目
//
//  Created by YanLu on 16/5/14.
//  Copyright © 2016年 杨鑫. All rights reserved.
//


typedef enum {
    SafePayPasswordStateFirstSet,//第一次设置
    SafePayPasswordStateFirstNext,//再次确认密码
    SafePayPasswordStateOld,//输入旧密码
    SafePayPasswordStateNew,//设置新密码
    SafePayPasswordStateNewNext,//再次确认
    SafePayPasswordStateForgetNew,//忘记设置新密码
    SafePayPasswordStateForgetNewNext,//忘记再次确认
}SafePayPasswordState;

#import "HYBaseViewController.h"

@interface YLSafePayPasswordController : HYBaseViewController

@property (nonatomic,copy) NSString *nsPassword;
@property (nonatomic,copy) NSString *oldPassword;
@property (nonatomic) SafePayPasswordState payState;

@end
