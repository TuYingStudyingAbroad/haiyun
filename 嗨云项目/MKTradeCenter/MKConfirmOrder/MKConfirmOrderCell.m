//
//  MKConfirmOrderCell.m
//  YangDongXi
//
//  Created by windy on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKConfirmOrderCell.h"
#import <UIImageView+WebCache.h>
#import <PureLayout.h>


@interface MKConfirmOrderCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *deliveryTypeLabel;


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *skuLabel;

@end


@implementation MKConfirmOrderCell

+ (id)loadFromNib
{
    NSString *xibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
}

+ (NSString*)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)setCartItem:(MKCartItemObject *)cartItem
{
    _cartItem = cartItem;
}

- (void)layoutCellSubviews
{
    self.titleLabel.text = self.cartItem.itemName;
    
    self.priceLabel.text = [MKBaseItemObject priceString:self.cartItem.wirelessPrice];
    
    self.numberLabel.text = [NSString stringWithFormat:@"x%li",(long)self.cartItem.number];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.cartItem.iconUrl]
                          placeholderImage:[UIImage imageNamed:@"placeholder_57x57"]];
    
//    发货方式：0 未指定，1一般进口，2保税区发货，3海外直邮

    if (self.cartItem.deliveryType == 1) {
        self.deliveryTypeLabel.text = @"一般进口";
    }
    else if (self.cartItem.deliveryType == 2) {
        self.deliveryTypeLabel.text = @"保税区发货";
    }
    else if (self.cartItem.deliveryType == 3) {
        self.deliveryTypeLabel.text = @"海外直邮";
    }
    else{
        self.deliveryTypeLabel.hidden = YES;
    }
    
    
}
- (void)layoutCellModel{
    self.titleLabel.text = self.item.itemName;
    
    self.priceLabel.text = [MKBaseItemObject priceString:self.item.unitPrice];
    
    self.skuLabel.text = self.item.skuSnapshot;
    
    self.numberLabel.text = [NSString stringWithFormat:@"x%li",(long)self.item.number];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.item.iconUrl]
                          placeholderImage:[UIImage imageNamed:@"placeholder_57x57"]];
    
    UILabel *signLabel = [[UILabel alloc]init];
    signLabel.textColor = [UIColor whiteColor];
    signLabel.layer.masksToBounds = YES;
    signLabel.layer.cornerRadius = 2;
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.backgroundColor = [UIColor colorWithHex:0xff2741];
    signLabel.font = [UIFont systemFontOfSize:12];
    if (self.item.commodityItemType) {
        //打活动标签 赠品标签
        signLabel.text = [MKMarketItem textForType:self.item.commodityItemType];
        CGFloat widths = GetWidthOfString(signLabel.text,16.0f,[UIFont systemFontOfSize:10.0f])+6.0f;
        signLabel.hidden = NO;
        [self.contentView addSubview:signLabel];
        [signLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.skuLabel withOffset:0];
        [signLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.iconImageView withOffset:0];
        [signLabel autoSetDimension:(ALDimensionHeight) toSize:16.0f];
        [signLabel autoSetDimension:(ALDimensionWidth) toSize:widths+10];
    }else{
        signLabel.hidden = NO;
        if (signLabel) {
            signLabel = nil;
            [signLabel removeFromSuperview];
        }
    }
    
    //    发货方式：0 未指定，1一般进口，2保税区发货，3海外直邮
    
//    if (self.item.deliveryType == 1) {
//        self.deliveryTypeLabel.text = @"一般进口";
//    }
//    else if (self.cartItem.deliveryType == 2) {
//        self.deliveryTypeLabel.text = @"保税区发货";
//    }
//    else if (self.cartItem.deliveryType == 3) {
//        self.deliveryTypeLabel.text = @"海外直邮";
//    }
//    else{
//        self.deliveryTypeLabel.hidden = YES;
//    }
}
@end
