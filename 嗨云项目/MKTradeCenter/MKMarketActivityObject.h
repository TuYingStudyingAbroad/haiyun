//
//  MKMarketActivityObject.h
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"
#import "MKPropertyObject.h"


@interface MKMarketActivityObject : MKBaseObject

@property (nonatomic, strong) NSString *activityUid;

@property (nonatomic, assign) NSInteger scope;

@property (nonatomic, strong) NSString *activityName;

@property (nonatomic, assign) NSInteger couponMark;

@property (nonatomic, assign) NSInteger discountAmount;

@property (nonatomic, strong) NSString *toolCode;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, strong) NSArray *properties;

@property (nonatomic, strong) NSArray *itemList;

@property (nonatomic, strong) NSArray *targetItemList;

//发布状态
@property (nonatomic, copy) NSString *activityTag;
//标签状态
@property (nonatomic, copy) NSString *limitTagStatus;
//标签时间
@property (nonatomic, copy) NSString *limitTagDate;


@property (nonatomic, copy) NSString *icon;

@end
