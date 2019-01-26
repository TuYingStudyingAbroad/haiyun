//
//  MKTinyItemTableViewCell.m
//  YangDongXi
//
//  Created by cocoa on 15/5/12.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKTinyItemTableViewCell.h"


@interface MKTinyItemTableViewCell()

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *checkButtonLeading;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *iconViewLeading;

@end


@implementation MKTinyItemTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBottomSeperatorLineMarginLeft:12 rigth:0];
}

- (void)enableEdit:(BOOL)edit animation:(BOOL)animation
{
    if (animation)
    {
        [UIView animateWithDuration:0.25f animations:^
         {
             self.checkButtonLeading.constant = edit ? 0 : -self.checkButton.frame.size.width;
             self.iconViewLeading.constant = edit ? 0 : 12;
             [self layoutIfNeeded];
         }];
    }
    else
    {
        self.checkButtonLeading.constant = edit ? 0 : -self.checkButton.frame.size.width;
        self.iconViewLeading.constant = edit ? 0 : 12;
    }
}

- (IBAction)checkButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
}

+ (CGFloat)cellHeight
{
    return 100;
}

@end
