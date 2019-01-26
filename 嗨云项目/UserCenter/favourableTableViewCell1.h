//
//  favourableTableViewCell1.h
//  嗨云项目
//
//  Created by kans on 16/5/19.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCouponObject.h"
@interface favourableTableViewCell1 : UITableViewCell
//优惠券名字
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
//满多少可用
@property (weak, nonatomic) IBOutlet UILabel *conditionLab;
//场景使用
@property (weak, nonatomic) IBOutlet UILabel *sceneLab;
//使用的时间范围
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
//剩余多少天
@property (weak, nonatomic) IBOutlet UILabel *timeLimitLab;
//面值
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
//红色 或者灰色背景
@property (weak, nonatomic) IBOutlet UIImageView *blackImgV;
/** 优惠券对象 */
@property (nonatomic,strong) MKCouponObject *coupon;

@property (nonatomic,assign)NSInteger status;

- (void)layoutCellSubviews;
@end
