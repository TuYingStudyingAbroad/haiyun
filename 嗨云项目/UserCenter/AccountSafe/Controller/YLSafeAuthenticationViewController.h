//
//  YLSafeAuthenticationViewController.h
//  嗨云项目
//
//  Created by YanLu on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

/**
 *  身份验证
 */
#import "HYBaseViewController.h"

@interface YLSafeAuthenticationViewController : HYBaseViewController

@property (nonatomic,copy) NSString *nsPassword;
/**
 *  0, 1,2
 */
@property (nonatomic,assign) NSInteger typeCard;
@end
