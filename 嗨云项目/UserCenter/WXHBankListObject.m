//
//  WXHBankListObject.m
//  嗨云项目
//
//  Created by kans on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "WXHBankListObject.h"

@implementation WXHBankListObject
+(NSDictionary *)propertyAndKeyMap{
    return @{
             @"bankName" : @"bank_name",
             @"bankId" : @"id",
             @"bankType" : @"bank_type",
             @"bankLastNO" : @"bank_lastno",
             @"bankOnedayQuota" : @"bank_oneday_quota",
             @"bankSingleQuota" : @"bank_single_quota",
              @"bankIsdefault" : @"bank_isdefault",
             @"bankNO":@"bank_no",
             @"bankRemark":@"bank_remark",
             @"wdConfigMaxnum":@"wd_config_maxnum",
             @"wdConfigMininum":@"wd_config_mininum",
             @"wdConfigText":@"wd_config_text",
             };
}
@end
