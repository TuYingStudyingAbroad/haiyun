//
//  HSafterSalesController.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/6/3.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKOrderItemObject.h"
#import "MKOrderObject.h"

@interface HSafterSalesController : MKBaseViewController


@property (nonatomic, strong) MKOrderObject *order;

@property (nonatomic, strong) NSString *orderUid;

@property (nonatomic, strong)MKOrderItemObject *itemObject;

@property (nonatomic, strong)NSString *tString;


@end
