//
//  GLObject.h
//  嗨云项目
//
//  Created by 唯我独尊 on 16/8/24.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface GLObject : MKBaseObject

//卖家ID
@property (nonatomic,assign)NSInteger myID;
//卖家的用户ID
@property (nonatomic,assign)NSInteger userId;
//累计收入
@property (nonatomic,assign)NSInteger totalCome;
//今日收入
@property (nonatomic,assign)NSInteger todayCome;
//推荐二维码URL
@property (nonatomic,strong)NSString * inviterUrl;
//店铺二维码URL
@property (nonatomic,strong)NSString * shopUrl;


@end
