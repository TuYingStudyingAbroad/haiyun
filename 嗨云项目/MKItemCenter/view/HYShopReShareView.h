//
//  HYShopReShareView.h
//  嗨云项目
//
//  Created by haiyun on 16/8/24.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseView.h"

@interface HYShopReShareView : HYBaseView

/**
 *  0分享店铺，1分享注册
 */
@property (nonatomic, assign) NSInteger shopShareType;

@property (nonatomic, copy) NSString *QRCodeStr;
@end
