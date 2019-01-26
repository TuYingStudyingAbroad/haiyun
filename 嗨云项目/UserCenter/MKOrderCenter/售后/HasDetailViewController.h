//
//  HasDetailViewController.h
//  YangDongXi
//
//  Created by 杨鑫 on 15/10/16.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKOrderObject.h"
#import "MKOrderItemObject.h"

@interface HasDetailViewController : MKBaseViewController
@property (nonatomic, strong) MKOrderObject *order;

@property (nonatomic, strong) NSString *orderUid;

@property (nonatomic, strong)MKOrderItemObject *itemObject;

@property (nonatomic, strong)NSString *tString;

@property (nonatomic, assign)BOOL isReturn;
@property (nonatomic,assign)void (^temp)();
@end
