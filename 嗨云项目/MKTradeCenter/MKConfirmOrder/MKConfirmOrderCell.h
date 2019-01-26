//
//  MKConfirmOrderCell.h
//  YangDongXi
//
//  Created by windy on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCartItemObject.h"
#import "MKMarketItem.h"

@interface MKConfirmOrderCell : UITableViewCell

@property (strong,nonatomic) MKCartItemObject *cartItem;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong)MKMarketItem *item;

+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

- (void)layoutCellSubviews;

- (void)layoutCellModel;

@end
