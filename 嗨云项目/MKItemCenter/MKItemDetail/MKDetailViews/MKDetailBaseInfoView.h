//
//  MKDetailBaseInfoView.h
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MKExtension.h"
#import "MKStrikethroughLabel.h"

@interface MKDetailBaseInfoView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *supplyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *taxMarkImageView;
@property (nonatomic, weak) IBOutlet UILabel *originPriceLabel;


@property (weak, nonatomic) IBOutlet UIView *limitedView;

@property (weak,nonatomic) IBOutlet UIView *freePostageView;

- (void)hideOriginPrice:(BOOL)hide;
-(void)hideLimitedView:(NSInteger)itemType skuNum:(BOOL)cannotBuy;
@end
