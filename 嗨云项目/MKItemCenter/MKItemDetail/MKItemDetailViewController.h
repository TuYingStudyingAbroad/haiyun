//
//  MKItemDetailViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseViewController.h"
#import "UIViewController+MKExtension.h"

@interface MKItemDetailViewController : MKBaseViewController

@property (nonatomic,strong) NSString *itemId;
@property (nonatomic,strong) NSString *distributorId;

//type为0时，使用传入的distributorId；type为1时，使用本地存储的distributorId；
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) BOOL isConfiguration;

@end
