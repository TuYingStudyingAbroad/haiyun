//
//  YLOrderDetailView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/17.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLOrderDetailView.h"
#import "MKRegionModel.h"
#import <UIImageView+WebCache.h>
#import "MKBaseItemObject.h"
#import "MKServiceTableViewController.h"
#import "HasDetailViewController.h"
#import "Appdelegate.h"
#import "HYNavigationController.h"
#import "MKItemDetailViewController.h"
#import "HSafterSalesController.h"
#import "MKDeliveryInfo.h"
#import "QYSDK.h"
#import "QYCommodityInfo.h"
#import "QYSource.h"
/**************baseCell*********************/
@interface YLUIBaseCellView ()
{
    
}
@end
@implementation YLUIBaseCellView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}
-(void)setMenuMsgDict:(id)MenuMsgDict
          bHiddenLine:(BOOL)bhidden{}
@end

#pragma mark cell顶部
//****************Cell***************************

@interface YLOrderStatusTopUITableViewCell()
{
    /**
     *  订单状态
     */
    UILabel                             *_orderStateLabel;
    UILabel                             *_orderTitleLabel;
    /**
     *  时间
     */
    UILabel                             *_timeLabel;
   
    
    NSTimer                             *_timer;
    
    NSInteger                           _timesLimt;
    
    MKOrderObject                       *_orders;
    
    UIImageView                         *_rightImageView;
    UIImageView                         *_nextImageView;
}



@end

@implementation YLOrderStatusTopUITableViewCell


-(void)removeFromSuperview
{
    [_timer invalidate];
    _timer = nil;
    [super removeFromSuperview];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = kHEXCOLOR(0xfc2642);
    CGRect rect = CGRectMake(30.0f, 20.0f, frame.size.width, 18.0f);
    rect.size.width = frame.size.width - 4*rect.origin.x;
    if ( _orderStateLabel == nil )
    {
        _orderStateLabel = NewObject(UILabel);
        _orderStateLabel.backgroundColor = [UIColor clearColor];
        _orderStateLabel.font = [UIFont systemFontOfSize:18.0f];
        _orderStateLabel.textColor = [UIColor whiteColor];
        _orderStateLabel.textAlignment = NSTextAlignmentLeft;
        _orderStateLabel.frame = rect;
        [self addSubview:_orderStateLabel];
    }else
    {
        _orderStateLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height + 10.0f;
    rect.size.width =  GetWidthOfString(@"99:59:59",rect.size.height,[UIFont systemFontOfSize:18.0f]);
    rect.size.height = 18.0f;
    if ( _timeLabel == nil )
    {
        _timeLabel = NewObject(UILabel);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:18.0f];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.hidden = YES;
        _timeLabel.frame = rect;
        [self addSubview:_timeLabel];
    }else
    {
        _timeLabel.frame = rect;
    }
    if ( _orders && [_orders ourOrderStatus] == 0 )
    {
        _timeLabel.hidden = NO;
        rect.origin.x += rect.size.width+3.0f;
    }
    else
    {
        _timeLabel.hidden = YES;
        rect.origin.x = 30.0f;
    }
    rect.size.width = frame.size.width - 130.0f;
    if ( _orderTitleLabel == nil )
    {
        _orderTitleLabel = NewObject(UILabel);
        _orderTitleLabel.backgroundColor = [UIColor clearColor];
        _orderTitleLabel.font = [UIFont systemFontOfSize:13.0f];
        _orderTitleLabel.textColor = kHEXCOLOR(0xfebdc2);
        _orderTitleLabel.textAlignment = NSTextAlignmentLeft;
        _orderTitleLabel.frame = rect;
        [self addSubview:_orderTitleLabel];
    }else
    {
        _orderTitleLabel.frame = rect;
    }
    rect.size.width = 40.0f;
    rect.size.height = 40.0f;
    rect.origin.x = frame.size.width - 30.0f - rect.size.width;
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    if ( _rightImageView == nil )
    {
        _rightImageView = NewObject(UIImageView);
        _rightImageView.frame = rect;
        _rightImageView.contentMode = UIViewContentModeCenter;
        _rightImageView.hidden = YES;
        [self addSubview:_rightImageView];
    }else
    {
        _rightImageView.frame = rect;
    }
    rect.size.width = 6.0f;
    rect.size.height = 12.0f;
    rect.origin.x = frame.size.width - 12.0f - rect.size.width;
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    if ( _nextImageView == nil )
    {
        _nextImageView = NewObject(UIImageView);
        _nextImageView.frame = rect;
        _nextImageView.hidden = YES;
        _nextImageView.image = [UIImage imageNamed:@"xiangqingye-qiehuan"];
        [self addSubview:_nextImageView];
    }else
    {
        _nextImageView.frame = rect;
    }
}


#pragma mark -更新数据
-(void)setMenuMsgDict:(id )MenuMsgDict bHiddenLine:(BOOL)bhidden
{
    _orders = (MKOrderObject *)MenuMsgDict;
    if ( _orders )
    {
        if ( _timer )
        {
            [_timer invalidate];
            _timer = nil;
        }
        _timeLabel.hidden = YES;
        _nextImageView.hidden = YES;
        _rightImageView.hidden = YES;
        if ( [_orders ourOrderStatus] == 0 )//未支付
        {
            _orderStateLabel.text = @"等待付款";
            _orderTitleLabel.text = @"后自动取消";
            _timeLabel.hidden = NO;
            _rightImageView.image = [UIImage imageNamed:@"daifukuan-zhuangtai"];
            _rightImageView.hidden = NO;
            if ( _orders.payTimeout > 0 )
            {
                [_timer invalidate];
                _timer = nil;
                _timesLimt = _orders.payTimeout;
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimeChange:) userInfo:HYNSStringChangeToDate(_orders.cancelOrderTime) repeats:YES];
                [self setTimeChange:_timer];
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            }
        }
        else if (  [_orders ourOrderStatus] == 1  )/**< 已支付 待放货*/
        {
            _orderStateLabel.text = @"等待发货";
            _orderTitleLabel.text = @"此商品正准备发货，请稍等";
            _timeLabel.hidden = NO;
            _rightImageView.image = [UIImage imageNamed:@"daifahuo-zhuangtai"];
            _rightImageView.hidden = NO;

        }
        else if ( [_orders ourOrderStatus] == 2 )//待收货
        {
            _orderStateLabel.text = @"等待收货";
            _orderTitleLabel.text = @"物流信息";
            _timeLabel.hidden = NO;
            _nextImageView.hidden = NO;
        }
        else if ( [_orders ourOrderStatus] == 3 )/**< 已取消*/
        {
            _orderStateLabel.text = @"已取消";
            _orderTitleLabel.text = @"订单已取消";
            _timeLabel.hidden = NO;
            _rightImageView.image = [UIImage imageNamed:@"yiquxiao-zhuangtai"];
            _rightImageView.hidden = NO;

        }
        else if ( [_orders ourOrderStatus] == 4 )/**< 已关闭*/
        {
            _orderStateLabel.text = @"已关闭";
            _orderTitleLabel.text = @"商品维权成功，订单关闭";
            _timeLabel.hidden = NO;
            _rightImageView.image = [UIImage imageNamed:@"yiguanbi-zhuangtai"];
            _rightImageView.hidden = NO;
        }
        else if ( [_orders ourOrderStatus] == 5 )/**< 已完成*/
        {
            _orderStateLabel.text = @"交易完成";
            _orderTitleLabel.text = @"物流信息";
            _timeLabel.hidden = NO;
            _nextImageView.hidden = NO;
        }
        
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
        _timeLabel.hidden = YES;
        if ( self.delegate && [self.delegate respondsToSelector:@selector(onButtonCellView:Type:)])
        {
            [self.delegate onButtonCellView:self Type:3];//取消订单
        }
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
        _timeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hourTStr,minuteStr,secondStr];
        _timeLabel.hidden = NO;
    }
}

@end

#pragma mark cell地址

@interface YLOrderStatusAddressUITableViewCell()
{
    UIImageView         *_addressImageView;
    UILabel             *_nameLabel;//姓名电话
    UILabel             *_addressLabel;//地址
    UILabel             *_cardLabel;//身份证号码
    NSString            *_address;
}



@end

@implementation YLOrderStatusAddressUITableViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        _address = @"";
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect  rect = CGRectMake(12.0f, 15.0f, 20.0f, 20.0f);
    if ( _addressImageView == nil )
    {
        _addressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HYdizhiguanli"]];
        _addressImageView.frame = rect;
        [self addSubview:_addressImageView];
    }else
    {
        _addressImageView.frame = rect;
    }
    rect.origin.x += rect.size.width + 8.0f;
    rect.origin.y -= 3.0f;
    rect.size.width = frame.size.width - rect.origin.x - 12.0f;
    rect.size.height = 18.0f;
    if ( _nameLabel == nil )
    {
        _nameLabel = NewObject(UILabel);
        _nameLabel.textColor = kHEXCOLOR(0x252525);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.frame = rect;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_nameLabel];
    }else
    {
        _nameLabel.frame = rect;
    }
    rect.origin.y += rect.size.height;
    rect.size.height = GetHeightOfString(_address,rect.size.width,[UIFont systemFontOfSize:12.0f]) > 18.0f?GetHeightOfString(_address,rect.size.width,[UIFont systemFontOfSize:12.0f]):18.0f;
    if ( _addressLabel == nil )
    {
        _addressLabel = NewObject(UILabel);
        _addressLabel.textColor = kHEXCOLOR(0x252525);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.frame = rect;
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.font = [UIFont systemFontOfSize:12.0f];
        _addressLabel.numberOfLines = 0;
        [self addSubview:_addressLabel];
    }else
    {
        _addressLabel.frame = rect;
    }
    rect.origin.y += rect.size.height;
    rect.size.height = 18.0f;
    if ( _cardLabel == nil )
    {
        _cardLabel = NewObject(UILabel);
        _cardLabel.textColor = kHEXCOLOR(0x252525);
        _cardLabel.textAlignment = NSTextAlignmentLeft;
        _cardLabel.frame = rect;
        _cardLabel.backgroundColor = [UIColor clearColor];
        _cardLabel.font = [UIFont systemFontOfSize:12.0f];
        _cardLabel.hidden = YES;
        [self addSubview:_cardLabel];
    }else
    {
        _cardLabel.frame = rect;
    }
}

-(void)setMenuMsgDict:(id)MenuMsgDict bHiddenLine:(BOOL)bhidden
{
    
    MKConsigneeObject *consignee = (MKConsigneeObject *)MenuMsgDict;
    if ( _nameLabel )
    {
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",consignee.consignee,consignee.mobile];
    }
    if ( _cardLabel  && ISNSStringValid(consignee.idNo) )
    {
        _cardLabel.hidden = NO;
        NSString *cardStr = @"";
        NSString *strPad = @"**************************************";
        NSString *cardStr1 = [consignee.idNo stringByReplacingCharactersInRange:NSMakeRange(1, consignee.idNo.length-2) withString:[strPad substringWithRange:NSMakeRange(0,consignee.idNo.length-2)]];
        cardStr = [NSString stringWithFormat:@"身份证：%@",cardStr1];
        _cardLabel.text = cardStr;
    }else
    {
        _cardLabel.hidden = YES;
    }
    if ( _addressLabel )
    {
        _address = [NSString stringWithFormat:@"%@%@",consignee.addresses,consignee.address];
        _addressLabel.text = _address;
    }
}
@end

#pragma mark cell店铺名字
/****cell店铺名字****/
@interface YLOrderStatusShipNameUITableViewCell ()
{
    UIImageView         *_shipImageView;
    UILabel             *_nameLabel;
    UIView              *_lineView;
}

@end

@implementation YLOrderStatusShipNameUITableViewCell



-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect  rect = CGRectMake(12.0f, 0.0f, 20.0f, 20.0f);
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    if ( _shipImageView == nil )
    {
        _shipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dianpu"]];
        _shipImageView.frame = rect;
        [self addSubview:_shipImageView];
    }else
    {
        _shipImageView.frame = rect;
    }
    rect.origin.x += rect.size.width + 8.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    if ( _nameLabel == nil )
    {
        _nameLabel = NewObject(UILabel);
        _nameLabel.textColor = kHEXCOLOR(0x252525);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.frame = rect;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_nameLabel];
    }else
    {
        _nameLabel.frame = rect;
    }
    
    rect.origin.x = 12.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 1.0f;
    rect.origin.y = frame.size.height - rect.size.height;
    if ( _lineView == nil )
    {
        _lineView = NewObject(UIView);
        _lineView.backgroundColor = kHEXCOLOR(0xe5e5e5);
        _lineView.frame = rect;
        [self addSubview:_lineView];
    }else
    {
        _lineView.frame = rect;
    }
    
}

-(void)setMenuMsgDict:(id)MenuMsgDict bHiddenLine:(BOOL)bhidden
{
    if ( _nameLabel  && ISNSStringValid(MenuMsgDict) )
    {
        _nameLabel.text = MenuMsgDict;
    }
}


@end

#pragma mark cell商品
/****cell商品****/
@interface YLOrderStatusShipUITableViewCell ()
{
    UIImageView         *_shipImageView;//图片
    UILabel             *_nameLabel;//名字
    UILabel             *_priceLabel;//价格
    UILabel             *_numLabel; //数量
    UILabel             *_skuLabel; //SKU
    UILabel             *_activityLabel;
    UIView              *_lineView;
    
    UILabel             *_statusLabel;//售后状态
    UIButton            *_saleBtn;//申请售后
    
    UIImageView         *_tagImageView;
    
    MKOrderItemObject   *_orderItem;
    MKOrderObject       *_order;
    NSString            *_nameStr;//商品名称
    NSString            *_activityStr;//活动名称
}

@end

@implementation YLOrderStatusShipUITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        _nameStr = @"";
        _activityStr = @"";
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect  rect = CGRectMake(12.0f, 10.0f, 70.0f, 70.0f);
    if ( _shipImageView == nil )
    {
        _shipImageView = NewObject(UIImageView);
        _shipImageView.frame = rect;
        _shipImageView.image = [UIImage imageNamed:@"placeholder_60x60"];
        [self addSubview:_shipImageView];
    }
    else
    {
        _shipImageView.frame = rect;
    }
    
    if ( _tagImageView == nil )
    {
        _tagImageView = NewObject(UIImageView);
        _tagImageView.frame = CGRectMake(12.0f, 10.0f, 30.0f, 15.0f);
        _tagImageView.image = [UIImage imageNamed:@"kuajingbiaoqian"];
        _tagImageView.hidden = YES;
        [self addSubview:_tagImageView];
    }
    else
    {
        _tagImageView.frame = CGRectMake(12.0f, 10.0f, 30.0f, 15.0f);
    }
    
    rect.size.width = 60.0f;
    rect.origin.x = frame.size.width - rect.size.width - 12.0f;
    rect.size.height = 18.0f;
    if ( _priceLabel == nil )
    {
        _priceLabel = NewObject(UILabel);
        _priceLabel.frame = rect;
        _priceLabel.textColor = kHEXCOLOR(kRedColor);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_priceLabel];
    }else
    {
        _priceLabel.frame = rect;
    }
    
    rect.size.width = frame.size.width - _priceLabel.frame.size.width - _shipImageView.frame.origin.x - 20.0f- _shipImageView.frame.size.width;
    rect.origin.x = _shipImageView.frame.origin.x + 8.0f+_shipImageView.frame.size.width;
    rect.size.height = GetHeightOfString(_nameStr,rect.size.width,[UIFont systemFontOfSize:12.0f]) > 16.0f?GetHeightOfString(_nameStr,rect.size.width,[UIFont systemFontOfSize:12.0f]):16.0f;
    rect.size.height = rect.size.height>32.0f?32.0f:rect.size.height;
    if ( _nameLabel == nil )
    {
        _nameLabel = NewObject(UILabel);
        _nameLabel.textColor = kHEXCOLOR(0x252525);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        _nameLabel.numberOfLines = 2;
        _nameLabel.frame = rect;
        [self addSubview:_nameLabel];
    }else
    {
        _nameLabel.frame = rect;
    }
    
    rect.size.height = 16.0f;
    if ( ISNSStringValid(_activityStr) )
    {
        rect.origin.y = _shipImageView.frame.origin.y+_shipImageView.frame.size.height/2.0f - rect.size.height/2.0f;
        rect.origin.y += (_nameLabel.frame.size.height>=28.0f?5.0f:0);
    }else
    {
        rect.origin.y = _shipImageView.frame.origin.y+_shipImageView.frame.size.height - rect.size.height;
    }
    if ( _skuLabel == nil )
    {
        _skuLabel = NewObject(UILabel);
        _skuLabel.frame = rect;
        _skuLabel.textColor = kHEXCOLOR(0x999999);
        _skuLabel.textAlignment = NSTextAlignmentLeft;
        _skuLabel.backgroundColor = [UIColor clearColor];
        _skuLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_skuLabel];
    }else
    {
        _skuLabel.frame = rect;
    }
    
    rect.origin.y = _shipImageView.frame.origin.y+_shipImageView.frame.size.height;
    rect.size.height = 16.0f;
    rect.size.width = GetWidthOfString(_activityStr,rect.size.height,[UIFont systemFontOfSize:10.0f]);
    rect.size.width += 6.0f;
    rect.origin.y -= rect.size.height;
    if ( _activityLabel == nil )
    {
        _activityLabel = NewObject(UILabel);
        _activityLabel.textColor = [UIColor whiteColor];
        _activityLabel.backgroundColor = kHEXCOLOR(kRedColor);
        _activityLabel.font = [UIFont systemFontOfSize:10.0f];
        _activityLabel.frame = rect;
        _activityLabel.layer.cornerRadius = 3.0f;
        _activityLabel.layer.masksToBounds = YES;
        _activityLabel.textAlignment = NSTextAlignmentCenter;
        _activityLabel.hidden = YES;
        [self addSubview:_activityLabel];
    }else
    {
        _activityLabel.frame = rect;
    }

    
    rect.origin.x = _priceLabel.frame.origin.x;
    rect.size.width = _priceLabel.frame.size.width;
    rect.origin.y = _priceLabel.frame.origin.y + _priceLabel.frame.size.height+3.0f;
    rect.size.height = _priceLabel.frame.size.height;
    if ( _numLabel == nil )
    {
        _numLabel = NewObject(UILabel);
        _numLabel.frame = rect;
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.textColor = kHEXCOLOR(0x999999);
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_numLabel];
    }else
    {
        _numLabel.frame = rect;
    }
    
    rect.size.height = 22.0f;
    rect.origin.y = frame.size.height - 20.0f - rect.size.height;
    rect.size.width = 60.0f;
    rect.origin.x = frame.size.width - rect.size.width - 12.0f;
    if ( _saleBtn == nil)
    {
        _saleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saleBtn setTitle:@"申请售后" forState:UIControlStateNormal];
        [_saleBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
        _saleBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _saleBtn.layer.cornerRadius = 3.0;
        _saleBtn.layer.masksToBounds = YES;
        _saleBtn.layer.borderColor = kHEXCOLOR(0x999999).CGColor;
        _saleBtn.layer.borderWidth = 0.5f;
        _saleBtn.backgroundColor = [UIColor whiteColor];
        [_saleBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        _saleBtn.hidden = NO;
        _saleBtn.frame = rect;
        [self addSubview:_saleBtn];
    }
    else
    {
        _saleBtn.frame = rect;
    }

    rect.origin.y = _numLabel.frame.origin.y + _numLabel.frame.size.height + 3.0f;
    rect.size.height = 18.0f;
    if ( _statusLabel == nil )
    {
        _statusLabel = NewObject(UILabel);
        _statusLabel.frame = rect;
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = kHEXCOLOR(kRedColor);
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:11.0f];
        _statusLabel.text = @"售后状态";
        [self addSubview:_statusLabel];
    }else
    {
        _statusLabel.frame = rect;
    }
    
    rect.origin.x = 0.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 1.0f;
    rect.origin.y = frame.size.height - rect.size.height;
    if ( _lineView == nil )
    {
        _lineView = NewObject(UIView);
        _lineView.backgroundColor = kHEXCOLOR(0xf5f5f5);
        _lineView.frame = rect;
        [self addSubview:_lineView];
    }else
    {
        _lineView.frame = rect;
    }
    
    [self bringSubviewToFront:_saleBtn];
}

-(void)setMenuMsgDict:(id)MenuMsgDict setOrderObject:(id)orderObject tag:(NSString *)activityTags hide:(BOOL)hides
{
    if ( MenuMsgDict )
    {
        
        _orderItem  = MenuMsgDict;
        _order = orderObject;
        if ( _shipImageView )
        {
            [_shipImageView sd_setImageWithURL:[NSURL URLWithString:_orderItem.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
        }
        if ( _nameLabel )
        {
            _nameStr = _orderItem.itemName;
            _nameLabel.text = _orderItem.itemName;
        }
        if ( _priceLabel )
        {
            _priceLabel.text = [NSString stringWithFormat:@"¥%@",[MKBaseItemObject priceString:_orderItem.price]];
            [_priceLabel HYPriceChangeFont:9.0f colors:kHEXCOLOR(kRedColor) isTop:YES];
        }
        if ( _skuLabel ) {
            _skuLabel.text =  _orderItem.skuSnapshot;
        }
        if ( _numLabel ) {
            _numLabel.text = [NSString stringWithFormat:@"x%ld",(long)_orderItem.number];
        }
        if( _saleBtn )
        {
            _saleBtn.hidden = ![self saleBtnIsHide];
            if ( [_order ourOrderStatus] == 1  )//待发货
            {
                [_saleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            }
            else if ( [_order ourOrderStatus] == 2 )//待收货
            {
                [_saleBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            }
            else if ( [_order ourOrderStatus] == 5 )//已完成
            {
                [_saleBtn setTitle:@"申请售后" forState:UIControlStateNormal];
            }
        }
        if ( _statusLabel )
        {
            if ( _order.orderStatus <= 40 )
            {
                _statusLabel.text = [MKOrderItemObject refundStatusWithString:_orderItem.refundStatus];
            }
            if (_order.orderStatus > 40 )
            {
                _statusLabel.text = [MKOrderItemObject afterSaleStatusWithString:_orderItem.refundStatus];
            }
        }
        if ( _tagImageView )
        {
            if ( _orderItem.higoMark )
            {
                _tagImageView.hidden = NO;
            }
            else
            {
                _tagImageView.hidden = YES;
            }
        }
        if ( _activityLabel )
        {
            if ( ISNSStringValid(activityTags) )
            {
                _activityStr = activityTags;
            }
            else
            {
                _activityStr = [self textactivityLabel:_orderItem.itemTypeOne];
            }
//            _activityStr = @"活动";
            _activityLabel.hidden = !ISNSStringValid(_activityStr);
            _activityLabel.text = _activityStr;
        }
        if ( _lineView )
        {
            _lineView.hidden = hides;
        }
    }
}
#pragma mark -商品中的标签
-(NSString *)textactivityLabel:(NSInteger)types
{
    NSString   *activitys = @"";
    switch (types)
    {
        case 14:
        {
            activitys = @"团购";
        }
            break;
        case 13:
        {
            activitys = @"秒杀";
        }
            break;
        default:
            break;
    }
    return activitys;
}
-(void)OnButton:(id)sender
{
    if (  sender == _saleBtn )
    {
        //跳转售后
        if (_order.orderStatus == MKOrderStatusPaid
            || _order.orderStatus == MKOrderStatusDelivery )
        {
            //已支付
            HasDetailViewController *re = [HasDetailViewController create];
            re.order = _order;
            re.orderUid = _order.orderUid;
            if (_orderItem ) {
                re.itemObject =_orderItem;
            }
            re.tString = @"仅退款";
            [getMainTabBar.selectedNav pushViewController:re animated:YES];
            return;
        }
        if ( _order.orderStatus >= MKOrderStatusDeliveried
            && _order.orderStatus <MKOrderStatusRefundApply )
        {
            //        已签收
            MKServiceTableViewController *serviceTableView = [MKServiceTableViewController create];
            serviceTableView.order = _order;
            serviceTableView.orderUid = _order.orderUid;
            if (_orderItem) {
                serviceTableView.itemObject = _orderItem;
            }
            [getMainTabBar.selectedNav pushViewController:serviceTableView animated:YES];
        }
    }
}
#pragma mark -是否可以显示申请售后
/**
 *  是否可以显示申请售后
 *
 *  @return YES 能显示 NO不能显示
 */
-(BOOL)saleBtnIsHide
{
    if ( _order && _orderItem )
    {
        if ( _orderItem.canRefundMark && (_order.orderStatus == MKOrderStatusPaid || _order.orderStatus == MKOrderStatusDelivery  || (_order.orderStatus >= MKOrderStatusDeliveried && _order.orderStatus <MKOrderStatusRefundApply ) ) )
        {
            return YES;
        }
    }
    return NO;
}
@end

/****cell优惠券信息****/
#pragma mark cell优惠券信息
@interface YLOrderStatusOtherUITableViewCell ()
{
    /**
     *  0
     */
    UILabel             *_leftLabel;
    UILabel             *_rightLabel;
    /**
     *  1
     */
    UILabel             *_left1Label;
    UILabel             *_right1Label;
    /**
     *  2
     */
    UILabel             *_left2Label;
    UILabel             *_right2Label;
    /**
     *  3
     */
    UILabel             *_left3Label;
    UILabel             *_right3Label;
    
    /**
     *  4
     */
    UILabel             *_left4Label;
    UILabel             *_right4Label;
}

@end

@implementation YLOrderStatusOtherUITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {

    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = CGRectMake(12.0f, 10.0f, frame.size.width, 18.0f);
    rect.size.width = (frame.size.width - 2*rect.origin.x)*2/3.0f;
    if ( _leftLabel == nil )
    {
        _leftLabel = NewObject(UILabel);
        _leftLabel.frame = rect;
        _leftLabel.textColor = kHEXCOLOR(0x999999);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.font = [UIFont systemFontOfSize:12.0f];
        _leftLabel.text = @"运费：";
        [self addSubview:_leftLabel];
    }else
    {
        _leftLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height +1.0f;
    if ( _left1Label == nil )
    {
        _left1Label = NewObject(UILabel);
        _left1Label.frame = rect;
        _left1Label.textColor = kHEXCOLOR(0x999999);
        _left1Label.textAlignment = NSTextAlignmentLeft;
        _left1Label.backgroundColor = [UIColor clearColor];
        _left1Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_left1Label];
    }else
    {
        _left1Label.frame = rect;
    }
    
    rect.origin.y += rect.size.height +1.0f;
    if ( _left2Label == nil )
    {
        _left2Label = NewObject(UILabel);
        _left2Label.frame = rect;
        _left2Label.textColor = kHEXCOLOR(0x999999);
        _left2Label.textAlignment = NSTextAlignmentLeft;
        _left2Label.backgroundColor = [UIColor clearColor];
        _left2Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_left2Label];
    }else
    {
        _left2Label.frame = rect;
    }
    
    rect.origin.y += rect.size.height +1.0f;
    if ( _left3Label == nil )
    {
        _left3Label = NewObject(UILabel);
        _left3Label.frame = rect;
        _left3Label.textColor = kHEXCOLOR(0x999999);
        _left3Label.textAlignment = NSTextAlignmentLeft;
        _left3Label.backgroundColor = [UIColor clearColor];
        _left3Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_left3Label];
    }else
    {
        _left3Label.frame = rect;
    }
    
    rect.origin.y += rect.size.height +1.0f;
    if ( _left4Label == nil )
    {
        _left4Label = NewObject(UILabel);
        _left4Label.frame = rect;
        _left4Label.textColor = kHEXCOLOR(0x999999);
        _left4Label.textAlignment = NSTextAlignmentLeft;
        _left4Label.backgroundColor = [UIColor clearColor];
        _left4Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_left4Label];
    }else
    {
        _left4Label.frame = rect;
    }
    
    
    rect.origin.y = _leftLabel.frame.origin.y;
    rect.size.width = (frame.size.width - 2*rect.origin.x)/3.0f;
    rect.origin.x = frame.size.width - rect.size.width - 12.0f;
    if ( _rightLabel == nil )
    {
        _rightLabel = NewObject(UILabel);
        _rightLabel.frame = rect;
        _rightLabel.textColor = kHEXCOLOR(0x252525);
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_rightLabel];
    }else
    {
        _rightLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height +1.0f;
    if ( _right1Label == nil )
    {
        _right1Label = NewObject(UILabel);
        _right1Label.frame = rect;
        _right1Label.textColor = kHEXCOLOR(0x252525);
        _right1Label.textAlignment = NSTextAlignmentRight;
        _right1Label.backgroundColor = [UIColor clearColor];
        _right1Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_right1Label];
    }else
    {
        _right1Label.frame = rect;
    }
    
    rect.origin.y += rect.size.height +1.0f;
    if ( _right2Label == nil )
    {
        _right2Label = NewObject(UILabel);
        _right2Label.frame = rect;
        _right2Label.textColor = kHEXCOLOR(0x252525);
        _right2Label.textAlignment = NSTextAlignmentRight;
        _right2Label.backgroundColor = [UIColor clearColor];
        _right2Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_right2Label];
    }else
    {
        _right2Label.frame = rect;
    }
    
    rect.origin.y += rect.size.height +1.0f;
    if ( _right3Label == nil )
    {
        _right3Label = NewObject(UILabel);
        _right3Label.frame = rect;
        _right3Label.textColor = kHEXCOLOR(0x252525);
        _right3Label.textAlignment = NSTextAlignmentRight;
        _right3Label.backgroundColor = [UIColor clearColor];
        _right3Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_right3Label];
    }else
    {
        _right3Label.frame = rect;
    }
    
    rect.origin.y += rect.size.height +1.0f;
    if ( _right4Label == nil )
    {
        _right4Label = NewObject(UILabel);
        _right4Label.frame = rect;
        _right4Label.textColor = kHEXCOLOR(0x252525);
        _right4Label.textAlignment = NSTextAlignmentRight;
        _right4Label.backgroundColor = [UIColor clearColor];
        _right4Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_right4Label];
    }else
    {
        _right4Label.frame = rect;
    }
}

-(void)setMenuMsgDict:(id)MenuMsgDict
{
    NSMutableDictionary *dict = (NSMutableDictionary *)MenuMsgDict;
    if ( dict )
    {
        _rightLabel.hidden = YES;
        _leftLabel.hidden = YES;
        _right1Label.hidden = YES;
        _left1Label.hidden = YES;
        _right2Label.hidden = YES;
        _left2Label.hidden = YES;
        _left3Label.hidden = YES;
        _right3Label.hidden = YES;
        _left4Label.hidden = YES;
        _right4Label.hidden = YES;
        NSArray *arrName = [dict objectForKey:@"left"];
        NSArray *arrRigh = [dict objectForKey:@"right"];
        for ( NSInteger i = 0; i< arrName.count; ++i  )
        {
            if ( i == 0 )
            {
                _rightLabel.hidden = NO;
                _leftLabel.hidden = NO;
                _leftLabel.text = [arrName objectAtIndex:i];
                if ( i<arrRigh.count ) {
                    _rightLabel.text = [arrRigh objectAtIndex:i];
                }
            }
            else if ( i == 1 )
            {
                _right1Label.hidden = NO;
                _left1Label.hidden = NO;
                _left1Label.text = [arrName objectAtIndex:i];
                if ( i<arrRigh.count ) {
                    _right1Label.text = [arrRigh objectAtIndex:i];
                }
            }
            else if ( i == 2 )
            {
                _right2Label.hidden = NO;
                _left2Label.hidden = NO;
                _left2Label.text = [arrName objectAtIndex:i];
                if ( i<arrRigh.count ) {
                    _right2Label.text = [arrRigh objectAtIndex:i];
                }
            }
            else if( i == 3 )
            {
                _right3Label.hidden = NO;
                _left3Label.hidden = NO;
                _left3Label.text = [arrName objectAtIndex:i];
                if ( i<arrRigh.count ) {
                    _right3Label.text = [arrRigh objectAtIndex:i];
                }

            }else
            {
                _right4Label.hidden = NO;
                _left4Label.hidden = NO;
                _left4Label.text = [arrName objectAtIndex:i];
                if ( i<arrRigh.count ) {
                    _right4Label.text = [arrRigh objectAtIndex:i];
                }
            }
        }
    }
}
@end

#pragma mark cell赠品
@interface YLOrderGiftTableViewCell ()
{
    UILabel             *_giftLabel;//赠品
    UIView              *_lineView; //高度31.0f
}

@end

@implementation YLOrderGiftTableViewCell

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect  rectGif = CGRectMake(12, 0, 0, 18.0f);
    rectGif.origin.y = (frame.size.height-1.0f - rectGif.size.height)/2.0f;
    rectGif.size.width = frame.size.width - 2*rectGif.origin.x;
    if ( _giftLabel == nil )
    {
        _giftLabel = NewObject(UILabel);
        _giftLabel.frame = rectGif;
        _giftLabel.textColor = kHEXCOLOR(0x999999);
        _giftLabel.textAlignment = NSTextAlignmentLeft;
        _giftLabel.backgroundColor = [UIColor clearColor];
        _giftLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_giftLabel];
    }else
    {
        _giftLabel.frame = rectGif;
    }
    rectGif.origin.y = frame.size.height -1.0f;
    rectGif.origin.x = 0;
    rectGif.size.width = frame.size.width;
    rectGif.size.height = 1.0f;
    if ( _lineView == nil )
    {
        _lineView = NewObject(UIView);
        _lineView.backgroundColor = kHEXCOLOR(0xe5e5e5);
        _lineView.frame = rectGif;
        [self addSubview:_lineView];
    }else
    {
        _lineView.hidden = NO;
        _lineView.frame = rectGif;
    }
    
}

-(void)setMenuMsgDict:(id)MenuMsgDict bHiddenLine:(BOOL)bhidden
{
    MKOrderItemObject *orderItems = (MKOrderItemObject *)MenuMsgDict;
    NSString *giftStr = [NSString stringWithFormat:@"赠：%@",orderItems.itemName];
    if ( _giftLabel )
    {
        _giftLabel.text = giftStr;
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:giftStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kHEXCOLOR(kRedColor) range:NSMakeRange(0,[@"赠" length])];
        _giftLabel.attributedText = attributedString;
    }
}

@end

/****cell时间****/
#pragma mark cell时间
@interface YLOrderStatusTimeUITableViewCell ()
{
    /**
     *  订单编号
     */
    UILabel                             *_codeLLabel;
    UILabel                             *_codeRLabel;
    UIButton                            *_copyBtn;
    /**
     *  0
     */
    UILabel             *_leftLabel;
    /**
     *  1
     */
    UILabel             *_left1Label;
    /**
     *  2
     */
    UILabel             *_left2Label;
    /**
     *  3
     */
    UILabel             *_left3Label;
    
}

@end

@implementation YLOrderStatusTimeUITableViewCell

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(12.0f, 10, frame.size.width, 18.0f);
    rect.size.width = GetWidthOfString(@"订单编号：",rect.size.height,[UIFont systemFontOfSize:12.0f]);
    if ( _codeLLabel == nil )
    {
        _codeLLabel = NewObject(UILabel);
        _codeLLabel.backgroundColor = [UIColor clearColor];
        _codeLLabel.font = [UIFont systemFontOfSize:12.0f];
        _codeLLabel.text = @"订单编号：";
        _codeLLabel.textColor = kHEXCOLOR(0x999999);
        _codeLLabel.textAlignment = NSTextAlignmentLeft;
        _codeLLabel.frame = rect;
        [self addSubview:_codeLLabel];
    }else
    {
        _codeLLabel.frame = rect;
    }
    
    
    rect.origin.x += rect.size.width;
    rect.size.width = frame.size.width - rect.origin.x - 46.0f;
    if ( _codeRLabel == nil )
    {
        _codeRLabel = NewObject(UILabel);
        _codeRLabel.backgroundColor = [UIColor clearColor];
        _codeRLabel.font = [UIFont systemFontOfSize:12.0f];
        _codeRLabel.textColor = kHEXCOLOR(0x252525);
        _codeRLabel.textAlignment = NSTextAlignmentLeft;
        _codeRLabel.frame = rect;
        [self addSubview:_codeRLabel];
    }else
    {
        _codeRLabel.frame = rect;
        
    }
    rect.size.width = 40.0f;
    rect.size.height = 20.0f;
    rect.origin.x = frame.size.width - rect.size.width - 6.0f;
    if ( _copyBtn == nil)
    {
        _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_copyBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
        _copyBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _copyBtn.frame = rect;
        _copyBtn.layer.cornerRadius = 3.0;
        _copyBtn.layer.masksToBounds = YES;
        _copyBtn.layer.borderColor = kHEXCOLOR(0x999999).CGColor;
        _copyBtn.layer.borderWidth = 0.5f;
        [_copyBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_copyBtn];
    }
    else
    {
        _copyBtn.frame = rect;
    }
    rect.size.height = 18.0f;
    rect.origin.x = 12.0f;
    rect.origin.y += rect.size.height+6.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    if ( _leftLabel == nil )
    {
        _leftLabel = NewObject(UILabel);
        _leftLabel.frame = rect;
        _leftLabel.textColor = kHEXCOLOR(0x999999);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_leftLabel];
    }else
    {
        _leftLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height +3.0f;
    if ( _left1Label == nil )
    {
        _left1Label = NewObject(UILabel);
        _left1Label.frame = rect;
        _left1Label.textColor = kHEXCOLOR(0x999999);
        _left1Label.textAlignment = NSTextAlignmentLeft;
        _left1Label.backgroundColor = [UIColor clearColor];
        _left1Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_left1Label];
    }else
    {
        _left1Label.frame = rect;
    }
    
    rect.origin.y += rect.size.height +3.0f;
    if ( _left2Label == nil )
    {
        _left2Label = NewObject(UILabel);
        _left2Label.frame = rect;
        _left2Label.textColor = kHEXCOLOR(0x999999);
        _left2Label.textAlignment = NSTextAlignmentLeft;
        _left2Label.backgroundColor = [UIColor clearColor];
        _left2Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_left2Label];
    }else
    {
        _left2Label.frame = rect;
    }
    rect.origin.y += rect.size.height +3.0f;
    if ( _left3Label == nil )
    {
        _left3Label = NewObject(UILabel);
        _left3Label.frame = rect;
        _left3Label.textColor = kHEXCOLOR(0x999999);
        _left3Label.textAlignment = NSTextAlignmentLeft;
        _left3Label.backgroundColor = [UIColor clearColor];
        _left3Label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_left3Label];
    }else
    {
        _left3Label.frame = rect;
    }
    [self bringSubviewToFront:_copyBtn];
}

-(void)setMenuMsgDict:(id)MenuMsgDict bHiddenLine:(BOOL)bhidden
{
    NSMutableArray *orderInf = (NSMutableArray *)MenuMsgDict;
    _leftLabel.hidden = YES;
    _left1Label.hidden = YES;
    _left2Label.hidden = YES;
    _left3Label.hidden = YES;
    if ( orderInf && orderInf.count > 0 )
    {
        for (int i = 0 ; i<orderInf.count; ++i )
        {
            if ( i == 0 )
            {
                _codeRLabel.text = [orderInf objectAtIndex:i];
            }
            else if ( i == 1 )
            {
                _leftLabel.hidden = NO;
                _leftLabel.text = [orderInf objectAtIndex:i];
            }
            else if ( i == 2 )
            {
                _left1Label.hidden = NO;
                _left1Label.text = [orderInf objectAtIndex:i];
            }
            else if ( i == 3 )
            {
                _left2Label.hidden = NO;
                _left2Label.text = [orderInf objectAtIndex:i];
            }
            else if ( i == 4 )
            {
                _left3Label.hidden = NO;
                _left3Label.text = [orderInf objectAtIndex:i];
            }
        }
    }
}
-(void)onButton:(id)sender
{
    if (sender == _copyBtn )
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string        = [NSString stringWithFormat:@"%@",_codeRLabel.text];
        [MBProgressHUD showMessageIsWait:@"订单编号复制成功！" wait:YES];
    }
}
@end

/****cell客服****/
#pragma mark cell客服
@interface HYOrderServiceUITableViewCell()
{
    UIImageView                 *_leftImageView;
    UIImageView                 *_rightImageView;
    UILabel                     *_leftLabel;
    
}

@end

@implementation HYOrderServiceUITableViewCell


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(12, 0, 20.0f, 15.0f);
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    if ( _leftImageView == nil)
    {
        _leftImageView = NewObject(UIImageView);
        _leftImageView.frame = rect;
        _leftImageView.image = [UIImage imageNamed:@"customer-service"];
        [self addSubview:_leftImageView];
    }
    else
    {
        _leftImageView.frame = rect;
    }
    
    rect.origin.x += rect.size.width + 7.5f;
    rect.size.width = 120.0f;
    if ( _leftLabel == nil )
    {
        _leftLabel = NewObject(UILabel);
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.font = [UIFont systemFontOfSize:14.0f];
        _leftLabel.textColor = kHEXCOLOR(0x252525);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.text = @"售后客服";
        [self addSubview:_leftLabel];
    }else
    {
        _leftLabel.frame = rect;
    }
    
    rect.size.height = 18.0f;
    rect.size.width = 18.0f;
    rect.origin.x = frame.size.width - rect.size.width - 12.0f;
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    if (_rightImageView  == nil)
    {
        _rightImageView = NewObject(UIImageView);
        _rightImageView.image = [UIImage imageNamed:@"qiehuan"];
        _rightImageView.frame = rect;
        [self addSubview:_rightImageView];
    }
    else
    {
        _rightImageView.frame = rect;
    }
    
    
}

@end

/*************************************************/
#pragma mark -底部处理，取消支付界面
@interface YLOrderBottomView ()
{
    UILabel             *_titleLabel;
//    UILabel             *_priceLabel;
    UIButton            *_rightBtn;
    UIButton            *_leftBtn;
    NSInteger           _orderStatus;
}


@end

@implementation YLOrderBottomView


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(12.0f, 0.0f, 120.0f, frame.size.height);
    
    rect.size.width = 78.0f;
    rect.size.height = 30.0f;
    rect.origin.x = frame.size.width - rect.size.width - 12.0f;
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    if ( _rightBtn == nil)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _rightBtn.frame = rect;
        _rightBtn.layer.cornerRadius = 3.0;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.backgroundColor = kHEXCOLOR(kRedColor);
        [_rightBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        _rightBtn.hidden = YES;
        [self addSubview:_rightBtn];
    }
    else
    {
        _rightBtn.frame = rect;
    }
    
    rect.origin.x -= rect.size.width + 12.0f;
    if ( _leftBtn == nil)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _leftBtn.frame = rect;
        _leftBtn.layer.cornerRadius = 3.0;
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.borderColor = kHEXCOLOR(0x999999).CGColor;
        _leftBtn.layer.borderWidth = 0.5f;
        _leftBtn.backgroundColor = [UIColor whiteColor];
        [_leftBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        _leftBtn.hidden = YES;
        [self addSubview:_leftBtn];
    }
    else
    {
        _leftBtn.frame = rect;
    }
    
    rect.origin.x = 12.0f;
    rect.origin.y = 0.0f;
    rect.size.width = frame.size.width - _leftBtn.frame.origin.x - 2*rect.origin.x;
    rect.size.height = frame.size.height;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.text = @"合计：";
        _titleLabel.textColor = kHEXCOLOR(0x999999);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.frame = rect;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.hidden = YES;
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
}
-(void)onButton:(id)sender
{
    NSInteger type = 100;
    if ( sender == _rightBtn )//
    {
        if( _orderStatus == 1 )//立即支付0
        {
            type = 0;
        }else if( _orderStatus == 0 )//确定收货1
        {
            type = 1;
        }
        else
        {
            type = 2;
        }
    }
    else if( sender == _leftBtn )//查看物流2
    {
        if ( _orderStatus == 1 )
        {
            type = 4;
        }
        else
        {
            type = 2;
        }
    }
    if ( _delegate && [_delegate respondsToSelector:@selector(onButtonBottomView:Type:)])
    {
        [_delegate onButtonBottomView:self Type:type];
    }
}
#pragma mark -底部处理 更改数据
-(void)setOrderBottomStatus:(NSInteger)orderStatus
                      price:(NSString *)prices
                        num:(NSInteger)nums
{
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    _titleLabel.hidden = YES;
    _orderStatus = orderStatus;
    if ( orderStatus == 1 )
    {
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        _titleLabel.hidden = NO;
        NSString *prices1 = [NSString stringWithFormat:@"¥%@",prices];
        _titleLabel.text = [NSString stringWithFormat:@"共%ld件，应付: ¥%@",nums,prices];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kHEXCOLOR(kRedColor) range:NSMakeRange([_titleLabel.text length]-[prices1 length],[prices1 length])];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0f] range:NSMakeRange([_titleLabel.text length]-[prices1 length],1)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0f] range:NSMakeRange([_titleLabel.text length]-2,2)];
        _titleLabel.attributedText = attributedString;
        _leftBtn.hidden = NO;
        [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }else if ( orderStatus == 0 )
    {
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//        _leftBtn.hidden = NO;
//        [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    }else if ( orderStatus == 2 )
    {
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    }
}

@end


/**订单详情***/
#pragma mark 订单详情界面
@interface YLOrderDetailView()<YLUIBaseCellViewDelegate,YLOrderBottomViewwDelegate>
{
    YLOrderBottomView       *_orderBottomView;
    NSMutableArray          *_statusTimeArr;
    NSMutableDictionary     *_statusDict;//优惠券xinx
    NSMutableArray          *_distributorOrderItem;//分销商信息
    NSMutableArray          *_orderGiftItem; //优惠的商品
    NSMutableDictionary     *_orderItemDict;//商品活动标签，key＝itemSkuId
    
}

@property (nonatomic) OrderStauts orderStauts;

@end

@implementation YLOrderDetailView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if ( _distributorOrderItem == nil )
        {
            _distributorOrderItem = [[NSMutableArray alloc] init];
        }
        if ( !_nsDict )
        {
            _nsDict = [[NSMutableDictionary alloc] init];
        }
        if ( !_statusDict )
        {
            _statusDict = [[NSMutableDictionary alloc] init];
        }
        if ( !_statusTimeArr )
        {
            _statusTimeArr = [[NSMutableArray alloc] init];
        }
        if (_orderItemDict == nil )
        {
            _orderItemDict = [[NSMutableDictionary alloc] init];
        }
        if ( _orderGiftItem == nil )
        {
            _orderGiftItem = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void)dealloc
{
    _statusDict = nil;
    _pTableView = nil;
    _statusTimeArr = nil;
    _distributorOrderItem = nil;
    _orderBottomView.delegate = nil;
    _orderBottomView = nil;
    _orderItemDict = nil;
    _orderGiftItem = nil;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    if (_pTableView == nil)
    {
        _pTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, Main_Screen_Height-70.0f) style:UITableViewStyleGrouped];
        _pTableView.backgroundColor = [UIColor clearColor];
        _pTableView.dataSource = self;
        _pTableView.delegate = self;
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_pTableView];
        
    }else
    {
        _pTableView.frame = CGRectMake(0, 0, frame.size.width, Main_Screen_Height-70.0f);
    }
    
    if ( _orderBottomView == nil )
    {
        _orderBottomView = NewObject(YLOrderBottomView);
        _orderBottomView.frame = CGRectMake(0,Main_Screen_Height-114.0f, frame.size.width, 50.0f);
        _orderBottomView.hidden = YES;
        _orderBottomView.delegate = self;
        [self addSubview:_orderBottomView];
    }else
    {
        _orderBottomView.frame = CGRectMake(0, Main_Screen_Height-114.0f, frame.size.width, 50.0f);
    }
    
}
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.order?(5+_distributorOrderItem.count+(_orderGiftItem.count>0?1:0)):0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.order )
    {
        if ( section >= 3 && section < _distributorOrderItem.count+3 )
        {
//            MKDistributorOrderItemList *obj = _distributorOrderItem[section-3];
//            return obj?obj.orderItemList.count:0;
            MKOrderItemObject *itemObj = _distributorOrderItem[section-3];
            return itemObj?1:0;
        }else
        {
            if ( section == _distributorOrderItem.count+3 )
            {
                return _orderGiftItem.count>0?_orderGiftItem.count:1;
            }
            return 1;
        }
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( indexPath.section == 0 )
    {
        return 80.0f;
    }
    if ( indexPath.section == 2 )
    {
        CGFloat heights = 40.0f;
        NSString *address = [NSString stringWithFormat:@"%@%@",self.order.consignee.addresses,self.order.consignee.address];

        heights += (GetHeightOfString(address,Main_Screen_Width-56.0f,[UIFont systemFontOfSize:12.0f]) > 20.0f?GetHeightOfString(address,Main_Screen_Width-56.0f,[UIFont systemFontOfSize:12.0f]):20.0f);
        if ( ISNSStringValid(self.order.consignee.idNo) )
        {
             heights += 18.0f;
        }
        return heights;
    }
    else if ( indexPath.section == 1 )
    {
        return 44.0f;
    }
    else if ( indexPath.section >= 3 && indexPath.section < _distributorOrderItem.count+3 )
    {
        NSInteger  canRefundMark = 0;
        if (  _distributorOrderItem.count > indexPath.section - 3  ) {
//            MKDistributorOrderItemList *obj = _distributorOrderItem[indexPath.section - 3];
//            if ( obj && obj.orderItemList.count > indexPath.row -1 )
//            {
//               MKOrderItemObject  *objc = obj.orderItemList[indexPath.row-1];
            MKOrderItemObject  *objc = _distributorOrderItem[indexPath.section - 3];
                if ( objc.canRefundMark && (self.order.orderStatus == MKOrderStatusPaid || self.order.orderStatus == MKOrderStatusDelivery  || (self.order.orderStatus >= MKOrderStatusDeliveried && self.order.orderStatus <MKOrderStatusRefundApply ) ) )
                {
                    canRefundMark = 1;
                }
//            }
        }
        return canRefundMark?110.0f:90.0f;
    }
    else if ( _orderGiftItem.count>0 && indexPath.section == _distributorOrderItem.count+3 )
    {
        return 31.0f;
    }
    else if ( indexPath.section == _distributorOrderItem.count+3 + (_orderGiftItem.count>0?1:0) )
    {
        CGFloat disHeights = 38.0f;
        if ( _statusDict && _statusDict.count > 0 )
        {
            if ( [_statusDict objectForKey:@"left"] )
            {
                return disHeights + ([[_statusDict objectForKey:@"left"] count]-1)*20.0f;
            }
        }
        return disHeights;
    }
    
    CGFloat heights = 40.0f;
    if ( _statusTimeArr && _statusTimeArr.count > 0 )
    {
        heights += 20*(_statusTimeArr.count -1);
    }
    return heights;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( self.order && ( section == 1
                        || section == 2
                        || section == 3
                        || section ==  4+_distributorOrderItem.count + (_orderGiftItem.count>0?1:0)
                        || section == 3+_distributorOrderItem.count + (_orderGiftItem.count>0?1:0))  ) {
        return 10.0f;
    }
    return 0.0001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (  section ==  4+_distributorOrderItem.count + (_orderGiftItem.count>0?1:0) )
    {
        return 50.0f;
    }
    return 0.0001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *itemCell = nil;
    
    if ( indexPath.section == 0 )
    {
        static NSString * strOderCellIdentifier  = @"YLOrderStatusTopUITableViewCell";
        YLOrderStatusTopUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
        if (cell == nil)
        {
            cell = [[YLOrderStatusTopUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
            cell.delegate = self;
        }
        [(YLOrderStatusTopUITableViewCell *)cell setMenuMsgDict:self.order bHiddenLine:NO];
        itemCell = cell;
    }
    else if ( indexPath.section == 2 )
    {
        static NSString * strOderCellIdentifier  = @"YLOrderStatusAddressUITableViewCell";
        YLOrderStatusAddressUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
        if (cell == nil)
        {
            cell = [[YLOrderStatusAddressUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
            cell.delegate = self;
        }
        [(YLOrderStatusAddressUITableViewCell *)cell setMenuMsgDict:self.order.consignee bHiddenLine:NO];
        itemCell = cell;
    }
    else if ( indexPath.section == 1 )
    {
        static NSString * strOderCellIdentifier  = @"HYOrderServiceUITableViewCell";
        HYOrderServiceUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
        if (cell == nil)
        {
            cell = [[HYOrderServiceUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
        }
        itemCell = cell;
    }
    else if ( indexPath.section >= 3 && indexPath.section < _distributorOrderItem.count+3 )
    {
            static NSString * strOderCellIdentifier  = @"YLOrderStatusShipUITableViewCell";
            YLOrderStatusShipUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
            if (cell == nil)
            {
                cell = [[YLOrderStatusShipUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
                cell.delegate = self;
            }
            BOOL   hides = NO;
            MKOrderItemObject *objc;
            if (  _distributorOrderItem.count > indexPath.section - 3  ) {
                objc = _distributorOrderItem[indexPath.section - 3];
                if ( indexPath.section == _distributorOrderItem.count+2 ){
                        hides = YES;
                }
            }

            [(YLOrderStatusShipUITableViewCell *)cell setMenuMsgDict:objc setOrderObject:self.order tag:[_orderItemDict HYValueForKey:[NSString stringWithFormat:@"%@",objc.itemSkuId]] hide:hides];
            itemCell = cell;
    }
    else if ( _orderGiftItem.count>0 && indexPath.section == _distributorOrderItem.count+3 )
    {
            static NSString * strOderCellIdentifier  = @"YLOrderGiftTableViewCell";
            YLOrderGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
            if (cell == nil)
            {
                cell = [[YLOrderGiftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
            }
            MKOrderItemObject *orderItems;
            if ( indexPath.row < _orderGiftItem.count )
            {
                orderItems = _orderGiftItem[0];
            }
            [(YLOrderGiftTableViewCell *)cell setMenuMsgDict:orderItems bHiddenLine:NO];
            itemCell = cell;
    }
    else if( indexPath.section == _distributorOrderItem.count+3 + (_orderGiftItem.count>0?1:0) )
    {
        static NSString * strOderCellIdentifier  = @"YLOrderStatusOtherUITableViewCell";
        YLOrderStatusOtherUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
        if (cell == nil)
        {
            cell = [[YLOrderStatusOtherUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
            cell.delegate = self;
        }
        [(YLOrderStatusOtherUITableViewCell *)cell setMenuMsgDict:_statusDict];
        itemCell = cell;
    }
    else if ( indexPath.section == _distributorOrderItem.count +4 + (_orderGiftItem.count>0?1:0) )
    {
        static NSString * strOderCellIdentifier  = @"YLOrderStatusTimeUITableViewCell";
        YLOrderStatusTimeUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
        if (cell == nil)
        {
            cell = [[YLOrderStatusTimeUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
            cell.delegate = self;
        }
        [(YLOrderStatusTimeUITableViewCell *)cell setMenuMsgDict:_statusTimeArr bHiddenLine:NO];
        itemCell = cell;
    }
    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return itemCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0
        && ([self.order ourOrderStatus] == 2 || [self.order ourOrderStatus] == 5) )
    {
        [self onDelegateOrderType:2];
    }
    else if ( indexPath.section >= 3 && indexPath.section < _distributorOrderItem.count+3 )     //点击商品，或者商铺
    {
        
        MKOrderItemObject *item = _distributorOrderItem[indexPath.section-3];
        MKItemDetailViewController *itvc = [MKItemDetailViewController create];
        itvc.itemId = item.itemUid;
        itvc.type = 1;
        itvc.itemType = item.itemType;
        itvc.shareUserId = item.shareUserId?item.shareUserId:nil;
        [getMainTabBar.selectedNav pushViewController:itvc animated:YES];
        
    }
     else if ( indexPath.section == 1 )//联系客服处理
    {
            MKDistributorOrderItemList *obj = self.order.distributorOrderItem[0];
            MKOrderItemObject *item = obj.orderItemList[0];
            QYSource *source = [[QYSource alloc] init];
            source.title =  @"嗨云app-iOS";
            source.urlString = @"";
            QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
            commodityInfo.title = self.order.orderSn;
            commodityInfo.desc = item.itemName;
            commodityInfo.pictureUrlString = item.iconUrl;
            commodityInfo.urlString = @"";
            commodityInfo.note = [NSString stringWithFormat:@"订单实付金额:￥%@",[MKBaseItemObject priceString:_order.totalAmount]];
            QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
            sessionViewController.sessionTitle = @"嗨云客服";
            sessionViewController.source = source;
            sessionViewController.commodityInfo = commodityInfo;
            sessionViewController.hidesBottomBarWhenPushed = YES;
        
        [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [UIColor blackColor];
        [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [UIColor blackColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"session_bg"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;
        
       [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:getUserCenter.userInfo.headerUrl]]];
        
        [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"HYShare"];
    
        [getMainTabBar.selectedNav pushViewController:sessionViewController animated:YES];

    }
}


#pragma mark -订单详情更新数据
-(void)setInfDict:(NSDictionary *)nsDict
{
    if ( _nsDict == nil )
    {
        _nsDict = [[NSMutableDictionary alloc] initWithDictionary:nsDict];
    }else
    {
        [_nsDict removeAllObjects];
        [_nsDict addEntriesFromDictionary:nsDict];
    }
    self.order = [MKOrderObject objectWithDictionary:nsDict];
   
    self.order.cancelOrderTime = HYNowTimeChangeToDate(_order.payTimeout);
    _orderBottomView.hidden = YES;
    
    /**
     *  优惠信息
     */
    if ( _statusDict == nil )
    {
        _statusDict = [[NSMutableDictionary alloc] init];
    }
    else
    {
        [_statusDict removeAllObjects];
    }
    NSMutableArray  *nameArr = [NSMutableArray array];
    NSMutableArray  *priceArr = [NSMutableArray array];
    [nameArr addObject:@"运费"];
    [priceArr addObject:[NSString stringWithFormat:@"￥%.2f",[[MKBaseItemObject priceString:self.order.deliveryFee] floatValue]]];
    if ( self.order.taxFee )
    {
        [nameArr addObject:@"跨境进口税"];
        [priceArr addObject:[NSString stringWithFormat:@"￥%@",[MKBaseItemObject priceString:[self.order.taxFee integerValue]]]];
    }
    
    NSMutableDictionary  *disDict = [NSMutableDictionary dictionary];

    if (_orderItemDict == nil )
    {
        _orderItemDict = [[NSMutableDictionary alloc] init];
    }else
    {
        [_orderItemDict removeAllObjects];
    }
    NSString  *ReToolSkuId = @"";//赠品item_sku_id
    for ( MKOrderDiscountObject *item in self.order.discountInfo )//NSDictionary
    {
        if (  [item.discountCode isEqualToString:@"ReachMultipleReduceTool"] )
        {
            if ( item.discountAmount >0 )
            {
               [_orderItemDict setObject:@"活动" forKey:[NSString stringWithFormat:@"%@",item.itemSkuId]];
            }else
            {
                ReToolSkuId = [NSString stringWithFormat:@"%@",item.itemSkuId];
            }
        }
        else if (  [item.discountCode isEqualToString:@"TimeRangeDiscount"] )
        {
            [_orderItemDict setObject:@"限时购" forKey:[NSString stringWithFormat:@"%@",item.itemSkuId]];
        }
        if (  item.discountAmount > 0 )
        {
            if ( ISNSStringValid([disDict HYValueForKey:item.discountDesc]) )
            {
                NSInteger disA = item.discountAmount + [[disDict HYValueForKey:[NSString stringWithFormat:@"%@",item.discountDesc]] integerValue];
                [disDict setObject:[NSString stringWithFormat:@"%ld",(long)disA] forKey:[NSString stringWithFormat:@"%@",item.discountDesc]];
            }
            else
            {
                [disDict setObject:[NSString stringWithFormat:@"%ld",(long)item.discountAmount] forKey:[NSString stringWithFormat:@"%@",item.discountDesc]];
            }
        }
    }
    
    for(NSString *keys in [disDict allKeys] )
    {
        [nameArr addObject:[NSString stringWithFormat:@"%@",keys]];
        [priceArr addObject:[NSString stringWithFormat:@"-￥%@",[MKBaseItemObject priceString:[[disDict HYValueForKey:keys] integerValue]]]];
    }
    
    if ( !([_order ourOrderStatus] == 0
        || [_order ourOrderStatus] == 3) )
    {
        [nameArr addObject:@"实付"];
        [priceArr addObject:[NSString stringWithFormat:@"￥%@",[MKBaseItemObject priceString:_order.totalAmount]]];
    }
    
    [_statusDict setObject:nameArr forKey:@"left"];
    [_statusDict setObject:priceArr forKey:@"right"];
    /**end**/
    
   
    /**
     ************************商品，店铺信息过滤
     */
    if ( _distributorOrderItem == nil )
    {
        _distributorOrderItem = [[NSMutableArray alloc] init];
    }else
    {
        [_distributorOrderItem removeAllObjects];
    }
    if ( _orderGiftItem == nil )
    {
        _orderGiftItem = [[NSMutableArray alloc] init];
    }
    else
    {
        [_orderGiftItem removeAllObjects];
    }
    NSInteger orderNum = 0;
//    for (  MKDistributorOrderItemList *item in self.order.distributorOrderItem )
//    {
//        NSMutableArray *orderItemList = [NSMutableArray array];
        for( MKOrderItemObject *orderItem in self.order.orderItems )
        {
            orderNum += orderItem.number;
            if ( ISNSStringValid(ReToolSkuId)
                && orderItem.price == 0.0f
                && [[NSString stringWithFormat:@"%@",orderItem.itemSkuId] isEqualToString:ReToolSkuId] )
            {
                [_orderGiftItem  addObject:orderItem];
            }
            else
            {
                [_distributorOrderItem addObject:orderItem];
            }
        }
//        item.orderItemList = [NSMutableArray arrayWithArray:orderItemList];
//        if ( item.orderItemList.count )
//        {
//            [_distributorOrderItem addObject:item];
//        }
//    }
    //end
    //底部处理
    if ( [_order ourOrderStatus] == 0 ||
        [_order ourOrderStatus] == 2 ||
        [_order ourOrderStatus] == 5 )
    {
        _orderBottomView.hidden = NO;
        NSInteger type = 0;
        if ( [_order ourOrderStatus] == 5 )
        {
            type = 2;
        }
        else if ( [_order ourOrderStatus] == 0 )
        {
            type = 1;
        }
        else
        {
            type = 0;
        }
        [_orderBottomView setOrderBottomStatus:type price:[MKBaseItemObject priceString:_order.totalAmount] num:orderNum];
    }
    
    /**
     *  底部时间的显示
     */
    if ( _statusTimeArr )
    {
        [_statusTimeArr removeAllObjects];
    }
    else
    {
        _statusTimeArr = [[NSMutableArray alloc] init];
    }
    
    //订单编号
    [_statusTimeArr addObject:[NSString stringWithFormat:@"%@",self.order.orderSn]];
    if ( ISNSStringValid(self.order.orderTime) )//所有都显示
    {
        [_statusTimeArr addObject:[NSString stringWithFormat:@"下单时间：%@",self.order.orderTime]];
    }
//    if ( [self.order ourOrderStatus] == 3 && ISNSStringValid(self.order.cancelTime))
//    {
//        [_statusTimeArr addObject:[NSString stringWithFormat:@"取消时间：%@",self.order.cancelTime]];
//    }
    if (  [self.order ourOrderStatus]== 1
        || [self.order ourOrderStatus]== 2
        || [self.order ourOrderStatus]== 4
        || [self.order ourOrderStatus]== 5 )//待发货,待收货，已关闭，已完成
    {
        if ( ISNSStringValid([self.order ourPayment]) )
        {
            [_statusTimeArr addObject:[NSString stringWithFormat:@"支付方式：%@",[self.order ourPayment]]];
        }
        if ( ISNSStringValid(self.order.payTime) )
        {
            [_statusTimeArr addObject:[NSString stringWithFormat:@"付款时间：%@",self.order.payTime]];
        }
        
    }
    
    if ( ISNSStringValid(self.order.consignTime)
        && ( [self.order ourOrderStatus] == 2
            || [self.order ourOrderStatus]== 4
        || [self.order ourOrderStatus]== 5 ) )// 已关闭，已完成
    {
        [_statusTimeArr addObject:[NSString stringWithFormat:@"发货时间：%@",self.order.consignTime]];
    }
    if (  ([self.order ourOrderStatus] == 4
           || [self.order ourOrderStatus] == 5)
        && ISNSStringValid(self.order.receiptTime) ) /**< 已发货 待收货*/
        
    {
        [_statusTimeArr addObject:[NSString stringWithFormat:@"确认时间：%@",self.order.receiptTime]];
    }
    
    if ( self.order.consignee )
    {
        [MKRegionModel firstAddressWithCode1:self.order.consignee.provinceCode cityCode:self.order.consignee.cityCode areaCode:self.order.consignee.areaCode completion:^(NSString *address) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                self.order.consignee.addresses = address;
                [_pTableView reloadData];

            });
        }];
    }else
    {
        [_pTableView reloadData];
    }
    
}
#pragma mark -cell的代理
-(void)onButtonCellView:(YLUIBaseCellView *)cellView Type:(NSInteger)nType
{
    NSIndexPath* indePath = [_pTableView indexPathForCell:cellView];
    
    if ( indePath.section == 0 )//取消订单
    {
        [self onDelegateOrderType:nType];
    }
}

#pragma mark -底部代理
-(void)onButtonBottomView:(YLOrderBottomView *)bottomView Type:(NSInteger)nType
{
    if ( bottomView == _orderBottomView )
    {
        [self onDelegateOrderType:nType];
    }
}

#pragma mark -调用代理
-(void)onDelegateOrderType:(NSInteger)nsType
{
    if ( _delegate && [_delegate respondsToSelector:@selector(showOrderDetailView:InfoType:)])
    {
        [_delegate showOrderDetailView:self InfoType:nsType];
    }
}

@end
