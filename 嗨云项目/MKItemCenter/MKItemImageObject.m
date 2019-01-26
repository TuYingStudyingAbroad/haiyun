//
//  MKItemImageObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKItemImageObject.h"

@implementation MKItemImageObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"imageId" : @"item_image_uid",
             @"itemId" : @"item_uid",
             @"type" : @"image_type",
             @"imageName" : @"image_name",
             @"imageUrl" : @"image_url"};
}

@end
