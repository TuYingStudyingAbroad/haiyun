//
//  MKDistributorOrderItemList.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/18.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"
#import "MKOrderItemObject.h"

@interface MKDistributorOrderItemList : MKBaseObject


@property (nonatomic,strong)NSString *distributorName;

@property (nonatomic,strong)NSString *distributorId;

@property (nonatomic,strong)NSMutableArray *orderItemList;

@end
