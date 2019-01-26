//
//  HYPlaceTheOrderController.h
//  嗨云项目
//
//  Created by haiyun on 16/9/22.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseViewController.h"
#import "MKConsigneeObject.h"
#import "MKCouponObject.h"
#import "MKOrderObject.h"
#import "MKConfirmOrderViewController.h"

@interface HYPlaceTheOrderController : HYBaseViewController

@property (strong, nonatomic) MKConsigneeObject *consigneeItem;

@property (nonatomic, assign) MKOrderItemSource orderItemSource;

@property (nonatomic,strong)NSArray *wealthArray;

@property (nonatomic,strong)MKCouponObject *couponObject;

@property (nonatomic,strong)NSString *orderUid;

@property (nonatomic,strong)NSString *totalPrice;

@property (nonatomic,strong)MKConfirmOrderViewController *confirm;

@property (nonatomic,assign)NSInteger time;

@property (nonatomic,strong)MKOrderObject *orderObject;

@property (nonatomic,strong)NSString *orderSn;

//@property (nonatomic,assign)id <MKPlaceTheOrderDelegate> delegate;

@property (nonatomic,assign)BOOL isHidenTime;

@end
