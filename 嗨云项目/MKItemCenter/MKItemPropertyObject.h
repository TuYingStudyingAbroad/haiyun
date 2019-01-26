//
//  MKItemPropertyObject.h
//  YangDongXi
//
//  Created by cocoa on 15/6/1.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKItemPropertyObject : MKBaseObject

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *value;

@property (nonatomic, assign) NSInteger valueType;

@property (nonatomic, assign) NSInteger sort;

@end
