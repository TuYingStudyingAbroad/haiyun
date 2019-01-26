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
//分享ID可以带，也可以不带
@property (nonatomic,strong) NSString *shareUserId;

//标记秒杀团购等等
@property (nonatomic,assign) NSInteger itemType;

//type为1时，使用传入的distributorId；type为0时，使用本地存储的distributorId；
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) BOOL isConfiguration;


@end
