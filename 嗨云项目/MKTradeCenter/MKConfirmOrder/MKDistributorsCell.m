//
//  MKDistributorsCell.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/17.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKDistributorsCell.h"
#import <UIImageView+WebCache.h>

@implementation MKDistributorsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWithModel:(MKDistributorInfo *)model{
    self.distributorlabel.text = model.shopName;
}


@end
