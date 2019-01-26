//
//  MKCouponCell.h
//  YangDongXi
//
//  Created by windy on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCouponObject.h"

@interface MKCouponCell : UITableViewCell

// 选择block
typedef void (^selectBlock)(MKCouponCell*);
@property (copy, nonatomic) selectBlock selectActionBlock;
@property (weak, nonatomic) IBOutlet UIView *contentBackView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *loopsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconBackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *useConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIcon;
@property (weak, nonatomic) IBOutlet UIButton *useConditionBtn;

/** 优惠券对象 */
@property (nonatomic,strong) MKCouponObject *coupon;
//@property (nonatomic ,assign)double detalTime;
@property (nonatomic,assign) BOOL canSelect;

+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

- (void)layoutCellSubviews;

@end
