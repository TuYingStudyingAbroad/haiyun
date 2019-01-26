//
//  MKPasswordView.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/6/3.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKPasswordView.h"
#import <PureLayout.h>

@implementation MKPasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundFrame.layer.borderWidth = .8f;
    
    self.backgroundFrame.layer.borderColor = [[UIColor colorWithHex:0x999999] CGColor];
    self.backgroundFrame.layer.cornerRadius = 3;
    self.backgroundFrame.layer.masksToBounds = YES;
    self.quXiao = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.quXiao setImage:[UIImage imageNamed:@"X_19x19"]forState:(UIControlStateNormal)];
    [self addSubview:self.quXiao];
//    [self.quXiao setBackgroundColor:[UIColor redColor]];
    [self.quXiao autoPinEdge:(ALEdgeRight) toEdge:(ALEdgeRight) ofView:self withOffset:-15];
    [self.quXiao autoPinEdge:(ALEdgeTop) toEdge:(ALEdgeTop) ofView:self withOffset:12];
    [self.quXiao autoSetDimension:(ALDimensionHeight) toSize:22];
    [self.quXiao autoSetDimension:(ALDimensionWidth) toSize:22];
}



@end
