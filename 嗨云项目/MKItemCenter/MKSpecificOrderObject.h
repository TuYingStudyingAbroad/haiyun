//
//  MKSpecificOrderObject.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/27.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface MKSpecificOrderObject : MKBaseObject

/**@brief 商品sku uid*/
@property (nonatomic, strong) NSString *skuUid;

/**@brief 购买数量*/
@property (nonatomic, assign) NSInteger number;

/**@brief 经销商ID*/
@property (nonatomic, strong) NSString *distributorId;

/**@brief 商品的itemtype*/
@property (nonatomic, assign) NSInteger itemType;

/**@brief 商品分享者ID*/
@property (nonatomic, strong) NSString *shareUserId;
@end
