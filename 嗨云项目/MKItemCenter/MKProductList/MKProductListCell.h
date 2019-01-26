//
//  MKProductListCell.h
//  YangDongXi
//
//  Created by windy on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseTableViewCell.h"
#import "UIView+MKExtension.h"
#import "MKItemObject.h"
#import "MKStrikethroughLabel.h"
#import "MKMarketingListItem.h"

@interface MKProductListCell : MKBaseTableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;

@property (nonatomic,weak) IBOutlet UILabel *discountPriceLabel;

@property (nonatomic,weak) IBOutlet UILabel *discountLabel;

@property (nonatomic,weak) IBOutlet UILabel *marketPriceLabel;

@property (nonatomic, weak) IBOutlet UIImageView *cornerIcon;

@property (weak,nonatomic) IBOutlet UILabel *contryNameLabel;

@property (weak,nonatomic) IBOutlet UIImageView *contryFlagImageView;

@property (weak,nonatomic) IBOutlet UIImageView *discountBackgroundImageView;

@property (weak,nonatomic) IBOutlet UILabel *marketTitleLabel;

-(void)updatePrice:(NSInteger)price andMarketPrice:(NSInteger)marketPrice;

-(void)updateCellWithData:(MKMarketingListItem *)item;

-(void)updateCellWithProductData:(MKItemObject *)item;

@end
