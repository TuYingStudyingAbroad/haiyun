//
//  HYPlaceTheOrderView.m
//  嗨云项目
//
//  Created by haiyun on 16/9/22.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#define GGOrderTopHeight 170

#import "HYPlaceTheOrderView.h"

/***************BaseCell**************************/
#pragma mark BaseCell
@interface HYPayBaseCellView ()
{
    
}
@end
@implementation HYPayBaseCellView

@synthesize delegate = _delegate;

-(void)setMenuMsgDict:(NSMutableDictionary *)MenuMsgDict
          bHiddenLine:(BOOL)bhidden
{
    
}

@end

/*************TopCell***************/
#pragma mark HYPayTopUITableViewCell
@interface HYPayTopUITableViewCell ()
{
    
    
    UILabel         *_titleLabel;
    
    UILabel         *_timeLabel;
    
    UILabel         *_messageLabel;
    
    NSTimer         *_timer;
    
}

@end

@implementation HYPayTopUITableViewCell

-(void)removeFromSuperview
{
    [_timer invalidate];
    _timer = nil;
    [super removeFromSuperview];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    
    self.backgroundColor = kHEXCOLOR(kRedColor);
    
    CGRect rect = CGRectMake(0, 0, 0, 0);
    rect.origin.x = 12.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 15.0f;
    rect.origin.y = frame.size.height - rect.size.height-13.0f;
    if ( _messageLabel == nil ) {
        _messageLabel = NewObject(UILabel);
        _messageLabel.text = @"订单已提交成功请尽快付款，超时订单将被取消";
        _messageLabel.font = [UIFont systemFontOfSize:12.0f];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.frame = rect;
        [self addSubview:_messageLabel];
    }else{
        _messageLabel.frame = rect;
    }
    rect.size.height = 30.0f;
    rect.origin.y -= (rect.size.height + 33.0f);
    if ( _timeLabel == nil ) {
        _timeLabel = NewObject(UILabel);
        _timeLabel.text = @"00:00:00";
        _timeLabel.font = [UIFont systemFontOfSize:25.0f];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.frame = rect;
        [self addSubview:_timeLabel];
    }else{
        _timeLabel.frame = rect;
    }
    
    rect.size.height = 17.0f;
    rect.origin.y -= (rect.size.height + 12.0f);
    if ( _titleLabel == nil ) {
        _titleLabel = NewObject(UILabel);
        _titleLabel.text = @"剩余支付时间";
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.frame = rect;
        [self addSubview:_titleLabel];
    }else{
        _titleLabel.frame = rect;
    }
    
    
    
}

-(void)setMenuMsgDict:(NSMutableDictionary *)MenuMsgDict
          bHiddenLine:(BOOL)bhidden
{
    NSInteger orderType = [[MenuMsgDict HYValueForKey:@"orderType"] integerValue];
    if ( orderType != 7 ) {
        _messageLabel.hidden = NO;
        _titleLabel.hidden   = NO;
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(daojishi:) userInfo:HYNSStringChangeToDate([MenuMsgDict HYValueForKey:@"orderTime"]) repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [self daojishi:_timer];
    }else{
        _timeLabel.text    = @"开店礼包订单";
        _messageLabel.hidden = YES;
        _messageLabel.hidden   = YES;
    }
}

- (void)daojishi:(NSTimer *)timer
{
    
    NSDate * date = (NSDate *)[timer userInfo];
    
    if ( [date compare:HYDateChangeToDate([NSDate date])] == kCFCompareLessThan )
    {
        _timeLabel.text =[NSString stringWithFormat:@"00:00:00"];
        _messageLabel.text = @"订单已超时，请重新下单!";
        [_timer invalidate];
        _timer = nil;
//        self.playView.priceBut.enabled                                    = NO;
//        self.playView.priceBut.backgroundColor                            = [UIColor colorWithHex:0xcccccc];
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
        _timeLabel.text =[NSString stringWithFormat:@"%@:%@:%@",hourTStr,minuteStr,secondStr];
    }
    
    
}


@end

/*********PayWay************/
#pragma mark HYPayWayUITableViewCell
@interface HYPayWayUITableViewCell()
{
    UILabel     *_titleLabel;
    
    UIView      *_lineView;
}

@end

@implementation HYPayWayUITableViewCell
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(12.0f, 0, frame.size.width, frame.size.height);
    rect.size.width = frame.size.width - 2*rect.origin.x;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.text = @"选择支付方式";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.frame= rect;
        _titleLabel.textColor = kHEXCOLOR(0x333333);
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    
    rect.size.height = 1.0f;
    rect.origin.x = 12.0f;
    rect.origin.y = frame.size.height - rect.size.height;
    if ( _lineView == nil )
    {
        _lineView = NewObject(UIView);
        _lineView.frame = rect;
        _lineView.backgroundColor = kHEXCOLOR(0xE8E8E8);
        [self addSubview:_lineView];
    }else
    {
        _lineView.frame = rect;
    }
}

-(void)setMenuMsgDict:(NSMutableDictionary *)MenuMsgDict
          bHiddenLine:(BOOL)bhidden
{
    
}

@end

/*********PayWay************/
#pragma mark HYPayGoUITableViewCell
@interface HYPayGoUITableViewCell ()
{
    UILabel             *_titleLabel;
    UILabel             *_nameLabel;
    UIImageView         *_rightImageView;
}


@end

@implementation HYPayGoUITableViewCell

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    self.backgroundColor = kHEXCOLOR(0xFDF7DC);
    CGRect rect = CGRectMake(12.0f, 0, 7.0f, 22.0f);
    rect.origin.x = frame.size.width - 12.0f - rect.size.width;
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    if ( _rightImageView == nil )
    {
        _rightImageView = NewObject(UIImageView);
        _rightImageView.frame = rect;
        _rightImageView.image = [UIImage imageNamed:@"arrow_more"];
        [self addSubview:_rightImageView];
    }else
    {
        _rightImageView.frame = rect;
    }
    
    rect.size.width = 42.0f;
    rect.origin.x -= (rect.size.width + 5.0f);
    if ( _nameLabel == nil )
    {
        _nameLabel = NewObject(UILabel);
        _nameLabel.text = @"去认证";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13.0f];
        _nameLabel.frame= rect;
        _nameLabel.textColor = kHEXCOLOR(kRedColor);
        [self addSubview:_nameLabel];
    }else
    {
        _nameLabel.frame = rect;
    }
    
    rect.size.width = frame.size.height - rect.origin.x - 12.0f;
    rect.origin.x = 12.0f;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.text = @"尚未设置实名认证无法使用余额和嗨币支付";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.frame= rect;
        _titleLabel.textColor = kHEXCOLOR(0x656565);
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    
}

-(void)setMenuMsgDict:(NSMutableDictionary *)MenuMsgDict
          bHiddenLine:(BOOL)bhidden
{
    if ( _nameLabel )
    {
        _nameLabel.text = [MenuMsgDict HYValueForKey:@"payName"];
    }
    if ( _titleLabel )
    {
        _titleLabel.text = [MenuMsgDict HYValueForKey:@"payTitle"];
    }
}

@end

/*******************HYPlaceTheOrderView**********************/
#pragma mark HYPlaceTheOrderView
@interface HYPlaceTheOrderView()<HYPayBaseCellViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray      *_ayTableViewData;
    UITableView         *_ptableView;
}

@end

@implementation HYPlaceTheOrderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if ( _ayTableViewData == nil ) {
            _ayTableViewData = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void)dealloc
{
    _ayTableViewData = nil;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    if (_ptableView == nil)
    {
        _ptableView = NewObject(UITableView);
        _ptableView.showsVerticalScrollIndicator = NO;
        _ptableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ptableView.frame = rect;
        _ptableView.delegate = self;
        _ptableView.dataSource = self;
        _ptableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_ptableView];
    }
    else
    {
        _ptableView.frame = rect;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * pDict = [_ayTableViewData HYNSDictionaryObjectAtIndex:indexPath.row];
    if (pDict && [[pDict HYValueForKey:@"cell"] isEqualToString:@"HMJSpaceCell"])
    {
        return 10;
    }
    
    if (pDict && [[pDict HYValueForKey:@"cell"] isEqualToString:@"HYPayTopUITableViewCell"])
    {
        return GGOrderTopHeight;
    }
    
    if (pDict && [[pDict HYValueForKey:@"cell"] isEqualToString:@"HYPayWayUITableViewCell"])
    {
        return 35.0f;
    }
    
    if (pDict && [[pDict HYValueForKey:@"cell"] isEqualToString:@"HYPayGoUITableViewCell"])
    {
        return 35.0f;
    }
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *itemCell = nil;
    
    if (indexPath.row < [_ayTableViewData count])
    {
        NSMutableDictionary * pDict = [_ayTableViewData HYNSDictionaryObjectAtIndex:indexPath.row];
        //top
        if ([[pDict HYValueForKey:@"cell"] isEqualToString:@"HYPayTopUITableViewCell"])
        {
            static NSString * strOderCellIdentifier  = @"HYPayTopUITableViewCell";
            HYPayTopUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
            if (cell == nil)
            {
                cell = [[HYPayTopUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            
            
            if (pDict && [pDict count] > 0 && cell)
            {
                [(HYPayTopUITableViewCell *)cell setMenuMsgDict:pDict bHiddenLine:NO];
            }
            
            itemCell = cell;
        }
        else if ([[pDict HYValueForKey:@"cell"] isEqualToString:@"HYPayWayUITableViewCell"])
        {
            static NSString * strOderCellIdentifier  = @"HYPayWayUITableViewCell";
            HYPayWayUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
            if (cell == nil)
            {
                cell = [[HYPayWayUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            
            if (pDict && [pDict count] > 0 && cell)
            {
                [cell setFrame:cell.frame];
                
                [(HYPayWayUITableViewCell *)cell setMenuMsgDict:pDict bHiddenLine:YES];
            }
            
            itemCell = cell;
        }

        //分割线
        else if ([[pDict HYValueForKey:@"cell"] isEqualToString:@"HMJSpaceCell"])
        {
            static NSString * strSpaceCellIdentifier  = @"HMJSpaceCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strSpaceCellIdentifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strSpaceCellIdentifier ];
                cell.backgroundColor = [UIColor redColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            itemCell = cell;
        }
        //去实名认证
        else if ([[pDict HYValueForKey:@"cell"] isEqualToString:@"HYPayGoUITableViewCell"])
        {
            static NSString * strOderCellIdentifier  = @"HYPayGoUITableViewCell";
            HYPayGoUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
            if (cell == nil)
            {
                cell = [[HYPayGoUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            
            if (pDict && [pDict count] > 0 && cell)
            {
                
                [(HYPayGoUITableViewCell *)cell setMenuMsgDict:pDict bHiddenLine:YES];
            }
            
            itemCell = cell;
        }
    }
    
    return itemCell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_ayTableViewData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)setMessageArr:(NSMutableArray *)MesArr
{
    if ( _ayTableViewData == nil )
    {
        _ayTableViewData = [[NSMutableArray alloc] init];
    }else
    {
        [_ayTableViewData removeAllObjects];
    }
    [_ayTableViewData addObjectsFromArray:MesArr];
    [_ptableView reloadData];
}
@end
