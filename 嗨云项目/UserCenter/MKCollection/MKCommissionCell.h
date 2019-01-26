//
//  MKCommissionCell.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCollectionShop.h"

@interface MKCommissionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeNmae;
@property (weak, nonatomic) IBOutlet UILabel *detailsName;
@property (weak, nonatomic) IBOutlet UIImageView *storeIcon;
@property (weak, nonatomic) IBOutlet UIButton *deleBut;


@property (strong,nonatomic)MKCollectionShop *shopItem;

- (void)cellWithLoda;

@end
