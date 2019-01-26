//
//  fansTableViewCell.m
//  嗨云项目
//
//  Created by 小辉 on 16/8/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "fansTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation fansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
    
    _nowTimeStr=[dateformatter stringFromDate:senddate];
    
    
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:senddate];
    _lastTimeStr=[dateformatter stringFromDate:lastDay];

}
//-(void)setFansObject:(fansObject *)fansObject{
//    _fansObject=fansObject;
//}
- (void)layoutCellSubviews{
    if ([_nowTimeStr isEqualToString:_fansObject.gmtCreated]) {
        self.timeLab.text=@"今天";
    } else if ([_lastTimeStr isEqualToString:_fansObject.gmtCreated]){
        self.timeLab.text=@"昨天";

    }else{
           self.timeLab.text=_fansObject.gmtCreated;
    }
    self.nameLab.text=_fansObject.nickName;
 
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:_fansObject.headPortrait]placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
    self.moneyLab.text=[NSString stringWithFormat:@"￥%.2f",_fansObject.cumMoney/100.0];
    
    if (_fansObject.sex==1) {
        self.sexImgV.image=[UIImage imageNamed:@"nan"];
    }else{
         self.sexImgV.image=[UIImage imageNamed:@"nv"];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
