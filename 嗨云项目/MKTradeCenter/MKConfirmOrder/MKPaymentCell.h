//
//  MKPaymentCell.h
//  YangDongXi
//
//  Created by windy on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKPaymentCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *paymentLabel;

@property (nonatomic,weak) IBOutlet UIImageView *paymentImageView;

@property (nonatomic,weak) IBOutlet UIButton *paymentBtn;

@property (nonatomic, strong) IBOutlet UILabel *tipLabel;

@end
