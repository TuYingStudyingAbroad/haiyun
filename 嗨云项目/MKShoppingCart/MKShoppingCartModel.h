//
//  MKShoppingCartModel.h
//  YangDongXi
//
//  Created by cocoa on 15/4/29.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief 购物车
 @discussion 购物车可以设计得很复杂，所以想弄个这东东来管理。
             根据需求，目前这里只维护一个数量用于显示
 */
@interface MKShoppingCartModel : NSObject

/**
 @brief 购物车商品数
 */
@property (nonatomic, assign) NSInteger itemCount;

@end
