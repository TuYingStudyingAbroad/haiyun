//
//  MKBizPropertyObject.h
//  YangDongXi
//
//  Created by windy on 15/6/3.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKBizPropertyObject : MKBaseObject

/**@brief 属性标志码，用于唯一标志该属性*/
@property (nonatomic, strong) NSString *code;

/**@brief 属姓名*/
@property (nonatomic, strong) NSString *name;

/**@brief 属性值*/
@property (nonatomic, strong) NSString *value;

/**@brief 属性值类型*/
@property (nonatomic, assign) NSInteger valueType;

/**@brief 排序字段*/
@property (nonatomic, assign) NSInteger sort;
@end
