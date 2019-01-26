//
//  favourableTableViewCell.m
//  haiyuntableView
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 HaiYn. All rights reserved.
//

#import "favourableTableViewCell.h"
#import "MKBaseItemObject.h"
@implementation favourableTableViewCell


- (void)awakeFromNib {
    }

- (void)setCoupon:(MKCouponObject *)coupon
{
    _coupon = coupon;
}


-(void)layoutCellSubviews{
    // cell的使用期限判断
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    dfm.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    
    NSDate *ds = [dfm dateFromString:self.coupon.startTime];
    NSDate *de = [dfm dateFromString:self.coupon.endTime];
    dfm.dateFormat = @"yyyy.MM.dd";
   
    
    self.dateLab.text = [NSString stringWithFormat:@"%@-%@", [dfm stringFromDate:ds], [dfm stringFromDate:de]];
    
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
    self.moneyLab.text = moneyStr;
    
    //优惠券名称
    if (self.coupon.name) {
        self.nameLab.text = [NSString stringWithFormat:@"%@",self.coupon.name];
        
    }
    else
    {
        self.nameLab.text = @"";
        
    }
    
    //使用条件
    //    NSString *contentStr = [MKBaseItemObject priceString:discountNum];
    if (self.coupon.content) {
        self.conditionLab.text = [NSString stringWithFormat:@"%@",self.coupon.content];
        
    }
    else
    {
        self.conditionLab.text = @"";
        
    }
    
    if (self.coupon.discountAmount) {
        self.detailLab.text=[NSString stringWithFormat:@"%ld",(long)self.coupon.discountAmount];
    }
    
    
    
    /////计算两个时间的间隔 设置剩余天数
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:ds];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:de];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    NSInteger day=dayComponents.day;
    self.intervalLab.text=[NSString stringWithFormat:@"仅剩%ld天",(long)day];
    
}



+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
