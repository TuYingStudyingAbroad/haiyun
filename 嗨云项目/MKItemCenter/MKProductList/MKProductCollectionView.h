//
//  MKProductCollectionView.h
//  YangDongXi
//
//  Created by Constance Yang on 26/07/2015.
//  Copyright (c) 2015 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+MKExtension.h"

#import "MKItemObject.h"

#import "MKStrikethroughLabel.h"

#import "MKItemDetailTipView.h"

@interface MKProductCollectionView : UIView

@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;

@property (nonatomic,weak) IBOutlet UILabel *discountPriceLabel;

@property (nonatomic,weak) IBOutlet UILabel *discountLabel;

@property (nonatomic,weak) IBOutlet MKStrikethroughLabel *marketPriceLabel;

@property (weak,nonatomic) IBOutlet UIButton *button;

@property (weak,nonatomic) IBOutlet UIImageView *discountLabelBackground;

@property (weak,nonatomic) IBOutlet UIImageView *flagImageView;

@property (weak,nonatomic) IBOutlet UIImageView *cornerImageView;

@property (nonatomic, strong) MKItemDetailTipView *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityMarkView;
@property (weak, nonatomic) IBOutlet UIImageView *shuangshuangJieImagV;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeLab;

- (void)updatePrice:(NSInteger)price andMarketPrice:(NSInteger)marketPrice;

@end
