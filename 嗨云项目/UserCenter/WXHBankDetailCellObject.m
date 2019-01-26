//
//  WXHBankDetailCellObject.m
//  嗨云项目
//
//  Created by 小辉 on 16/5/26.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "WXHBankDetailCellObject.h"
#import "WXHBankStatusListObject.h"
@implementation WXHBankDetailCellObject
+ (NSDictionary *)propertyAndKeyMap{
    return @{@"amount":@"amount",
             @"bankName":@"bank_name",
             @"bankOn":@"bank_no",
             @"number":@"number",
             @"statusList":@"status_list",
             @"refusalReason":@"refusal_reason"
             
             };
    
}


+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index{
    if ([propertyName isEqualToString:@"statusList"]) {
        return [WXHBankStatusListObject class];
    }
    return nil;
}

@end
