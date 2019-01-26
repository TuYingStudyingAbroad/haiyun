//
//  MKConsigneeEditViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKConsigneeObject.h"
#import "MKBaseViewController.h"
#import "MKConsigneeListViewController.h"


@protocol MKConsigneeEditViewControllerDelegate <NSObject>

@optional
- (void)didSuccessFullAddAddress:(MKConsigneeObject*)address;
- (void)didSuccessModifyAddress:(MKConsigneeObject *)address;
- (void)didSuccessDeleteAddress;
- (void)didSelectConsignee:(MKConsigneeObject*)address;
@end

@interface MKConsigneeEditViewController : MKBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *firstAddressTextField;
@property (weak, nonatomic) IBOutlet UISwitch *addr;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;

@property (strong, nonatomic) MKConsigneeObject *consigneeItem;
@property (assign, nonatomic) NSInteger addressIndex;
@property (assign, nonatomic) id<MKConsigneeEditViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isEdit;
@property (assign, nonatomic) BOOL isTax;
@property (assign, nonatomic) BOOL canSelected;

//- (void)update;

@end
