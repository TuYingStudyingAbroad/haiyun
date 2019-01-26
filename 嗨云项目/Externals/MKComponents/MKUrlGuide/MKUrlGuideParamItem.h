//
//  MKUrlGuideParamItem.h
//  YangDongXi
//
//  Created by cocoa on 15/1/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief 控制器的参数配置，跳转的url带有很多参数，有些参数需要传递给控制器。
        这个类标记了url对应控制器需要接收的参数信息
 */
@interface MKUrlGuideParamItem : NSObject

/**
 @brief url中的参数名
 */
@property (nonatomic, strong) NSString *urlParamName;

/**
 @brief 控制器的属性名
 */
@property (nonatomic, strong) NSString *classParamName;

/**
 @brief 控制器的属性默认值
 */
@property (nonatomic, strong) id defaultValue;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
