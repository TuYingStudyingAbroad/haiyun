//
//  MKOrdersViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "THSegmentedPager.h"
#import "MKOrderObject.h"
#import "UIViewController+MKExtension.h"

@interface MKOrdersViewController : THSegmentedPager

@property (nonatomic, assign) MKOrderStatus orderStatus;

-(void)changePageColtrol:(MKOrderStatus )orderStatus;
@end
