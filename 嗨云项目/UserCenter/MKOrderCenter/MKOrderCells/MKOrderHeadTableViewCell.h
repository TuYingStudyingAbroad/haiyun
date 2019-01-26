//
//  MKOrderHeadTableViewCell.h
//  YangDongXi
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseTableViewCell.h"

@interface MKOrderHeadTableViewCell : MKBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
