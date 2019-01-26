//
//  YLOrderDetailViewController.h
//  嗨云项目
//
//  Created by YanLu on 16/5/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseViewController.h"
#import "MKOrderObject.h"


@interface YLOrderDetailViewController : HYBaseViewController

@property (nonatomic, strong) MKOrderObject *order;

@property (nonatomic, strong) NSString *orderUid;

@end
