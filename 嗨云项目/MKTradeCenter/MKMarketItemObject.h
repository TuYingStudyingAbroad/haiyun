//
//  MKMarketItemObject.h
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKMarketItemObject : MKBaseObject

@property (nonatomic, strong) NSString *itemSkuUid;

@property (nonatomic, strong) NSString *itemUid;

@property (nonatomic, assign) NSInteger sellerId;

@property (nonatomic, assign) NSInteger unitPrice;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic,assign) NSInteger brandId;

@end
