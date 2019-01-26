//
//  MKOrderOperationTableViewCell.h
//  YangDongXi
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseTableViewCell.h"

@interface MKOrderOperationTableViewCell : MKBaseTableViewCell

/**
 @brief 从右往左排
 */
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;

@end
