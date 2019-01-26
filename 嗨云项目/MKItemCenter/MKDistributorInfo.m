//
//  MKDistributorInfo.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKDistributorInfo.h"
#import "MKOrderItemObject.h"

@implementation MKDistributorInfo


+ (NSDictionary *)propertyAndKeyMap{
    return @{
             @"distributorId":@"distributor_id",
             @"shopName":@"shop_name",
             @"distributorSign":@"distributor_sign",
             @"headImgUrl":@"head_img_url"
             };
}


@end
