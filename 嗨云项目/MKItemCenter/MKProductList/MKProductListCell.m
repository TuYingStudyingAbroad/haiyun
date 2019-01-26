//
//  MKProductListCell.m
//  YangDongXi
//
//  Created by windy on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKProductListCell.h"
#import <UIImageView+WebCache.h>
#import "NSString+MKExtension.h"
#import "MKBaseItemObject.h"
#import "MKFlagShared.h"
#import "MKMarketingFlagObject.h"

@interface MKProductListCell()

//@property (nonatomic, strong) IBOutlet UIView *discountLabelBackground;

@end


@implementation MKProductListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    //self.discountLabelBackground.layer.cornerRadius = 3;
    //self.discountLabelBackground.layer.masksToBounds = YES;
}

+ (CGFloat)cellHeight
{
    return 100;
}

- (void)updatePrice:(NSInteger)price andMarketPrice:(NSInteger)marketPrice
{
    if (price != marketPrice)
    {
        self.marketPriceLabel.hidden = NO;
        
        self.marketTitleLabel.hidden = NO;
        
        self.marketPriceLabel.text =
        [NSString stringWithFormat:@"￥%@", [MKBaseItemObject priceString:marketPrice]];
    }
    else
    {
        self.marketPriceLabel.hidden = YES;
        
        self.marketTitleLabel.hidden = YES;
        
    }

    self.discountPriceLabel.text = [MKBaseItemObject priceString:price];

    NSString *discountString = [MKBaseItemObject discountStringWithPrice1:price andPrice2:marketPrice];
    
    self.discountBackgroundImageView.hidden = discountString == nil;
    //self.discountPriceLabel.hidden = discountString == nil;
    self.discountLabel.hidden = discountString == nil;
    if (discountString != nil)
    {
        self.discountLabel.text = [NSString stringWithFormat:@"%@折", discountString];
    }
}

-(void)updateCellWithData:(MKMarketingListItem *)item
{
    if(item)
    {
        self.cornerIcon.hidden = YES;
        
        self.nameLabel.text = item.text;
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
        
        [self updatePrice:item.wirelessPrice andMarketPrice:item.marketPrice];
        
        if(item.supplyPlace && item.supplyPlace.length > 0)
        {
            self.contryNameLabel.hidden = NO;
            
            MKMarketingFlagObject *object =  [[MKFlagShared sharedInstance].flagDictionary objectForKey:item.supplyPlace];
            
            if(object && object.icon_url)
            {
                self.contryNameLabel.text = item.supplyPlace;
                
                self.contryFlagImageView.hidden = NO;
                
                self.contryNameLabel.hidden = NO;
                
                [self.contryFlagImageView sd_setImageWithURL:[NSURL URLWithString:object.icon_url]
                             placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
            }
            else
            {
                self.contryNameLabel.hidden = YES;
                
                self.contryFlagImageView.hidden = YES;
            }
        }
        else
        {
            self.contryFlagImageView.hidden = YES;
            
            self.contryNameLabel.hidden = YES;
            
        }

    }
}

-(void)updateCellWithProductData:(MKItemObject *)item
{
    if(item)
    {
        self.nameLabel.text = item.itemName;
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
        
        [self updatePrice:item.wirelessPrice andMarketPrice:item.marketPrice];
        

        if(item.corner_icon_url && item.corner_icon_url.length > 0)
        {
            self.cornerIcon.hidden = NO;
            
            [self.cornerIcon sd_setImageWithURL:[NSURL URLWithString:item.corner_icon_url]];
            
        }
        else
        {
            self.cornerIcon.hidden = YES;
        }
        
        if(item.supply_base && item.supply_base.length > 0)
        {
            self.contryNameLabel.hidden = NO;
            
            MKMarketingFlagObject *object =  [[MKFlagShared sharedInstance].flagDictionary objectForKey:item.supply_base];
            
            if(object && object.icon_url)
            {
                self.contryNameLabel.text = item.supply_base;
                
                self.contryFlagImageView.hidden = NO;
                
                self.contryNameLabel.hidden = NO;
                
                [self.contryFlagImageView sd_setImageWithURL:[NSURL URLWithString:object.icon_url]
                                            placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
            }
            else
            {
                self.contryNameLabel.hidden = YES;
                
                self.contryFlagImageView.hidden = YES;
            }
        }
        else
        {
            self.contryFlagImageView.hidden = YES;
            
            self.contryNameLabel.hidden = YES;
            
        }
    }
}

@end
