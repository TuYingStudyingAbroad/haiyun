//
//  HYSafeBandInfo.m
//  嗨云项目
//
//  Created by haiyun on 16/9/6.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYSafeBandInfo.h"

@implementation HYSafeBandInfo

+ (NSDictionary *)propertyAndKeyMap{
    return @{
             @"bankRealname" : @"authon_realname",
             @"bankPersonalId" : @"authon_personalid",
             @"pictureFront" : @"picture_front",
             @"pictureBack" : @"picture_back",
             @"authonStatus" : @"authon_status"
             };
}

@end
