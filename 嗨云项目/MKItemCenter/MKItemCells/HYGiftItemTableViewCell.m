//
//  HYGiftItemTableViewCell.m
//  嗨云项目
//
//  Created by haiyun on 16/7/25.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYGiftItemTableViewCell.h"

@implementation HYGiftItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWithModel:(NSString *)giftStr
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:giftStr];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kHEXCOLOR(kRedColor) range:NSMakeRange(0,[@"赠" length])];
    self.giftLabel.attributedText = attributedString;
}
@end
