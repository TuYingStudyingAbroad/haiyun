//
//  MKPaymentSuccessViewController.h
//  YangDongXi
//
//  Created by windy on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKConfirmOrderViewController.h"
#import "MKConsigneeObject.h"
#import "MKOrderObject.h"


@interface MKPaymentSuccessViewController : UITableViewController

@property (nonatomic, strong) NSString *orderUid;

@property (nonatomic, assign) NSInteger payAmount;

@property (strong, nonatomic) MKConsigneeObject *consigneeItem;

@property (nonatomic, assign) MKOrderItemSource orderItemSource;

@property (nonatomic,assign) NSInteger payType;

@property (nonatomic,strong) NSString *orderSn;

@property (nonatomic,strong) NSArray *wealthArray;

@property (nonatomic,strong) MKCouponObject *couponObject;

@property (nonatomic,strong) NSString *totalPrice;

@property (nonatomic, copy) void (^goToOrderDetailAction)(void);


@end
