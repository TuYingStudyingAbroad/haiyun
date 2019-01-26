//
//  wxhTitleButton.m
//  kkkkk
//
//  Created by kans on 16/4/12.
//  Copyright © 2016年 HaiYn. All rights reserved.
//

#import "wxhTitleButton.h"

#define IWTitleButtonImageW 20
@implementation wxhTitleButton

+ (instancetype)titleButton
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.imageView.contentMode = UIViewContentModeBottomRight;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        // 背景
//        [self setBackgroundImage:[UIImage resizedImageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
        self.backgroundColor=[UIColor colorWithHexString:@"ff2741"];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
//    CGFloat imageY = 0;
//    CGFloat imageW = IWTitleButtonImageW;
//    CGFloat imageX = contentRect.size.width - imageW;
//    CGFloat imageH = contentRect.size.height;
//    return CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat imagX=5;
    CGFloat imagY=0;
    CGFloat imagW = IWTitleButtonImageW ;
     CGFloat imagH = IWTitleButtonImageW;
    return CGRectMake(imagX, imagY, imagW, imagH);

    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
//    CGFloat titleY = 0;
//    CGFloat titleX = 0;
//    CGFloat titleW = contentRect.size.width - IWTitleButtonImageW;
//    CGFloat titleH = contentRect.size.height;
//    return CGRectMake(titleX, titleY, titleW, titleH);
    
        CGFloat titleY = 0;
        CGFloat titleW = contentRect.size.width - IWTitleButtonImageW;
        CGFloat titleX =  IWTitleButtonImageW-10;
        CGFloat titleH = contentRect.size.height;
        return CGRectMake(titleX, titleY, titleW , titleH);
    
}


@end
