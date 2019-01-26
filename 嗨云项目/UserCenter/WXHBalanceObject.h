//
//  WXHBalanceObject.h
//  嗨云项目
//
//  Created by kans on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//


//查看明细的数据模型
#import "MKBaseObject.h"

@interface WXHBalanceObject : MKBaseObject
//名称
@property (nonatomic,strong)NSString * text;
//时间
@property (nonatomic,strong)NSString * time;
//数量
@property(nonatomic,assign)NSInteger  amount;
//状态状态 0:过渡态(冻结／提现中) 1:到账 2:失效态(提现失败／已取消) 3:过期
@property (nonatomic,assign)NSInteger status;
//订单编号
@property (nonatomic,strong)NSString * orderSn;
//订单id
@property (nonatomic,strong)NSString * orderUid;
//提现编号
@property(nonatomic,copy)NSString * withdrawalsNumber;
//拒绝理由
@property(nonatomic,copy)NSString *refusalReason;

@end
