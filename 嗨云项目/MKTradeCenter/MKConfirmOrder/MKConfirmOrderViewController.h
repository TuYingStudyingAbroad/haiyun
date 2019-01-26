//
//  MKConfirmOrderViewController.h
//  YangDongXi
//
//  Created by windy on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKOrderObject.h"


@interface MKConfirmOrderViewController : MKBaseViewController

@property (strong, nonatomic) NSMutableArray *confirmOrderList;

@property (nonatomic, assign) MKOrderItemSource orderItemSource;

//是否包含跨稅信息
@property (nonatomic, assign)BOOL isContains;

@end
