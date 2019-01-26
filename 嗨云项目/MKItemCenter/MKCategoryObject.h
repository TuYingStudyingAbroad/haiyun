//
//  MKCategoryObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKCategoryObject : MKBaseObject

/**@brief 类目id*/
@property (nonatomic, assign) NSInteger categoryId;

/**@brief 类目名称*/
@property (nonatomic, strong) NSString *name;

/**@brief 类目级别*/
@property (nonatomic, assign) NSInteger level;

/**@brief 父类目id*/
@property (nonatomic, assign) NSInteger pId;

/**@brief 一级类目id*/
@property (nonatomic, assign) NSInteger topId;

/**@brief 排序字段*/
@property (nonatomic, assign) NSInteger sort;


@end
