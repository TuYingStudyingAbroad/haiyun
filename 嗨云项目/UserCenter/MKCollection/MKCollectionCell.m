//
//  MKCollectionCell.m
//  YangDongXi
//
//  Created by windy on 15/4/23.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKCollectionCell.h"
#import "NSString+MKExtension.h"
#import <UIImageView+WebCache.h>

@interface MKCollectionCell()

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *checkButtonLeading;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *iconViewLeading;

@end


@implementation MKCollectionCell

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"item"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBottomSeperatorLineMarginLeft:12 rigth:0];
    
    [self addObserver:self forKeyPath:@"item" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    self.titleLabel.text = self.item.itemName;
    self.priceLabel.text = [MKBaseItemObject priceString:self.item.wirelessPrice];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.item.iconUrl]
                          placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
    //self.storeNmae.text = self.item.distributorInfo.shopName;
//    NSLog(@"%@",self.item.distributorInfo.shopName);
}

- (void)enableEdit:(BOOL)edit animation:(BOOL)animation
{
    if (animation)
    {
        [UIView animateWithDuration:0.25f animations:^
        {
            self.checkButtonLeading.constant = edit ? 0 : -self.checkButton.frame.size.width;
            self.iconViewLeading.constant = edit ? 0 : 12;
            [self layoutIfNeeded];
        }];
    }
    else
    {
        self.checkButtonLeading.constant = edit ? 0 : -self.checkButton.frame.size.width;
        self.iconViewLeading.constant = edit ? 0 : 12;
    }
}



+ (CGFloat)cellHeight
{
    return 100;
}

@end
