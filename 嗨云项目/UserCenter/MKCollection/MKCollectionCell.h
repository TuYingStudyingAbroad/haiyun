//
//  MKCollectionCell.h
//  YangDongXi
//
//  Created by windy on 15/4/23.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseTableViewCell.h"
#import "MKCollectionItem.h"

@interface MKCollectionCell : MKBaseTableViewCell

@property (nonatomic, strong) IBOutlet UIButton *checkButton;

@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *deletBut;
@property (weak, nonatomic) IBOutlet UILabel *storeNmae;

@property (nonatomic, strong) MKItemObject *item;

- (void)enableEdit:(BOOL)edit animation:(BOOL)animation;

@end
