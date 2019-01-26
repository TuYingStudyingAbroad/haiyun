//
//  MKOrderInfoTableViewCell.h
//  YangDongXi
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseTableViewCell.h"

@interface MKOrderInfoTableViewCell : MKBaseTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *numberLabel;

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) IBOutlet UILabel *postageLabel;

@end
