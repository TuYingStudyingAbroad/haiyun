//
//  MKBaseTableViewCell.h
//  YangDongXi
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKBaseTableViewCell : UITableViewCell

/**
 @brief 分割线
 @discussion 默认颜色#e5e5e5，默认边距左右12.5
 */
@property (nonatomic, strong) UIView *bottomSeperatorLine;

/**
 @brief 设置分割线左右间距
 */
- (void)setBottomSeperatorLineMarginLeft:(CGFloat)left rigth:(CGFloat)right;

/**
 @brief 子类要调用父类的
 */
- (void)awakeFromNib;

/**
 @brief 单元格高度，子类覆盖返回默认高度
 */
+ (CGFloat)cellHeight;

@end
