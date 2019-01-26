//
//  MKItemDetailBottomBar.m
//  YangDongXi
//
//  Created by cocoa on 15/4/28.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKItemDetailBottomBar.h"
#import "UIColor+MKExtension.h"

@interface MKItemDetailBottomBar ()

@property (nonatomic, strong) IBOutlet UILabel *shoppingCountLabel;

@property (nonatomic, strong) IBOutlet UIView *shoppingCountCycleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingWidth;

@end


@implementation MKItemDetailBottomBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.btnWidth.constant = [UIScreen mainScreen].bounds.size.width / 4 + 10;
    
    self.purchaseButton.exclusiveTouch = YES;
    self.purchaseButton.layer.cornerRadius = 3;
    self.purchaseButton.clipsToBounds = YES;
    self.purchaseButton.backgroundColor = [UIColor colorWithHex:kRedColor];
    
    self.addToCartButton.layer.cornerRadius = 3;
    self.addToCartButton.layer.borderWidth = 1;
    self.addToCartButton.layer.borderColor = [UIColor colorWithHex:kRedColor].CGColor;
    
    self.shoppingCountCycleView.hidden = YES;
    self.shoppingCountCycleView.layer.cornerRadius = 8.0f;
    self.shoppingCountCycleView.layer.masksToBounds = YES;
}

- (void)updateShoppingCountValue:(NSInteger)value
{
    NSString *shopStr = [NSString stringWithFormat:@"%li", (long)value];
//    if ( value >= 100 ) {
//        shopStr = @"99+";
//    }
    self.shoppingCountLabel.text = shopStr;
    self.shoppingCountLabel.hidden = value <= 0;
    self.shoppingCountCycleView.hidden = value <= 0;
    if ( value > 0 )
    {
        CGFloat width = GetWidthOfString(shopStr, 16.0f, [UIFont systemFontOfSize:12.0f]) + 8.0f;
//        width = width>26.0f?26.0f:width;
        self.shoppingWidth.constant = width;
//        self.shoppingHeight.constant = height;
//        self.shoppingCountCycleView.layer.cornerRadius = width/2.0f;

    }
}

@end
