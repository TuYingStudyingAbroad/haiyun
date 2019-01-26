//
//  MKMarketingTopNewsView.m
//  YangDongXi
//
//  Created by cocoa on 15/5/7.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketingTopNewsView.h"

@interface MKMarketingTopNewsView ()

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL oneOrTwo;

@end


@implementation MKMarketingTopNewsView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.oneOrTwo = YES;
}

- (void)updateTitles:(NSArray *)titles
{
    self.titles = titles;
    self.index = 0;
    [[self currentButton] setTitle:titles[0] forState:UIControlStateNormal];
    if (titles.count < 2)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    else if (self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerSwitch:)
                                                    userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)animationSwitch
{
    [UIView animateWithDuration:0.25f animations:^
    {
        [self otherButtonConstraint].constant = 0;
        [self currentButtonConstraint].constant = self.frame.size.height;
        [self layoutIfNeeded];
    }
                     completion:^(BOOL finished)
    {
        [self currentButtonConstraint].constant = -self.frame.size.height;
        [self layoutIfNeeded];
       
    }];
}

- (void)timerSwitch:(NSTimer *)timer
{
    self.index ++ ;
    if (self.index >= self.titles.count)
    {
        self.index = 0;
    }
    self.oneOrTwo = !self.oneOrTwo;
    [self currentButton].tag = self.index;
    [[self currentButton] setTitle:self.titles[self.index] forState:UIControlStateNormal];
    [self animationSwitch];
}

- (NSLayoutConstraint *)currentButtonConstraint
{
    return self.oneOrTwo ? self.oneButtonAlignY : self.twoButtonAlignY;
}

- (UIButton *)currentButton
{
    return self.oneOrTwo ? self.oneButton: self.twoButton;
}

- (NSLayoutConstraint *)otherButtonConstraint
{
    return !self.oneOrTwo ? self.oneButtonAlignY : self.twoButtonAlignY;
}

- (UIButton *)otherButton
{
    return !self.oneOrTwo ? self.oneButton: self.twoButton;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
