//
//  MKStoreHeardTableViewCell.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKOrderObject.h"

@interface MKStoreHeardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderShow;
@property (weak, nonatomic) IBOutlet UILabel *orderStates;
@property (weak, nonatomic) IBOutlet UIImageView *orderImages;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTimeConst;

@property (nonatomic,strong) MKOrderObject *model;
- (void)cellWithModel:(MKOrderObject *)model;
+ (CGFloat)cellHeight;
@end
