//
//  HYCollectionLeftViewCell.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/6/24.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKStrikethroughLabel.h"

@interface HYCollectionLeftViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet MKStrikethroughLabel *originalPrice;

@end
