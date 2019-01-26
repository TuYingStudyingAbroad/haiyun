//
//  MKCommissionCell.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKCommissionCell.h"

@implementation MKCommissionCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)cellWithLoda{
    self.storeNmae.text = self.shopItem.shopName;
    self.detailsName.text = self.shopItem.shopDesc;


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
