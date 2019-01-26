//
//  HYRegAddress.h
//  嗨云项目
//
//  Created by haiyun on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYRegAddress : NSObject

+(void)checkAddressBookAuthorization:(void (^)(bool isAuthorized))block;


@end

