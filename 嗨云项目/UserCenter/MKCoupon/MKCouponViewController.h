//
//  MKCouponViewController.h
//  YangDongXi
//
//  Created by windy on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKCouponObject.h"

@protocol MKCouponViewControllerDelegate <NSObject>

- (void)didSelectCouponObject:(MKCouponObject*)couponItem;

@end

@interface MKCouponViewController : MKBaseViewController

@property (strong, nonatomic) NSMutableArray *currentArray;

@property (nonatomic,strong)NSString *orderList;

@property (assign, nonatomic) BOOL isSelected;

@property (nonatomic,strong)MKCouponObject *coupon;

@property (weak, nonatomic) id<MKCouponViewControllerDelegate> delegate;


@end
