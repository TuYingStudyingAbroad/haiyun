//
//  HYBaseScrollView.m
//  HaiYun
//
//  Created by YanLu on 16/4/21.
//  Copyright © 2016年 YanLu. All rights reserved.
//

#import "HYBaseScrollView.h"

@implementation HYBaseScrollView

@synthesize pBaseView = _pBaseView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _bShowLoading = NO;
        _bEndLoading = NO;
    }
    return self;
}



-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    self.backgroundColor = [UIColor clearColor];
    
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    if (_pBaseView == NULL)
    {
        _pBaseView = [[HYBaseView alloc] init];
        _pBaseView.bEndLoading = self.bEndLoading;
        _pBaseView.bShowLoading = self.bShowLoading;
        _pBaseView.frame = rect;
        [self addSubview:_pBaseView];
    }else
    {
        _pBaseView.frame = rect;
    }
}

-(void)OnRequest
{
    
}

-(void)stopLoading//停止加载
{
    if (_pBaseView)
    {
        _bEndLoading = YES;
        [_pBaseView stopLoading];
    }
}

@end
