//
//  MKAddAdressTableViewCell.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKAddAdressTableViewCell.h"

@implementation MKAddAdressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.saveAddress.layer.borderWidth = .8f;
    
    self.saveAddress.layer.borderColor = [UIColor colorWithHexString:@"ff4b55"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
