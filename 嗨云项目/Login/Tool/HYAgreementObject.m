//
//  HYAgreementObject.m
//  嗨云项目
//
//  Created by haiyun on 2016/10/25.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "HYAgreementObject.h"

@implementation HYAgreementObject

+(NSDictionary *)propertyAndKeyMap{
    
    return @{@"Id":@"id",
             @"type":@"type",
             @"proName":@"pro_name",
             @"proContent":@"pro_content",
             @"proModel":@"pro_model",
             };
    
}

@end
