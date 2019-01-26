//
//  HYGiftItemTableViewCell.h
//  嗨云项目
//
//  Created by haiyun on 16/7/25.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseTableViewCell.h"

@interface HYGiftItemTableViewCell : MKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;

- (void)cellWithModel:(NSString *)giftStr;

@end
