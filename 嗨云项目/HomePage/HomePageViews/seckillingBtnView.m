//
//  seckillingBtnView.m
//  嗨云项目
//
//  Created by 小辉 on 16/10/13.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "seckillingBtnView.h"

@implementation seckillingBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.seckillingBVLab.layer.borderWidth = 1.0f;
    self.seckillingBVLab.layer.borderColor = [UIColor grayColor].CGColor;
    
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];    //给self.view添加一个手势监测；
    self.seckillingBVLab.userInteractionEnabled = YES;

    [self.seckillingBVLab addGestureRecognizer:tap];
   
}
- (IBAction)doTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(seckillingBVBtnClick:)]) {
        [self.delegate seckillingBVBtnClick:self];
    }
}

@end
