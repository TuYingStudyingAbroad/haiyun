//
//  HYShopReShareViewController.h
//  嗨云项目
//
//  Created by haiyun on 16/8/24.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYShopReShareViewController : HYBaseViewController

/**
 *  0分享店铺，1分享注册
 */
@property (nonatomic, assign) NSInteger shopShareType;

@property (nonatomic, copy) NSString *QRCodeStr;

@end
