//
//  favourableTableViewCell.h
//  haiyuntableView
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 HaiYn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MKCouponObject.h"



@interface favourableTableViewCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath * index;
@property (weak, nonatomic) IBOutlet UIButton *isChoose;
//下拉的细节详情
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
//优惠券的名字
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
//优惠券的使用条件
@property (weak, nonatomic) IBOutlet UILabel *conditionLab;
//优惠券的使用期限
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

//优惠券的面值
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

/** 优惠券对象 */
@property (nonatomic,strong) MKCouponObject *coupon;
//还剩几天使用
@property (weak, nonatomic) IBOutlet UILabel *intervalLab;

- (void)layoutCellSubviews;

@end
