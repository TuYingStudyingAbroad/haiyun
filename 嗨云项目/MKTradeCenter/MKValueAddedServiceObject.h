//
//  MKValueAddedServiceObject.h
//  YangDongXi
//
//  Created by 朱艳娇 on 15/12/22.
//  Copyright © 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKValueAddedServiceObject : MKBaseObject

@property (nonatomic,strong) NSString * serviceUid;
//服务名
@property (nonatomic,strong) NSString * serviceName;
//服务描述
@property (nonatomic,strong) NSString * serviceDesc;
//服务图标
@property (nonatomic,strong) NSString * iconUrl;
//服务价格，单位分
@property (nonatomic,strong) NSString * servicePrice;

@property (nonatomic,assign) BOOL isChoose;


@end
