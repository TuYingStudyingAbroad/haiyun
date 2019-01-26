//
//  MKPlaceTheOrderController.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKConsigneeObject.h"
#import "MKCouponObject.h"
#import "MKOrderObject.h"
#import "MKConfirmOrderViewController.h"


@protocol MKPlaceTheOrderDelegate <NSObject>

- (void)MKPlaceTheOrderResults:(MKPayResult )payResult withOrderUid:(NSString *)orderUid;

@end

@interface MKPlaceTheOrderController : UITableViewController


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

@property (nonatomic,assign)id <MKPlaceTheOrderDelegate> delegate;

@property (nonatomic,assign)BOOL isHidenTime;
@end
