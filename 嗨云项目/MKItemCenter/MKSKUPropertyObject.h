//
//  MKSKUPropertyObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKSKUPropertyObject : MKBaseObject

/**@brief 属性id*/
@property (nonatomic, strong) NSString *propertyId;

/**@brief 所属sku id*/
@property (nonatomic, strong) NSString *skuId;

/**@brief 属姓名*/
@property (nonatomic, strong) NSString *name;

/**@brief 属性值*/
@property (nonatomic, strong) NSString *value;

/**@brief 属性值类型*/
@property (nonatomic, assign) NSInteger valueType;

/**@brief 排序字段*/
@property (nonatomic, assign) NSInteger sort;

@end
