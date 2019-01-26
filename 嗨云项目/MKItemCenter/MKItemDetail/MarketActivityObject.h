//
//  MarketActivityObject.h
//  嗨云项目
//
//  Created by haiyun on 2016/11/4.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "MKBaseObject.h"

@interface MarketActivityObject : MKBaseObject

//发布状态
@property (nonatomic, copy) NSString *activityTag;
//标签状态
@property (nonatomic, copy) NSString *limitTagStatus;
//标签时间
@property (nonatomic, copy) NSString *limitTagDate;

@property (nonatomic, copy) NSString *couponMark;

@property (nonatomic, copy) NSString *toolCode;

@property (nonatomic, copy) NSString *icon;

@end
