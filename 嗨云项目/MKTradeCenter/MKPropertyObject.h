//
//  MKPropertyObject.h
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"


@interface MKPropertyObject : MKBaseObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *value;

@property (nonatomic, assign) NSInteger valueType;

@end
