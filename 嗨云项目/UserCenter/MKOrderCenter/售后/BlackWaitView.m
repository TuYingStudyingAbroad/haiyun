//
//  BlackWaitView.m
//  YangDongXi
//
//  Created by 杨鑫 on 15/10/16.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "BlackWaitView.h"

@interface BlackWaitView ()


@end
@implementation BlackWaitView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self.plck startAnimating];
        self =  [[NSBundle mainBundle] loadNibNamed:@"BlackWaitView" owner:self options:nil][0];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
