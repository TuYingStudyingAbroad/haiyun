//
//  MKDeliveryDetailItem.h
//  YangDongXi
//
//  Created by windy on 15/5/5.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKDeliveryDetailItem : MKBaseObject

/**@brief 物流详情信息uid*/
@property (nonatomic, strong) NSString *deliveryDetailUid;

/**@brief 操作时间*/
@property (nonatomic, strong) NSString *opTime;

/**@brief 操作内容*/
@property (nonatomic, strong) NSString *content;


@end
