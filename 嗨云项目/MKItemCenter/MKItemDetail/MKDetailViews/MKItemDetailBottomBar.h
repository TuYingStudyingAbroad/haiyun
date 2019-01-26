//
//  MKItemDetailBottomBar.h
//  YangDongXi
//
//  Created by cocoa on 15/4/28.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "UIView+MKExtension.h"

@interface MKItemDetailBottomBar : UIView

@property (nonatomic, strong) IBOutlet UIButton *addToCartButton;

@property (nonatomic, strong) IBOutlet UIButton *purchaseButton;

@property (nonatomic, strong) IBOutlet UIButton *cartButton;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonWidth;

- (void)updateShoppingCountValue:(NSInteger)value;

@end
