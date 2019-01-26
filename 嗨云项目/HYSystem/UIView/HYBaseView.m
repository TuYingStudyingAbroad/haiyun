//
//  HYBaseView.m
//  HaiYun
//
//  Created by YanLu on 16/3/31.
//  Copyright © 2016年 YanLu. All rights reserved.
//

#import "HYBaseView.h"
#import "HYUILoadingView.h"

@interface HYBaseView()
{
    HYUILoadingView * _pLoadingView;
}
@end

@implementation HYBaseView

@synthesize baseDelegate = _baseDelegate;
@synthesize bEndLoading = _bEndLoading;
@synthesize bShowLoading = _bShowLoading;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bEndLoading = NO;
        _bShowLoading = NO;
    }
    return self;
}




-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    self.backgroundColor = [UIColor clearColor];
    
    if (_bShowLoading)
    {
        if (_pLoadingView == nil)
        {
            _pLoadingView = [[HYUILoadingView alloc] init];
            _pLoadingView.frame = self.bounds;
            [self addSubview:_pLoadingView];
        }else
        {
            _pLoadingView.frame = self.bounds;
        }
    }
}

-(void)OnRequest
{
    
}
-(void)stopLoading
{
    if (_pLoadingView)
    {
        _bEndLoading = YES;
        _pLoadingView.hidden = YES;
        [_pLoadingView resetTimer];
    }
}

@end
