//
//  MKDetailBrandZoneView.m
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDetailBrandZoneView.h"

@implementation MKDetailBrandZoneView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.inButton.layer.borderWidth = 1.0f;
    self.inButton.layer.borderColor = kHEXCOLOR(0x666666).CGColor;
}

@end
