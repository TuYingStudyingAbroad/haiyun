//
//  MKhigoExtraInfo.h
//  YangDongXi
//
//  Created by 杨鑫 on 16/1/20.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKhigoExtraInfo : MKBaseObject

//税费
@property (nonatomic,assign)CGFloat taxRate;

//原税费
@property (nonatomic,strong)NSString *originalTaxFee;

//最终税费
@property (nonatomic,strong)NSString *finalTaxFee;

//货源地
@property (nonatomic,strong)NSString *supplyBase;

@property (nonatomic, strong) NSString *supplyBaseIcon;
//计税方式，0包税 1固定税率 2税率模板
@property (nonatomic, assign) NSInteger taxType;
//发货方式，1代表一般进口，2代表保税区发货，3代表海外直邮
@property (nonatomic,strong)NSString *deliveryType;

@end
