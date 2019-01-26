//
//  MKStoreNameCell.m
//  嗨云项目
//
//  Created by 李景 on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKStoreNameCell.h"

@implementation MKStoreNameCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)switchSelectButton:(BOOL)oneToTwo animation:(BOOL)animation
{
//    if (animation)
//    {
//        [UIView animateWithDuration:0.25f animations:^
//         {
//             [self switchSelectButton:oneToTwo];
//             [self layoutIfNeeded];
//         }];
//    }
//    else
//    {
//        [self switchSelectButton:oneToTwo];
//    }
}

- (void)switchSelectButton:(BOOL)oneToTwo
{
    if (oneToTwo)
    {
//        self.selectBtnLeading.constant = -20;
//        self.selectBtnLeading2.constant = 12;
    }
    else
    {
//        self.selectBtnLeading.constant = 12;
//        self.selectBtnLeading2.constant = -20;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
