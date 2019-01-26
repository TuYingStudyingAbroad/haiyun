//
//  MKInvoiceInfo.m
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKInvoiceInfo.h"

@implementation MKInvoiceInfo

+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"invoiceType" : @"invoice_type",
             @"invoiceTitle" : @"invoice_title"};
}

@end
