//
//  MKProductListViewController.h
//  YangDongXi
//
//  Created by windy on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseViewController.h"

@interface MKProductListViewController :MKBaseViewController

@property (nonatomic, assign) BOOL isConfiguration;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, assign) NSInteger brandId;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, strong) NSString *keyWord;

@property (nonatomic,strong)NSString *itemGroupUid;
@end
