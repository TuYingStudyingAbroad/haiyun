//
//  MKPrivilegeTableViewCell.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCouponObject.h"

@interface MKPrivilegeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monelab;
@property (weak, nonatomic) IBOutlet UILabel *timeLabe;
@property (weak, nonatomic) IBOutlet UILabel *thresholdLabel;
@property (weak, nonatomic) IBOutlet UIButton *getBut;


- (void)cellWithModel:(MKCouponObject *)model withType:(NSInteger) type;
@end
