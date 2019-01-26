//
//  HYUILoadingView.m
//  HaiYun
//
//  Created by YanLu on 16/4/21.
//  Copyright © 2016年 YanLu. All rights reserved.
//

#import "HYUILoadingView.h"

@interface HYUILoadingView ()
{
    UIImageView * _ImageView;
    int           _nImageIndex;
    NSTimer     * _timer;
}

@end

@implementation HYUILoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void)removeFromSuperview
{
    [self resetTimer];
    [super removeFromSuperview];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    CGRect rect = CGRectMake(0, 0, 160, 60);
    rect.size.width = 320/153 * rect.size.height;
    rect.origin.x = (frame.size.width - rect.size.width)/2;
    rect.origin.y = (frame.size.height - rect.size.height)/2;
    if (_ImageView == nil)
    {
        _ImageView = [[UIImageView alloc] init];
        _ImageView.frame = rect;
        _ImageView.image = [UIImage imageNamed:@"loading_0.png"];
        _ImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_ImageView];
        [self Loading];
    }else
    {
        _ImageView.frame = rect;
    }
}

-(void)ChangeLoadingImage
{
    _nImageIndex ++;
    if (_nImageIndex > 5)
        _nImageIndex = 0;
    _ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d.png",_nImageIndex]];
}

-(void)Loading
{
    [self resetTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ChangeLoadingImage) userInfo:nil repeats:YES];
}

- (void)resetTimer
{
    _nImageIndex = 0;
    if (!_timer)
        return;
    
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
