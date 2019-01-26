//
//  MKBaseTableViewCell.m
//  YangDongXi
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseTableViewCell.h"
#import <PureLayout.h>
#import "UIColor+MKExtension.h"

@interface MKBaseTableViewCell ()

@property (nonatomic, strong) NSLayoutConstraint *bottomSeperatorLineMarginLeft;

@property (nonatomic, strong) NSLayoutConstraint *bottomSeperatorLineMarginRight;

@end


@implementation MKBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self baseInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self baseInit];
}

- (void)baseInit
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bottomSeperatorLine = [[UIView alloc] init];
    self.bottomSeperatorLine.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    [self.contentView addSubview:self.bottomSeperatorLine];
    [self.bottomSeperatorLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    self.bottomSeperatorLineMarginLeft =
        [self.bottomSeperatorLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:12.5];
    self.bottomSeperatorLineMarginRight =
        [self.bottomSeperatorLine autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:12.5];
    [self.bottomSeperatorLine autoSetDimension:ALDimensionHeight toSize:0.5f];
}

- (void)setBottomSeperatorLineMarginLeft:(CGFloat)left rigth:(CGFloat)right
{
    self.bottomSeperatorLineMarginLeft.constant = left;
    self.bottomSeperatorLineMarginRight.constant = right;
}

+ (CGFloat)cellHeight
{
    return 44;
}

@end
