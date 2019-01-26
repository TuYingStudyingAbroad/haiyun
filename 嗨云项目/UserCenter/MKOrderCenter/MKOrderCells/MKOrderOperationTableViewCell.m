//
//  MKOrderOperationTableViewCell.m
//  YangDongXi
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKOrderOperationTableViewCell.h"
#import "UIColor+MKExtension.h"

@implementation MKOrderOperationTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (int i = 0; i < 3; ++i)
    {
        if (i > 0)
        {
            [self.buttons[i] layer].borderColor = [UIColor colorWithHex:0x999999].CGColor;
            [self.buttons[i] layer].borderWidth = 0.5;
        }
        [self.buttons[i] setHidden:YES];

        [self.buttons[i] layer].cornerRadius = 3;
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
