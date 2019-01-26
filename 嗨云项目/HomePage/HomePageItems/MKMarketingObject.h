//
//  MKMarketingObject.h
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"
#import "MKMarketingMarqueeItem.h"

@class MKMarketingListItem;

@interface MKMarketingObject : MKBaseObject

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *targetUrl;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *desc;

@property (strong,nonatomic) NSString *bgColor;

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *height;

@property (strong,nonatomic) NSString *type;

@property (strong,nonatomic) NSString *productType;

@property (strong,nonatomic) NSString *topPadding;

@property (strong,nonatomic) NSString *bottomPadding;

@property (strong,nonatomic) NSString *leftPadding;

@property (strong,nonatomic) NSString *rightPadding;

@property (strong,nonatomic) NSString *label;

@property (assign,nonatomic) NSInteger needBorder;

@property (strong,nonatomic) NSArray *itemList;

@property (strong,nonatomic) NSArray *productList;

@property (strong,nonatomic) NSString *borderColor;

@property (nonatomic,copy)NSString * categoryTitle;
@property (nonatomic,copy)NSString * subCategoryTitle;

//首页秒杀相关
@property (nonatomic,copy)NSString *blockId;
@property (nonatomic,copy)NSString*endTime;
@property (nonatomic,copy)NSString*id;
@property (nonatomic,copy)NSString * pageId;
@property (nonatomic,copy)NSString * seckillId;
@property (nonatomic,copy)NSString * startTime;
@property (nonatomic,copy)NSString * subSeckillId;
///////////////////////////////////////////////////////////


//"topx":0
//"topy":2
//"bottomx":3
//"bottomy":3

////////////////////////////////////////////////////////
@property (nonatomic,copy)NSString * gridRow;//列
@property (nonatomic,copy)NSString *gridColumn;//行
@property (nonatomic,strong)NSArray *gridList;

//首页图片相关
@property (nonatomic, copy) NSString *width;

@end
