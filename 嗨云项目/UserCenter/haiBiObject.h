//
//  haiBiObject.h
//  嗨云项目
//
//  Created by kans on 16/5/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface haiBiObject : MKBaseObject

//用户帐号 uid
@property (nonatomic,assign)NSInteger  wealthAccountUid;
//财富类型
@property (nonatomic,assign)NSInteger wealthType;
//累计收益
@property (nonatomic,assign)NSInteger totalAmount;
//可用财富总量
@property (nonatomic,assign)long amount;
//冻结中／待确认的虚拟财富
@property (nonatomic,assign)long transitionAmount;
//即将过期的虚拟财富
@property (nonatomic,assign)long willExpireAmount;
//积分兑换率 ，单位 : 分／积分
@property (nonatomic,assign)NSInteger exchangeRate;
//兑换的百分比
@property (nonatomic,assign)NSInteger upperLimit;

@end
