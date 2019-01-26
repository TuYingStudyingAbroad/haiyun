//
//  RefundObject.h
//  YangDongXi
//
//  Created by 杨鑫 on 15/10/16.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKOrderObject.h"
#import "MKOrderItemObject.h"

@interface RefundObject : UIView
@property (nonatomic,strong)UIView *pickView;
@property (nonatomic, strong) MKOrderObject *order;

@property (nonatomic, strong) NSString *orderUid;

@property (nonatomic, strong)MKOrderItemObject *item;
//说明
@property (nonatomic,strong)NSString *refund_desc;
//理由
@property (nonatomic,assign)NSString *refund_reason_id;
//钱
@property (nonatomic,strong)NSString *refund_amount;
//图片
@property (nonatomic,strong)NSMutableArray *imageData;
@property (nonatomic,strong)UIView *view;
@property (nonatomic,copy)void (^tmpe)();
- (void)uploadData;
@end
