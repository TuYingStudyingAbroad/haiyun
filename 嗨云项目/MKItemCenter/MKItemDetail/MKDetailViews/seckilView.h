//
//  seckilView.h
//  嗨云项目
//
//  Created by 小辉 on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//
#import "UIView+MKExtension.h"
#import <UIKit/UIKit.h>
#import "MKNetworking+BusinessExtension.h"
#import "seckillStatueOBJ.h"

@interface seckilView : UIView
//秒杀后面的背景
@property (weak, nonatomic) IBOutlet UIImageView *miaoshaBlockImgV;
//秒杀lab
@property (weak, nonatomic) IBOutlet UILabel *miaoshaLab;
//放倒计时的view
@property (weak, nonatomic) IBOutlet UIView *timeView;
//距离时间结束的lab
@property (weak, nonatomic) IBOutlet UILabel *jieshuLab;
//抢光lab
@property (weak, nonatomic) IBOutlet UILabel *qiangguangLab;
//小时
@property (weak, nonatomic) IBOutlet UILabel *xiaoshiLab;
//分钟
@property (weak, nonatomic) IBOutlet UILabel *fenzhongLab;
//秒
@property (weak, nonatomic) IBOutlet UILabel *miaoLab;
//毫秒
@property (weak, nonatomic) IBOutlet UILabel *haomiaoLab;
//活动价格名称
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
//活动的原价或活动价
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyMarkLabel;
//放活动价格的view
@property (weak, nonatomic) IBOutlet UIView *activePriceView;


@property (nonatomic,strong) NSString * seckillUid;
@property (nonatomic,strong)NSString *distributorId;
@property (nonatomic,assign)NSInteger seckillStatue;
@property(nonatomic,copy)NSString * skuUid;
@property (nonatomic,strong)NSTimer *looptimer;



//服务器时间
@property (nonatomic,copy) NSString * time;
//开始时间
@property (nonatomic,copy)NSString * starTime;
//结束时间
@property (nonatomic,copy)NSString * endtime;


@property (nonatomic,strong) seckillStatueOBJ * seckillStatueOBJ;

-(void)updateView;

//限时购倒计时
- (void)getPolling:(UInt64) times startTime:(UInt64)startTime endTime:(UInt64)endTime lifeCycle:(NSUInteger )lifeCycle;

@end
