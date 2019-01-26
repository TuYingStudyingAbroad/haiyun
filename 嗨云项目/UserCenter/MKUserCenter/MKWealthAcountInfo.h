//
//  MKWealthAcountInfo.h
//  YangDongXi
//
//  Created by cocoa on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKWealthAcountInfo : MKBaseObject

@property (nonatomic, strong) NSString *accountUid;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, strong) NSString *exchangeRate;

@end
