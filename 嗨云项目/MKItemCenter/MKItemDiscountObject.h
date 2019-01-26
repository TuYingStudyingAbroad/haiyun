//
//  MKItemDiscountObject.h
//  嗨云项目
//
//  Created by 李景 on 16/7/20.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"
#import "MKMarketActivityObject.h"
#import "MKItemObject.h"
@interface MKItemDiscountObject : MKBaseObject

@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong)NSString *consume;
@property (nonatomic,strong)NSString *discountAmount;
@property (nonatomic,strong)NSString *freePostage;
@property (nonatomic,strong)NSMutableArray *giftList;
@property (nonatomic,strong)MKMarketActivityObject *marketActivity;
@property (nonatomic,strong)NSArray *itemList;
@property (nonatomic,strong)NSArray *availableCouponList;
@property (nonatomic,strong)NSString *savedPostage;
@property (nonatomic, assign)NSInteger isAvailable;
@property (nonatomic, strong)NSMutableArray *giftAry;

@property (nonatomic, strong)NSMutableArray *activityItemList;
@property (nonatomic, strong) NSMutableArray *couponList;

@property (nonatomic,assign)BOOL selected;
@property (nonatomic,assign)BOOL isOpen;

@property (nonatomic,strong)NSMutableArray * actNameAry;
@property (nonatomic,strong)NSMutableArray * manjianNameAry;

@end
