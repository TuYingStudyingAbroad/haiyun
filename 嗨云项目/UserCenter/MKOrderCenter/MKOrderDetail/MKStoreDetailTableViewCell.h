//
//  MKStoreDetailTableViewCell.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDistributorOrderItemList.h"

@interface MKStoreDetailTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (nonatomic,strong)MKDistributorOrderItemList *item;

+(CGFloat)cellHeight;
@end
