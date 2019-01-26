//
//  MKItemImageObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/15.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKItemImageObject : MKBaseObject

/**@brief 商品图片uid*/
@property (nonatomic, strong) NSString *imageId;

/**@brief 商品uid*/
@property (nonatomic, strong) NSString *itemId;

/**@brief 图片类型，1代表主图，2代表商品属性图*/
@property (nonatomic, assign) NSInteger type;

/**@brief 图片名称*/
@property (nonatomic, strong) NSString *imageName;

/**@brief 图片地址*/
@property (nonatomic, strong) NSString *imageUrl;

@end
