//
//  MKOrderDetailInfoTableViewCell.h
//  YangDongXi
//
//  Created by cocoa on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKOrderDetailInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel; //订单编号

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;   //订单时间

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel; //订单状态

+ (CGFloat)cellHeight;

@end
