//
//  MKProductCollectionView.m
//  YangDongXi
//
//  Created by Constance Yang on 26/07/2015.
//  Copyright (c) 2015 yangdongxi. All rights reserved.
//

#import "MKProductCollectionView.h"
#import <UIImageView+WebCache.h>
#import "NSString+MKExtension.h"
#import "MKBaseItemObject.h"
#import <PureLayout.h>

@interface MKProductCollectionView()


@end

@implementation MKProductCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.statusLabel = [MKItemDetailTipView loadFromXib];
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
    [self.iconImageView addSubview:self.statusLabel];
    
    [self.statusLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.statusLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.statusLabel autoSetDimension:ALDimensionHeight toSize:75];
    [self.statusLabel autoSetDimension:ALDimensionWidth toSize:75];
    
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.layer.cornerRadius = 37;

    
}

- (void)updatePrice:(NSInteger)price andMarketPrice:(NSInteger)marketPrice
{
    if (price != marketPrice)
    {
        self.marketPriceLabel.hidden = NO;
        
        self.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@", [MKBaseItemObject priceString:marketPrice]];
        
    }
    else
    {
        self.marketPriceLabel.hidden = YES;
        
    }
    NSString *discountString = [MKBaseItemObject discountStringWithPrice1:price andPrice2:marketPrice];
    self.discountLabelBackground.hidden = discountString == nil;
    self.discountLabel.hidden = discountString == nil;
    if (discountString != nil)
    {
        self.discountLabel.text = [NSString stringWithFormat:@"%@折", discountString];
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[MKBaseItemObject priceString:price]];
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(AttributedStr.length-2, 2)];
     [self.discountPriceLabel setAttributedText:AttributedStr];
    //self.discountPriceLabel.text = [MKBaseItemObject priceString:price];
    
}

@end
