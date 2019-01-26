//
//  tradeTypeObject.h
//  嗨云项目
//
//  Created by 唯我独尊 on 16/5/25.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface tradeTypeObject : MKBaseObject

//名称
@property (nonatomic,strong)NSString * textName;
//获取时间
@property (nonatomic,strong)NSString * timeName;
//状态
@property (nonatomic,assign)NSInteger status;
//嗨币数量
@property (nonatomic,assign)NSInteger amount;
//订单编号
@property (nonatomic,strong)NSString * orderSn;
//订单uid
@property (nonatomic,strong)NSString * orderUid;
//提现编号
@property (nonatomic,strong)NSString * withdrawalsNumber;


@end
