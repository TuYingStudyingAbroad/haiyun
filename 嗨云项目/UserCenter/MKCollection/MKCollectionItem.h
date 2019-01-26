//
//  MKCollectionItem.h
//  YangDongXi
//
//  Created by cocoa on 15/4/23.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKItemObject.h"

extern NSString *const MKCollectionItemStatusChangedNotification;

@interface MKCollectionItem : MKItemObject

@property (nonatomic, assign) BOOL isChecked;

@end
