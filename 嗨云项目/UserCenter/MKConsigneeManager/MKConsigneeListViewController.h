//
//  MKConsigneeListViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKConsigneeObject.h"

@protocol MKConsigneeListViewControllerDelegate <NSObject>

- (void)didSelectConsignee:(MKConsigneeObject*)address;

@end

@interface MKConsigneeListViewController : MKBaseViewController

@property (weak, nonatomic) id<MKConsigneeListViewControllerDelegate>delegate;
@property (assign, nonatomic) BOOL canSelected;
@property (assign, nonatomic) BOOL isTax;
@property (strong, nonatomic) MKConsigneeObject *seletedConsignee;

@end
