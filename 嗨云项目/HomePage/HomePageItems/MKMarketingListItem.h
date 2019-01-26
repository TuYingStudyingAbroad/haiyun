//
//  MKMarketingListItem.h
//  YangDongXi
//
//  Created by cocoa on 15/5/7.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"
#import "MKMarketingObject.h"

@interface MKMarketingListItem : MKMarketingObject

@property (nonatomic, assign) NSInteger wirelessPrice;

@property (nonatomic, assign) NSInteger marketPrice;

@property (strong,nonatomic) NSString *supplyPlace;

@end
