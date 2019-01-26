//
//  MKSettingCell.h
//  YangDongXi
//
//  Created by windy on 15/4/23.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKSettingCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *jtIV;
@property (weak, nonatomic) IBOutlet UILabel *llLabel;

@end

