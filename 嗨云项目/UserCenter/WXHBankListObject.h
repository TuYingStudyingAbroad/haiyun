//
//  WXHBankListObject.h
//  嗨云项目
//
//  Created by kans on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"
//银行卡列表的模型
@interface WXHBankListObject : MKBaseObject
//银行卡的名字
@property(nonatomic,strong)NSString * bankName;
//银行卡的id
@property(nonatomic,strong)NSString * bankId;
//银行卡的类型(现在默认储蓄卡)
@property(nonatomic,strong)NSString * bankType;
//银行卡的尾号
@property(nonatomic,copy)NSString*  bankLastNO;
//银行卡的单日限额
@property(nonatomic,strong)NSString * bankOnedayQuota;
//单次限额
@property(nonatomic,strong)NSString * bankSingleQuota;
//是否默认(1、默认0、不默认)
@property (nonatomic,strong)NSString* bankIsdefault;
//银行卡号码
@property (nonatomic,strong)NSString * bankNO;
//银行卡备注
@property(nonatomic,strong)NSString * bankRemark;


//临时的参数////////////////////////////////////
//最大提现金额
@property(nonatomic,copy)NSString* wdConfigMaxnum;
//最小提现金额
@property(nonatomic,assign)float wdConfigMininum;
//提示显示一段时间能提现多少钱
@property (nonatomic,copy)NSString * wdConfigText;

@end
