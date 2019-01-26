//
//  MKTextField.m
//  YangDongXi
//
//  Created by windy on 15/4/30.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKTextField.h"

@implementation MKTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 5 , 0 );
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 0);
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 0);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds,5,0);
}

@end
