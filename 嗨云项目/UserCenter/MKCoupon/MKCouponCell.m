//
//  MKCouponCell.m
//  YangDongXi
//
//  Created by windy on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKCouponCell.h"
#import "UIColor+MKExtension.h"
#import "MKBaseItemObject.h"

@interface MKCouponCell ()

/** 即将过期 */
@property (weak, nonatomic) IBOutlet UIView *willOverdue;
/** 优惠券面值 */
@property (weak, nonatomic) IBOutlet UILabel *couponMoney;
/** 使用期限 */
@property (weak, nonatomic) IBOutlet UILabel *useDeadline;
/** 优惠券编号 */
@property (weak, nonatomic) IBOutlet UILabel *couponNo;
/** 优惠券满足条件 */
@property (weak, nonatomic) IBOutlet UILabel *couponCondition;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *loopsImageViewPinLeading;

@end


@implementation MKCouponCell

+ (id)loadFromNib
{
    NSString *xibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
}

+ (NSString*)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.selectedIcon.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectedIcon.highlighted = selected;
}

- (void)setCoupon:(MKCouponObject *)coupon
{
    _coupon = coupon;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.loopsImageViewPinLeading.constant != 0)
    {
        return;
    }
    UIImage *im = [UIImage imageNamed:@"coupon_ornament"];
    CGFloat f = im.size.width / 2;
    CGFloat x = fmod(self.loopsImageView.frame.size.width, f);
    NSInteger n = self.loopsImageView.frame.size.width / f * 2;
    if (n % 2 == 0)
    {
        x += f;
    }
    self.loopsImageViewPinLeading.constant = x / 2;
    [self.loopsImageView layoutIfNeeded];
}

- (void)layoutCellSubviews
{
    self.contentBackView.layer.cornerRadius = 3;
    self.contentBackView.layer.masksToBounds = YES;
    self.contentBackView.layer.borderColor = [UIColor colorWithHex:0xbbbbbb].CGColor;
    self.contentBackView.layer.borderWidth = 0.5;
    
    self.iconBackImageView.layer.cornerRadius = 17.5;
    self.iconBackImageView.layer.masksToBounds = YES;
    
    self.numberLabel.layer.cornerRadius = 3;
    self.numberLabel.layer.masksToBounds = YES;
    
    self.loopsImageView.image = [[UIImage imageNamed:@"coupon_ornament"] resizableImageWithCapInsets:UIEdgeInsetsZero
                                                                                        resizingMode:UIImageResizingModeTile];

    self.selectedIcon.hidden = !self.canSelect;
    // 默认为隐藏
    [self.willOverdue setHidden:YES];
    
    // cell的使用期限判断
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    dfm.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *ds = [dfm dateFromString:self.coupon.startTime];
    NSDate *de = [dfm dateFromString:self.coupon.endTime];
    dfm.dateFormat = @"yyyy-MM-dd";
    
    self.useConditionLabel.text = [NSString stringWithFormat:@"使用时间: %@ ~ %@", [dfm stringFromDate:ds], [dfm stringFromDate:de]];

    // 优惠券面值处理
    NSInteger totalNum = 0;
    NSInteger discountNum = 0;
    for (NSDictionary *propertyDic in self.coupon.propertyList) {
        if ([[propertyDic objectForKey:@"name"] isEqualToString:@"quota"]) {
            totalNum = [[propertyDic objectForKey:@"value"] integerValue];
        }
        if ([[propertyDic objectForKey:@"name"] isEqualToString:@"consume"]) {
            discountNum = [[propertyDic objectForKey:@"value"] integerValue];
        }
    }
    NSString *moneyStr = [MKBaseItemObject priceString:totalNum];
    self.couponMoney.text = moneyStr;

    //优惠券名称
    if (self.coupon.name) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",self.coupon.name];

    }
    else
    {
        self.nameLabel.text = @"";

    }
    
    //使用条件
//    NSString *contentStr = [MKBaseItemObject priceString:discountNum];
    if (self.coupon.content) {
        self.couponCondition.text = [NSString stringWithFormat:@"使用条件: %@",self.coupon.content];

    }
    else
    {
        self.couponCondition.text = @"使用条件:";

    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.coupon.number];
//    
//    self.vImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"coupon_dot_line_v"]];
}

@end
