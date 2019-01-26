//
//  MKSimpleItemTableViewCell.h
//  YangDongXi
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseTableViewCell.h"
#import "MKOrderItemObject.h"
#import "MKOrderObject.h"

@interface MKSimpleItemTableViewCell : MKBaseTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) IBOutlet UILabel *numberLabel;

@property (nonatomic, strong) IBOutlet UILabel *attributesLabel;

@property (nonatomic, strong) IBOutlet UILabel *sourceLabel;

@property (weak, nonatomic) IBOutlet UIButton *refundBut;

@property (weak, nonatomic) IBOutlet UILabel *refundLabel;

@property (nonatomic,strong)MKOrderItemObject *object;

- (void)cellWithModel:(MKOrderItemObject *)model orderObject:(MKOrderObject *)orders;

@end
