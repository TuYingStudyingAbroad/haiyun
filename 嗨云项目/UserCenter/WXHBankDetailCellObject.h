//
//  WXHBankDetailCellObject.h
//  嗨云项目
//
//  Created by 小辉 on 16/5/26.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface WXHBankDetailCellObject : MKBaseObject
//提现金额
@property(nonatomic,assign)NSInteger amount;
//银行卡名
@property(nonatomic,copy)NSString * bankName;
//银行卡号
@property(nonatomic,strong)NSString* bankOn;
//提现编号
@property (nonatomic,copy)NSString * number;
//拒绝理由
@property(nonatomic,copy)NSString * refusalReason;

@property (nonatomic,strong)NSArray *statusList;
//提现的类型（银行 微信 支付宝）照顾老数据
@property(nonatomic,assign)NSInteger type;

@end
