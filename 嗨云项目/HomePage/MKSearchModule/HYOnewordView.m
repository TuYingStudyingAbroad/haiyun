//
//  HYKeywordView.m
//  嗨云项目
//
//  Created by haiyun on 16/9/20.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYOnewordView.h"

@interface HYOnewordView ()<UIGestureRecognizerDelegate>


@end

@implementation HYOnewordView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.keyBtn.layer.cornerRadius = 15.0f;
    self.keyBtn.layer.borderWidth = 1;
    self.keyBtn.layer.borderColor = [UIColor colorWithHex:0xe8e8e8].CGColor;
    
    self.delBtn.hidden = YES;
    //实例化长按手势监听
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleTableviewCellLongPressed:)];
    //代理
    longPress.delegate = self;
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [self addGestureRecognizer:longPress];
}

//长按事件的实现方法
- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ( self.isTag ) {
            self.delBtn.hidden = NO;
            if ( _delegate && [_delegate respondsToSelector:@selector(onewordView:changeIndex:)]) {
                [_delegate onewordView:self changeIndex:3];
            }
        }
    }
    
}



- (IBAction)onBtnClick:(id)sender {
    NSInteger index = 1;
    if ( sender == self.delBtn ) {
        index = 1;
    }else
    {
        index = 2;
    }
    if ( _delegate && [_delegate respondsToSelector:@selector(onewordView:changeIndex:)]) {
        [_delegate onewordView:self changeIndex:index];
    }
}


@end
