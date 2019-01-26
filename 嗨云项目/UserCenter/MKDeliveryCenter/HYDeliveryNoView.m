//
//  HYDeliveryNoView.m
//  嗨云项目
//
//  Created by haiyun on 16/6/7.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYDeliveryNoView.h"

@interface HYDeliveryNoView ()
{
    UIImageView         *_mainImageView;
    UILabel             *_titleLabel;
}

@end

@implementation HYDeliveryNoView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    CGRect rect = CGRectMake(0, 0, 103.0f, 103.0f);
    rect.origin.x = (frame.size.width - rect.size.width)/2;
    rect.origin.y = (frame.size.height - rect.size.height - 32.0f)/3;
    if (_mainImageView == nil)
    {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.frame = rect;
        _mainImageView.image = [UIImage imageNamed:@"HYwudingdan"];
        _mainImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainImageView];
    }else
    {
        _mainImageView.frame = rect;
    }
    
    rect.origin.y += rect.size.height + 12.0f;
    rect.size.height = 18.0f;
    rect.origin.x = 0.0f;
    rect.size.width = frame.size.width;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.frame = rect;
        _titleLabel.text = @"暂无物流信息";
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kHEXCOLOR(0x999999);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
}

-(void)updateDeliverView:(NSString *)title imageName:(NSString *)imageName
{
    if ( _mainImageView )
    {
        _mainImageView.image = [UIImage imageNamed:imageName];
    }
    if ( _titleLabel )
    {
        _titleLabel.text = title;
    }
}
@end
