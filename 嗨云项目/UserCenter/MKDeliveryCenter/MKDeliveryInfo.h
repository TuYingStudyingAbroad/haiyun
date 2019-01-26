//
//  MKDeliveryInfo.h
//  YangDongXi
//
//  Created by cocoa on 15/4/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKDeliveryInfo : MKBaseObject

/**@brief 配送类型：自提/快递*/
@property (nonatomic, assign) NSInteger deliveryType;

/**@brief 配送公司*/
@property (nonatomic, strong) NSString *deliveryCompany;

/**@brief 配送费用*/
@property (nonatomic, assign) NSInteger deliveryFee;

/**@brief 运单号*/
@property (nonatomic, copy) NSString *deliveryCode;

/**@brief 物流详情*/
@property (nonatomic, strong) NSArray *deliveryDetailList;

/**@brief 配送物流信息查询网址*/
@property (nonatomic, copy) NSString *expressUrl;


@end
