//
//  MKDetailLimitedView.m
//  嗨云项目
//
//  Created by haiyun on 2016/10/10.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "MKDetailLimitedView.h"

@interface MKDetailLimitedView()

@property (weak, nonatomic) IBOutlet UIView *limitedBgView;
@property (weak, nonatomic) IBOutlet UILabel *limitedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *limitedImageView;

@property (assign, nonatomic) BOOL skuNum;
@property (nonatomic,strong)NSTimer *timer;
@property (assign, nonatomic) NSInteger limitTagStatus;
@end

@implementation MKDetailLimitedView

-(void)removeFromSuperview
{
    [_timer invalidate];
    _timer = nil;
    [super removeFromSuperview];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.limitedBgView.layer.cornerRadius = 10.0;
    self.limitedBgView.clipsToBounds = YES;
}

#pragma mark -更新数据
-(void)setMenuMsg:(NSString *)cancelTime skuNum:(BOOL)num limitTagStatus:(NSInteger)tagStatus
{
    self.skuNum = num;
    self.limitTagStatus = tagStatus;
    if ( !(!self.skuNum && self.limitTagStatus == 1) )
    {
        self.limitedBgView.backgroundColor = kHEXCOLOR(0xb3b3b3);
        self.limitedImageView.image = [UIImage imageNamed:@"HYxianshigoushi"];

    }else
    {
        self.limitedBgView.backgroundColor = kHEXCOLOR(0xff3333);
        self.limitedImageView.image = [UIImage imageNamed:@"HYdaojishibeijing"];
 
    }
    if ( ISNSStringValid(cancelTime) )
    {
        NSDate * date = HYNSStringChangeToDate(cancelTime);
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
        if (  self.limitTagStatus == 1 )
        {
            self.limitedLabel.text = [NSString stringWithFormat:@"还有%@小时%@分%@秒 恢复正常售价",hourTStr,minuteStr,secondStr];
            
        }else if( self.limitTagStatus == 0  )
        {
            self.limitedLabel.text = [NSString stringWithFormat:@"还有%@小时%@分%@秒 开始限时特价",hourTStr,minuteStr,secondStr];
            
        }else
        {
            self.limitedLabel.text = @"活动已结束";
        }
        self.limitedLabel.hidden = NO;
//        if ( _timer )
//        {
//            [_timer invalidate];
//            _timer = nil;
//        }
//        self.limitedLabel.hidden = NO;
//        [_timer invalidate];
//        _timer = nil;
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimeChange:) userInfo:HYNSStringChangeToDate(cancelTime) repeats:YES];
//        [self setTimeChange:_timer];
//        if ( _timer ) {
//            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//        }

    }
}
#pragma mark -定时器时间更新
-(void)setTimeChange:(NSTimer *)Timer
{
    NSDate * date = (NSDate *)[Timer userInfo];
    
    if ( [date compare:HYDateChangeToDate([NSDate date])] == kCFCompareLessThan )
    {
        [_timer invalidate];
        _timer = nil;
        self.limitedLabel.hidden = NO;
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
        if (  self.limitTagStatus == 1 )
        {
            self.limitedLabel.text = [NSString stringWithFormat:@"还有%@小时%@分%@秒 恢复正常售价",hourTStr,minuteStr,secondStr];

        }else if( self.limitTagStatus == 0  )
        {
            self.limitedLabel.text = [NSString stringWithFormat:@"还有%@小时%@分%@秒 开始限时特价",hourTStr,minuteStr,secondStr];

        }
        self.limitedLabel.hidden = NO;
    }
}

@end
