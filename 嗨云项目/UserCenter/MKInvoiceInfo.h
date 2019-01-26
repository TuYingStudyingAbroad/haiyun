//
//  MKInvoiceInfo.h
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKInvoiceInfo : MKBaseObject

/**@brief 发票类型，0:个人，1:公司*/
@property (nonatomic, assign) NSInteger invoiceType;

/**@brief 发票抬头*/
@property (nonatomic, strong) NSString *invoiceTitle;

@end
