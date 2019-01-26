//
//  favourableTableViewCell1.m
//  嗨云项目
//
//  Created by kans on 16/5/19.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "favourableTableViewCell1.h"
#import "MKBaseItemObject.h"

@implementation favourableTableViewCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCoupon:(MKCouponObject *)coupon
{
    _coupon = coupon;
}


-(void)layoutCellSubviews{
    // cell的使用期限判断
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    dfm.dateFormat = @"yyyy.MM.dd";
    
    NSDate *ds = [dfm dateFromString:self.coupon.startTime];
    NSDate *de = [dfm dateFromString:self.coupon.endTime];
   
    
    
    self.timeLab.text = [NSString stringWithFormat:@"有效期:%@-%@", [dfm stringFromDate:ds], [dfm stringFromDate:de]];
    
    
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
    NSString *moneyStr = [NSString stringWithFormat:@"%ld",totalNum/100];
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
    //使用场景的判断 1:全平台 3:全店 4:指定商品 5:指定品类 6:指定品牌
    NSInteger scope=self.coupon.scope;
    if (scope==1) {
        self.sceneLab.text=@"全场通用";
    }else if(scope==3)
    {
        self.sceneLab.text=@"全场通用";
    }else if(scope==4){
        self.sceneLab.text=@"指定商品";
    }else if(scope==5){
        self.sceneLab.text=@"指定品类";
    }else{
        self.sceneLab.text=@"指定品牌";

    }
    if (self.coupon.nearExpireDate==1) {
        self.timeLimitLab.hidden=NO;
        self.timeLimitLab.text=@"即将过期";
    }else{
        self.timeLimitLab.hidden=YES;
    }
    
    
    switch (self.status) {
        case 0:{
        }
            
            break;
        case 1:{}
            break;
        case 2:{
            self.timeLimitLab.hidden=YES;
        }
            break;
    }

}



@end
