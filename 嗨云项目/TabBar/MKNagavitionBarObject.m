//
//  MKNagavitionBarObject.m
//  YangDongXi
//
//  Created by 李景 on 16/3/4.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import "MKNagavitionBarObject.h"

@implementation MKNagavitionBarObject
+ (NSDictionary *)propertyAndKeyMap {
    return @{@"tabbarName":@"text",
             @"iconSelected":@"icon_selected",
             @"iconUnselected":@"icon_unselected",
             @"link":@"link",
             @"isDefault":@"is_default"};
}
@end
