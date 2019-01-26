//
//  seckilView.m
//  嗨云项目
//
//  Created by 小辉 on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "seckilView.h"

@interface seckilView (){
    dispatch_source_t _timer;
}

@property (nonatomic,assign) NSInteger cutTime;
@property (nonatomic,assign) NSInteger life;
@property (nonatomic, strong) NSTimer *ti1;

@end

@implementation seckilView


-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi) name:@"tongzhi" object:nil];
    
}
-(void)tongzhi{
    [self cutDownTime];
}


-(void)removeFromSuperview
{
   [super removeFromSuperview];
     [_looptimer invalidate];
     _looptimer=nil;
    if (_timer) {
        dispatch_source_cancel(_timer);
        _time=nil;
    }
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:nil];
  
}


-(void)updateView{
        [MKNetworking MKSeniorGetApi:@"/seckill/status" paramters:@{@"seckill_uid" :self. seckillUid,@"sku_uid":self. skuUid} completion:^(MKHttpResponse *response) {
            if (response.errorMsg != nil)
            {
                [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                return ;
            }
            self.seckillStatueOBJ=[seckillStatueOBJ objectWithDictionary:response.mkResponseData];
            self.seckillStatue=self.seckillStatueOBJ.seckill.lifecycle;
            NSLog(@"seckillDic%@",response.mkResponseData);
            NSLog(@"self.seckillStatue%ld",(long)self.seckillStatue);
            NSLog(@"timeInterval%ld",(long)self.seckillStatueOBJ.timeInterval);
//            NSLog(@"YYYYYYYYYYYYYYYYYYYYYYY");
            
            if (self.seckillStatue==1) {
              
                self.starTime=self.seckillStatueOBJ.currentTime;
                self.endtime=self.seckillStatueOBJ.seckill.startTime;
                
            }else{
                self.starTime=self.seckillStatueOBJ.currentTime;
                self.endtime=self.seckillStatueOBJ.seckill.endTime;
            }
            if (self.seckillStatue==1) {
                self.backgroundColor=[UIColor colorWithHexString:@"Fedada"];
                self.jieshuLab.text=@"距离开始";
                self.jieshuLab.textColor=[UIColor colorWithHexString:@"ff2741"];
                self.miaoshaBlockImgV.image=[UIImage imageNamed:@"红色圆角"];
                self.miaoshaLab.textColor=[UIColor whiteColor];
                self.qiangguangLab.hidden=YES;
                
            }
            if (self.seckillStatue==2) {
                self.jieshuLab.text=@"距离结束";
                self.backgroundColor=[UIColor colorWithHexString:@"Fb6165"];
                self.jieshuLab.textColor=[UIColor colorWithHexString:@"fff17c"];
                self.miaoshaBlockImgV.image=[UIImage imageNamed:@"黄色圆角"];
                self.miaoshaLab.textColor=[UIColor redColor];
                self.qiangguangLab.hidden=YES;
            }
            if (self.seckillStatue==3) {
                self.jieshuLab.text=@"距离结束";
                 self.backgroundColor=[UIColor colorWithHexString:@"Fb6165"];
                self.jieshuLab.textColor=[UIColor colorWithHexString:@"fff17c"];
                self.miaoshaBlockImgV.image=[UIImage imageNamed:@"黄色圆角"];
                self.miaoshaLab.textColor=[UIColor redColor];
                self.qiangguangLab.hidden=YES;
            }
            
            if (self.seckillStatue==11) {
                self.jieshuLab.text=@"距离结束";
                self.jieshuLab.textColor=[UIColor colorWithHexString:@"fff17c"];
                 self.backgroundColor=[UIColor colorWithHexString:@"Fb6165"];
                self.miaoshaBlockImgV.image=[UIImage imageNamed:@"黄色圆角"];
                self.miaoshaLab.textColor=[UIColor redColor];
                self.qiangguangLab.hidden=YES;
            }
            
            if (self.seckillStatue==4) {
                self.jieshuLab.text=@"距离结束";
                self.qiangguangLab.hidden=NO;
                self.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
                self.miaoshaLab.textColor=[UIColor blackColor];
                self.jieshuLab.textColor=[UIColor whiteColor];
                self.miaoshaBlockImgV.image=[UIImage imageNamed:@"白色圆角"];
                self.xiaoshiLab.text = @"00";
                self.fenzhongLab.text = @"00";
                self.miaoLab.text = @"00";
                self.haomiaoLab.text = @"00";
           
                return;
            }
            
            self.looptimer = [NSTimer scheduledTimerWithTimeInterval:self.seckillStatueOBJ.timeInterval /1000 target:self selector:@selector(hind) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_looptimer forMode:NSDefaultRunLoopMode];
     
            [self cutDownTime];
        }];

}

-(void)hind{
    if (self.seckillStatue!=4) {
        [self updateView];
    }
    [self.looptimer invalidate];
    self.looptimer=nil;
   
}

-(NSDate*)getyyyymmdd:timeStr{

    NSTimeInterval time=([timeStr doubleValue]+28800000)/1000;//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    return detaildate;
}

-(void)cutDownTime{
    
    NSDate*endDate_tomorrow=[self getyyyymmdd:self.endtime];
    NSDate*inputDate=[self getyyyymmdd:self.starTime];
    
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:inputDate];
    if (_timer==nil) {
        __block int timeout = timeInterval*10; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC/10, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    
                    
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.xiaoshiLab.text = @"00";
                        self.fenzhongLab.text = @"00";
                        self.miaoLab.text = @"00";
                        self.haomiaoLab.text = @"00";
                        
                        if (self.seckillStatue==1) {
                            self.seckillStatue=2;
                            self.jieshuLab.text=@"距离结束";
                            self.starTime=nil;
                            self.endtime=nil;
                            self.starTime=self.seckillStatueOBJ.seckill.startTime;
                            self.endtime=self.seckillStatueOBJ.seckill.endTime;
                            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            NSLog(@"开始秒杀通知的star%@", self.starTime);
                            NSLog(@"开始秒杀通知的end%@",self.endtime);
                            return ;
                        }
                        if (self.seckillStatue==2) {
                            self.starTime=self.seckillStatueOBJ.seckill.startTime;
                            self.endtime=self.seckillStatueOBJ.seckill.endTime;
                            NSLog(@"通知的star%@", self.starTime);
                            NSLog(@"通知的end%@",self.endtime);
                            
                            self.qiangguangLab.hidden=NO;
                            self.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
                            self.miaoshaLab.textColor=[UIColor blackColor];
                            self.miaoshaBlockImgV.image=[UIImage imageNamed:@"白色圆角"];
                             self.jieshuLab.textColor=[UIColor whiteColor];
                            self.seckillStatue=4;
                            return;
                        }
                        if (self.seckillStatue==3) {
                            self.seckillStatue=3;
                            return;
                        }
                        
                        if (self.seckillStatue==11) {
                            [self.looptimer invalidate];
                            self.looptimer=nil;
                            return ;
                        }
                        
                        if (self.seckillStatue==4) {
                            [self.looptimer invalidate];
                            self.looptimer=nil;
                            return ;
                        }
                        
                    });
                }else{
                    if (self.seckillStatue==4) {
                        return ;
                    }
                    
                    int xiaoshi = (int)(timeout/10/3600);
                    NSLog(@"iaoshi%d",xiaoshi);
                    int fengzhong = (int)((timeout-xiaoshi*3600*10)/600);
                    int miao = (int)(timeout-xiaoshi*3600*10-fengzhong*600)/10;
                    int hsecond = timeout-xiaoshi*3600*10-fengzhong*60*10-miao*10;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (xiaoshi<10) {
                            self.xiaoshiLab.text = [NSString stringWithFormat:@"0%d",xiaoshi];
                        }else{
                            self.xiaoshiLab.text = [NSString stringWithFormat:@"%d",xiaoshi];
                        }
                        if (fengzhong<10) {
                            self.fenzhongLab.text = [NSString stringWithFormat:@"0%d",fengzhong];
                        }else{
                            self.fenzhongLab.text = [NSString stringWithFormat:@"%d",fengzhong];
                        }
                        if (miao<10) {
                            self.miaoLab.text = [NSString stringWithFormat:@"0%d",miao];
                        }else{
                            self.miaoLab.text = [NSString stringWithFormat:@"%d",miao];
                        }
                        
                        self.haomiaoLab.text = [NSString stringWithFormat:@"0%d",hsecond];
                        
                    });
                    timeout--;
                    
                    
                    
                }
            });
            dispatch_resume(_timer);
        }
    }
 
}
                    
#pragma mark 限时购倒计时

//限时购倒计时
- (void)getPolling:(UInt64) times startTime:(UInt64)startTime endTime:(UInt64)endTime lifeCycle:(NSUInteger )lifeCycle {
    UInt64 a = startTime;
    UInt64 c = endTime;
    self.life = lifeCycle;
    
    if (lifeCycle == 0)
    {
        NSString * e = [NSString stringWithFormat:@"%llu",a-times];
        self.cutTime = e.integerValue ;
    }else if (lifeCycle == 1) {
        NSString * e = [NSString stringWithFormat:@"%llu",c-times];
        self.cutTime = e.integerValue;
    }
    if (lifeCycle == 2 || c < times || self.cutTime < 0)
    {
        self.haomiaoLab.text = @"00";
        self.miaoLab.text = @"00";
        self.fenzhongLab.text = @"00";
        self.xiaoshiLab.text = @"00";
        [self.ti1 invalidate];
        return;
    }
    [self.ti1 invalidate];
    self.ti1 = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}


- (void)timerFired:(NSTimer *)timer
{
    self.cutTime -= 100;
    [self getOvertime:self.cutTime];
}

- (void)getOvertime:(UInt64)mStr
{
    UInt64 hour;
    UInt64 minute;
    UInt64 second;
    
    if (self.cutTime < 0 || self.life == 3)
    {
        self.xiaoshiLab.text = @"00";
        self.fenzhongLab.text = @"00";
        self.miaoLab.text = @"00";
        self.haomiaoLab.text = @"00";
        return;
    }
    
    UInt64 ab = mStr/1000;
    UInt64 ac = mStr%1000/100;
    
    self.haomiaoLab.text = [NSString stringWithFormat:@"%llu",ac];
    
    hour = ab/3600;
    minute =(ab-hour*3600)/60 ;
    second = ab-hour*3600-minute*60;
    
    NSString *_hStr = @"";
    NSString *_fStr = @"";
    NSString *_mStr = @"";
    if (hour > 0 || hour == 0)
    {
        _hStr = [NSString stringWithFormat:@"0%llu",hour];
        self.xiaoshiLab.text = _hStr;
    }
    if (minute > 0 || minute == 0)
    {
        _fStr = [NSString stringWithFormat:@"0%ld",(long)minute];
        if (minute/10 >1 || minute/10 == 1) {
            _fStr = [NSString stringWithFormat:@"%ld",(long)minute];
        }
        self.fenzhongLab.text = _fStr;
    }
    if (second > 0 || second == 0)
    {
        _mStr = [NSString stringWithFormat:@"0%ld",(long)second];
        if (second/10 >1 || second/10 == 1) {
            _mStr = [NSString stringWithFormat:@"%ld",(long)second];
        }
        self.miaoLab.text = _mStr;
    }

}





@end
