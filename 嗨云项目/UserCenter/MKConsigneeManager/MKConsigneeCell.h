//
//  MKConsigneeCell.h
//  YangDongXi
//
//  Created by windy on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKConsigneeObject.h"

@interface MKConsigneeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstAdressLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *idNo;

@property (nonatomic,strong) MKConsigneeObject *consigneeItem;

@property (nonatomic,strong) MKConsigneeObject *selectedConsignee;

@property (assign, nonatomic) BOOL canEditConsignee;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

- (void)layoutCellSubviews;

+ (CGFloat)cellHeight;

@end
