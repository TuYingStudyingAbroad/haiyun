//
//  MKDeliveryDetailCell.h
//  YangDongXi
//
//  Created by windy on 15/5/5.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DeliveryCellPosition)
{
    DeliveryCellPositionMiddle = 0,
    DeliveryCellPositionTop = 1,
    DeliveryCellPositionBottom = 2,
    DeliveryCellPositionSingle = 3,
};

@interface MKDeliveryDetailCell : UITableViewCell

+ (CGFloat)calculateHeightWithContent:(NSString *)content withWidth:(CGFloat)width;

- (void)updateCellPosition:(DeliveryCellPosition)position;

- (void)updateExpressInfo:(NSString *)expressInfo andTime:(NSString *)timeString;

@end

