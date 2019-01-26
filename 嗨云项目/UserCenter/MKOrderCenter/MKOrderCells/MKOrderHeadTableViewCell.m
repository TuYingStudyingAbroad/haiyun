//
//  MKOrderHeadTableViewCell.m
//  YangDongXi
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKOrderHeadTableViewCell.h"

@implementation MKOrderHeadTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (CGFloat)cellHeight
{
    return 30;
}

@end
