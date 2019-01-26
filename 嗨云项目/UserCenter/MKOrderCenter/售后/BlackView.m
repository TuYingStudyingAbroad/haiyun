//
//  BlackView.m
//  YangDongXi
//
//  Created by 杨鑫 on 15/10/16.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "BlackView.h"
#import <UIKit/UIKit.h>

@implementation BlackView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self =  [[NSBundle mainBundle] loadNibNamed:@"BlackView" owner:self options:nil][0];  
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
