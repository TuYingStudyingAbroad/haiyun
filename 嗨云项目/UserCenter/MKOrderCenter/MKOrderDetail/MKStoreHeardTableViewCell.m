//
//  MKStoreHeardTableViewCell.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKStoreHeardTableViewCell.h"



@interface MKStoreHeardTableViewCell ()

@property (nonatomic,strong)NSDate *today;

@property (nonatomic,strong)NSTimer *timer;

@end
@implementation MKStoreHeardTableViewCell


-(void)removeFromSuperview
{
    [_timer invalidate];
    _timer = nil;
    [super removeFromSuperview];
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellWithModel:(MKOrderObject *)model{
    self.timeLabel.text = @"";
    self.orderStates.text = [MKOrderObject textForStatus:model.orderStatus];
    if (model.orderStatus ==  MKOrderStatusUnpaid && model.payTimeout > 0 && model.orderType != 7) {
        
        self.orderShow.text = @"自动取消";
        self.timeLabel.textColor = [UIColor colorWithHex:0x999999];
        self.orderImages.hidden = NO;
        self.orderTimeConst.constant = 35.0f;;
        [_timer invalidate];
        _timer = nil;
//        _timesLimt = orderInf.payTimeout;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimeChange:) userInfo:HYNSStringChangeToDate(model.cancelOrderTime) repeats:YES];
        [self setTimeChange:_timer];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }else
    {
        [_timer invalidate];
        _timer = nil;
        self.timeLabel.text = model.orderTime;
        self.orderShow.text = @"";
        self.orderImages.hidden = YES;
        self.orderTimeConst.constant = 15.0f;
        self.timeLabel.textColor = [UIColor colorWithHex:0x999999];
        if (model.orderStatus < MKOrderStatusPaid) {
            self.timeLabel.text = model.orderTime;
        }else if(model.orderStatus ==  MKOrderStatusDelivery || model.orderStatus ==  MKOrderStatusPaid){
            self.timeLabel.text = model.payTime;
            if (!model.payTime) {
                self.timeLabel.text = model.orderTime;
            }
        }else if(model.orderStatus ==  MKOrderStatusDeliveried){
            self.timeLabel.text = model.consignTime;
        }else if(model.orderStatus ==  MKOrderStatusSignOff){
            self.timeLabel.text = model.receiptTime;
        }else{
            self.timeLabel.text = model.orderTime;
        }
        
    }
}
- (void)setTimeChange:(NSTimer *)Timer{
    NSDate * date = (NSDate *)[Timer userInfo];
 
    if ( [date compare:HYDateChangeToDate([NSDate date])] == kCFCompareLessThan )
    {
        [_timer invalidate];
        _timer = nil;
//        _timeLabel.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:MKOrderStatusChangedNotification object:nil];
    }
    else
    {
        NSTimeInterval secondBetweenDates = [date timeIntervalSinceDate:HYDateChangeToDate([NSDate date])];
        NSInteger day = fabs(secondBetweenDates/(60*60*24));
        NSString *dayStr = day>9?[NSString stringWithFormat:@"%ld",(long)day]:[NSString stringWithFormat:@"0%ld",(long)day];
        
        NSInteger timeShow = labs((NSInteger)secondBetweenDates%(60*60*24));
        NSInteger hour = labs(timeShow/3600);
        NSString *hourStr = hour>9?[NSString stringWithFormat:@"%ld",(long)hour]:[NSString stringWithFormat:@"0%ld",(long)hour];
        
        NSInteger temp = labs((NSInteger)timeShow%3600);
        NSInteger minute =labs(temp/60);
        NSString *minuteStr = minute>9?[NSString stringWithFormat:@"%ld",(long)minute]:[NSString stringWithFormat:@"0%ld",(long)minute];
        
        NSInteger second =labs(temp%60);
        NSString *secondStr = second>9?[NSString stringWithFormat:@"%ld",(long)second]:[NSString stringWithFormat:@"0%ld",(long)second];
        
        
        NSInteger hourT= [dayStr integerValue]*24 + [hourStr integerValue];
        NSString *hourTStr = hourT>9?[NSString stringWithFormat:@"%ld",(long)hourT]:[NSString stringWithFormat:@"0%ld",(long)hourT];
        self.timeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hourTStr,minuteStr,secondStr];
    }
}
+ (CGFloat)cellHeight{
    return 16;
}

@end
