//
//  HSRefundValueCell.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/6/3.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HSRefundValueCell.h"

@implementation HSRefundValueCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.TF.layer.borderWidth = .8;
    
    self.TF.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
