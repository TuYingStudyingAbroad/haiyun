//
//  MKPrivilegeTableViewCell.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKPrivilegeTableViewCell.h"

@implementation MKPrivilegeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellWithModel:(MKCouponObject *)model withType:(NSInteger) type{
    // cell的使用期限判断
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];// zh_CN
//    [outputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    
//    if (type == 1) {
//        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
//    }else {
//       [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    }
//    [outputFormatter setDateFormat:@"yyyy.MM.dd"];
    
//    NSDate *endDate = [inputFormatter dateFromString:model.endTime];
//    NSDate *starDate = [inputFormatter dateFromString:model.startTime];
//    
//    NSString *endT = [outputFormatter stringFromDate:endDate];
//    NSString *startT = [outputFormatter stringFromDate:starDate];
    
    self.timeLabe.text = [NSString stringWithFormat:@"使用期限 %@-%@", model.startTime, model.endTime];
    
    // 优惠券面值处理
    NSInteger totalNum = 0;
    NSInteger discountNum = 0;
    for (NSDictionary *propertyDic in model.propertyList) {
        if ([[propertyDic objectForKey:@"name"] isEqualToString:@"quota"]) {
            totalNum = [[propertyDic objectForKey:@"value"] integerValue];
        }
        if ([[propertyDic objectForKey:@"name"] isEqualToString:@"consume"]) {
            discountNum = [[propertyDic objectForKey:@"value"] integerValue];
        }
    }
    NSString *moneyStr = [NSString stringWithFormat:@"%ld",totalNum/100];
    self.monelab.text = moneyStr;
    //使用条件
    //    NSString *contentStr = [MKBaseItemObject priceString:discountNum];
    if (model.content.length) {
        self.thresholdLabel.text = [NSString stringWithFormat:@"%@",model.content];
    }
    else
    {
        self.thresholdLabel.text = @"";
    }
}
@end
