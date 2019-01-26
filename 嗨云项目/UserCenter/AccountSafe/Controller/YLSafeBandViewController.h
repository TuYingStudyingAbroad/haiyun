//
//  YLSafeBandViewController.h
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseViewController.h"

@interface YLSafeBandViewController : HYBaseViewController

@property (nonatomic, copy) NSString *nsPhoneNum;
@property (nonatomic,assign) BOOL nsIsCard;

/**
 *  0从来木有绑定过，1旧的手机号码验证，2新的绑定
 */
@property (nonatomic,assign) NSInteger  nsPhoneType;

@end
