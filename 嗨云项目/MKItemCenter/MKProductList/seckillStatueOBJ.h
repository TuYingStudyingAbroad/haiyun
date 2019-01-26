//
//  seckillStatueOBJ.h
//  嗨云项目
//
//  Created by 小辉 on 16/7/15.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"
#import "MiaoTuanXianObject.h"
@interface seckillStatueOBJ : MKBaseObject
//轮训间隔
@property (nonatomic,assign)NSInteger timeInterval;
//服务器当前时间
@property(nonatomic,copy)NSString *currentTime;

@property (nonatomic,strong) MiaoTuanXianObject*seckill;
@end
