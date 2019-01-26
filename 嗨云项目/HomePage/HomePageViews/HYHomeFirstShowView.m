//
//  HYHomeFirstShowView.m
//  嗨云项目
//
//  Created by haiyun on 16/8/1.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYHomeFirstShowView.h"

@interface HYHomeFirstShowView ()
{
    UIImageView     *_bgImageView;
    UIButton        *_imKnowsBtn;
}

@end

@implementation HYHomeFirstShowView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    self.backgroundColor = kColorRGBA(1.0f,1.0f,1.0f,0.75f);
    
    CGRect rect = CGRectMake(0, 210.0f/1334.0f*Main_Screen_Height, 685.0f/750.0f*Main_Screen_Width, 862.0f/1334.0f*Main_Screen_Height);
    rect.origin.x = (Main_Screen_Width-rect.size.width)/2.0f;
    if ( !_bgImageView )
    {
        _bgImageView = NewObject(UIImageView);
        _bgImageView.frame = rect;
        _bgImageView.image = [UIImage imageNamed:@"HYFirstShow_Image"];
        _bgImageView.userInteractionEnabled = YES;
        [self addSubview:_bgImageView];
    }else
    {
        _bgImageView.frame = self.bounds;
    }
    //CGRectMake((self.frame.size.width - self.frame.size.width*(267.0f/750.0f))/2.0f, self.frame.size.height*(912.0f/1334.0f), self.frame.size.width*(267.0f/750.0f), self.bounds.size.height*(106.0f/1334.0f));
    if ( !_imKnowsBtn )
    {
        _imKnowsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imKnowsBtn.frame = self.bounds;
        _imKnowsBtn.backgroundColor = [UIColor clearColor];
        [_imKnowsBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imKnowsBtn];
    }else
    {
        _imKnowsBtn.frame = self.bounds;
    }
}

-(void)OnButton:(UIButton *)sender
{
    if ( sender == _imKnowsBtn )
    {
        SetObjectforNSUserDefaultsByKey(@"1", @"HYShowHomePageFirst1.2");
        [self removeFromSuperview];
    }
}

@end
