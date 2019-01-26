//
//  MKDistributorCartObject.h
//  嗨云项目
//
//  Created by 李景 on 16/5/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"
#import "MKCartItemObject.h"

@interface MKDistributorCartObject : MKBaseObject

/**@brief 分销商uid*/
@property (nonatomic, strong) NSString *distributorId;

/**@brief 分销商名字*/
@property (nonatomic, strong) NSString *distributorShopName;

/**@brief 分销商旗下的商品列表*/
@property (nonatomic, strong) NSArray *itemList;
//转成model
@property (nonatomic, strong) NSMutableArray *itemModelList;

/**@brief 购买数量*/
@property (nonatomic, assign) NSInteger number;

//判断点选状态
@property (nonatomic, assign) BOOL isChecked;

@end
