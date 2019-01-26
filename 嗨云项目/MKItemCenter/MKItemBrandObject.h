//
//  MKItemBrandObject.h
//  YangDongXi
//
//  Created by cocoa on 15/6/2.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKItemBrandObject : MKBaseObject

//品牌id
@property (nonatomic, assign) NSInteger brandId;

//品牌名称
@property (nonatomic, strong) NSString *name;

//品牌图标
@property (nonatomic, strong) NSString *logoUrl;

//品牌描述
@property (nonatomic, copy) NSString  *brandDesc;

//品牌banner
@property (nonatomic, copy) NSString    *bannerImg;
@end
