//
//  MKOrderDetailCostTableViewCell.h
//  YangDongXi
//
//  Created by cocoa on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKOrderDetailCostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *freightLabel;  //运费

@property (weak, nonatomic) IBOutlet UILabel *discountLabel; //活动优惠

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel; //代金券

@property (weak, nonatomic) IBOutlet UILabel *totalMoney;    //实付款

+ (CGFloat)cellHeight;

@end
