//
//  MKHistoryItemObject.h
//  YangDongXi
//
//  Created by cocoa on 15/5/11.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"
#import "MKBaseItemObject.h"

@interface MKHistoryItemObject : MKBaseItemObject

@property (nonatomic, assign) NSUInteger historyUpdateTime;

@property (nonatomic,strong) NSString *distributorId;

@end
