//
//  firstSeckillingCutDownView.m
//  嗨云项目
//
//  Created by 小辉 on 16/10/12.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "firstSeckillingCutDownView.h"
#import "MKMarketingObject.h"
@interface firstSeckillingCutDownView()<seckillingBtnViewDelegate,UIScrollViewDelegate>
{
     dispatch_source_t _timer;
}

@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic,strong)NSMutableArray * topScrollowBtnArray;
@property (nonatomic,strong)NSArray * dataArray;

@property (nonatomic,copy)NSString * starTimeStr;
@property (nonatomic,copy)NSString * endTimeStr;

@property (nonatomic,copy)NSString * xiaoShiStr;
@property (nonatomic,copy)NSString * fengZhongStr;
@property (nonatomic,copy)NSString * miaoStr;


@end
float topScrollowItemWidth;
float bottomScrollowItemWidth;
 static int rightOrLeft;
@implementation firstSeckillingCutDownView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.stateLab.layer.borderWidth = 1.0f;
    self.stateLab.layer.borderColor = [UIColor whiteColor].CGColor;
    topScrollowItemWidth=(self.frame.size.width-80)/3;
    bottomScrollowItemWidth=self.frame.size.width;
    NSLog(@"SSS%f",topScrollowItemWidth);
    
    _topScrollowBtnArray=[[NSMutableArray alloc]init];
    _dataArray=[[NSArray alloc]init];
    
}


-(void)setUpATopScrollMenu:(NSArray *)menuItems{
    if (menuItems.count == 0) {
        return;
    }
    self.dataArray=menuItems;
    
    topScrollowItemWidth=(self.frame.size.width-80)/3;
    bottomScrollowItemWidth=self.frame.size.width;
    self.topScrollView.contentSize=CGSizeMake(topScrollowItemWidth* self.dataArray.count+6*20,33);
    self.bottomScrollView.contentSize=CGSizeMake(bottomScrollowItemWidth*self.dataArray.count,150);
    self.topScrollView.delegate=self;
    // 隐藏水平导航栏
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;

    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.delegate=self;

    [self.topScrollView setUserInteractionEnabled:YES];
    [self.bottomScrollView setUserInteractionEnabled:YES];

    [self setMenu];

}

- (void)setMenu{
   [_topScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_bottomScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_topScrollowBtnArray removeAllObjects];
    for (int i=0;i<self.dataArray.count;i++) {
        seckillingBtnView *menuItem=[seckillingBtnView loadFromXib];
        menuItem.frame=CGRectMake(topScrollowItemWidth*i+20*i, 0, topScrollowItemWidth, 33);
        menuItem.tag = 1000 + i;
        menuItem.delegate=self;
        if (i==0) {
            menuItem.seckillingBVLab.layer.borderWidth = 1.0f;
            menuItem.seckillingBVLab.layer.borderColor = [UIColor redColor].CGColor;
        }
        [_topScrollView addSubview:menuItem];
        [_topScrollowBtnArray addObject:menuItem];
        
        UIImageView * imgV=[[UIImageView alloc]init];
        imgV.frame=CGRectMake(bottomScrollowItemWidth*i, 0, bottomScrollowItemWidth, 150);
        imgV.tag=10+i;
        imgV.image=[UIImage imageNamed:@"haikebeijing.jpg"];
        [self.bottomScrollView addSubview:imgV];
        UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doimgTap:)];
        //给imgV添加一个手势监测；
        imgV.userInteractionEnabled = YES;
        [imgV addGestureRecognizer:imgTap];
        
        if (_timer) {
            dispatch_source_cancel(_timer);
            _timer=nil;
            [self changeTime:0];
        }
     

    }

}

-(void)doimgTap:(UITapGestureRecognizer*)sender{
    UIImageView * bottomScrollViewImgV=(UIImageView *)[sender view] ;
    NSInteger bottomScrollViewImgTag=bottomScrollViewImgV.tag-10;
    if ([self.delegate respondsToSelector:@selector(firstSeckillingCutDownViewImgVClick:)]) {
        [self.delegate firstSeckillingCutDownViewImgVClick:bottomScrollViewImgTag];
    }
  
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer=nil;
    }

    if (scrollView==_bottomScrollView) {
        int a =scrollView.contentOffset.x/(self.frame.size.width);
        NSLog(@"ffff%d",a);
//     self.topScrollView.contentOffset=CGPointMake((topScrollowItemWidth+20)*a, 0);
        
        for (seckillingBtnView *menuItem in _topScrollowBtnArray) {
           
        menuItem.seckillingBVLab.layer.borderWidth = 1.0f;
            menuItem.seckillingBVLab.layer.borderColor = [UIColor grayColor].CGColor;
        }
        seckillingBtnView *menuItem1=[_topScrollowBtnArray objectAtIndex:a];
        menuItem1.seckillingBVLab.layer.borderWidth = 1.0f;
        menuItem1.seckillingBVLab.layer.borderColor = [UIColor redColor].CGColor;
        
        if (a%3==0) {
            if (a>rightOrLeft) {
                 _topScrollView.contentOffset=CGPointMake((self.frame.size.width-20)*(a/3),0);
            }
        }
        if ((a+1)%3==0) {
            if (a<rightOrLeft) {
                 _topScrollView.contentOffset=CGPointMake((self.frame.size.width-20)*(a/3),0);
            }
        }
         rightOrLeft=a ;
        
        [self changeTime:a];
       
    }
    
}

-(void)changeTime:(NSInteger) location{
    MKMarketingObject *ob=[self.dataArray objectAtIndex:location];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    int seckillingState1= [self compareDate:dateString withDate:ob.startTime];
    int seckillingState2= [self compareDate:dateString withDate:ob.endTime];
    
    NSLog(@"star%@ end%@",ob.startTime,ob.endTime);
    NSLog(@"bbbbbbbb  star%d   end%d",seckillingState1,seckillingState2 );
    
    if (seckillingState1<0) {
        //未开始
        self.timeTitleLab.text=@"距离活动开始还剩";
        self.starTimeStr=dateString;
        self.endTimeStr=ob.startTime;
        
        [self cutDownTime];
        return;
    }
    if (seckillingState1>0&&seckillingState2<0) {
        //进行中
        self.starTimeStr=dateString;
        self.endTimeStr=ob.endTime;
        self.timeTitleLab.text=@"距离活动结束还剩";
        [self cutDownTime];
        return;
    }
    if (seckillingState2>0) {
        //已经结束
        self.starTimeStr=@"0000-00-00 00:00:00";
        self.endTimeStr=@"0000-00-00 00:00:00";
        [self cutDownTime];
        self.timeTitleLab.text=@"距离活动结束还剩";
        self.timeCutDownLab.text=@"00:00:00";
        return;
    }
    
}



-(NSDate*)getyyyymmdd:timeStr{

    return  HYNSStringChangeToDate(timeStr);
  
}

-(void)cutDownTime{
        NSDate*endDate_tomorrow=[self getyyyymmdd: self.endTimeStr];
        NSDate*inputDate=[self getyyyymmdd: self.starTimeStr];
        NSLog(@"end%@",endDate_tomorrow);
        NSLog(@"strat%@",inputDate);

        NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:inputDate];
        NSLog(@"timeInterval%f",timeInterval);

    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        dispatch_source_cancel(_timer);
                        self.timeCutDownLab.text=@"00:00:00";
                        
                        
//                    });
                }else{
                    
                    int xiaoshi = (int)(timeout/3600);
                    int fengzhong = (int)((timeout-xiaoshi*3600)/60);
                    int miao = (int)(timeout-xiaoshi*3600-fengzhong*60)/1;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (xiaoshi<10) {
                            self.xiaoShiStr = [NSString stringWithFormat:@"0%d",xiaoshi];
                        }else{
                            self.xiaoShiStr = [NSString stringWithFormat:@"%d",xiaoshi];
                        }
                        if (fengzhong<10) {
                           self.fengZhongStr = [NSString stringWithFormat:@"0%d",fengzhong];
                        }else{
                             self.fengZhongStr = [NSString stringWithFormat:@"%d",fengzhong];
                        }
                        if (miao<10) {
                            self.miaoStr = [NSString stringWithFormat:@"0%d",miao];
                        }else{
                           self.miaoStr = [NSString stringWithFormat:@"%d",miao];
                        }
                        self.timeCutDownLab.text=[NSString stringWithFormat:@"%@:%@:%@", self.xiaoShiStr, self.fengZhongStr, self.miaoStr];
                    });
                    timeout--;
                    
                    
                    
                }
            });
            dispatch_resume(_timer);
        }
    }

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView==_topScrollView) {
//        int a =scrollView.contentOffset.x/(self.frame.size.width-100);
//        NSLog(@"xxxxxxxxxxxxxxxx%d",a);
//        
//    }

}


-(void)seckillingBVBtnClick:(seckillingBtnView *)item{
    NSLog(@"%ld",(long)item.tag);
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer=nil;
    }

    _bottomScrollView.contentOffset=CGPointMake(bottomScrollowItemWidth*(item.tag-1000), 0);

    for (seckillingBtnView *menuItem in _topScrollowBtnArray) {
        menuItem.seckillingBVLab.layer.borderWidth = 1.0f;
        menuItem.seckillingBVLab.layer.borderColor = [UIColor grayColor].CGColor;
    }
        item.seckillingBVLab.layer.borderWidth = 1.0f;
        item.seckillingBVLab.layer.borderColor = [UIColor redColor].CGColor;
    
    [self changeTime:item.tag-1000];
    
    
   
}


//比较两个时间的大小
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date01比date02小
        case NSOrderedAscending: ci=-1; break;
            //date01比date02大
        case NSOrderedDescending: ci=1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


@end
