//
//  MKTinyItemTableViewCell.h
//  YangDongXi
//
//  Created by cocoa on 15/5/12.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseTableViewCell.h"

#import "MKHistoryItemObject.h"

/**@brief 用在收藏列表，浏览历史*/
@interface MKTinyItemTableViewCell : MKBaseTableViewCell

@property (nonatomic, strong) IBOutlet UIButton *checkButton;

@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@property (nonatomic,strong)MKHistoryItemObject *objModel;


- (void)enableEdit:(BOOL)edit animation:(BOOL)animation;

@end
