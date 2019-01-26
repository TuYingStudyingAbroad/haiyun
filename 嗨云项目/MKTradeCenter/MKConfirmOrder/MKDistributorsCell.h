//
//  MKDistributorsCell.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/17.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDistributorInfo.h"

@interface MKDistributorsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;


@property (weak, nonatomic) IBOutlet UILabel *distributorlabel;

- (void)cellWithModel:(MKDistributorInfo *)model;


@end
