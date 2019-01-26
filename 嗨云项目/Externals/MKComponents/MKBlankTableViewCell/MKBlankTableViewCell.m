//
//  MKBlankTableViewCell.m
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBlankTableViewCell.h"
#import "UIColor+MKExtension.h"

#define kDefineBlankBackgroundColor @"e5e5e5"

@implementation MKBlankTableViewCell

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    [super updateWithEntryObject:object];
    
    [self setBottomSeperatorLineMarginLeft:0 rigth:0];
    
    [self blankCell];
}

+ (CGFloat)cellHeight
{
    return 10.0;
}

/*
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self blankCell];
    }
    return self;
}

- (void)awakeFromNib
{
    [self blankCell];
}
*/

- (void)blankCell
{
    MKMarketingObject *cellInformation = [self.entryObject.values objectAtIndex:0];
    
    NSString *bgColorInHex = cellInformation.bgColor;
    
    if(bgColorInHex && [bgColorInHex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
    {
        self.backgroundColor = [UIColor colorWithHexString:[bgColorInHex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:[bgColorInHex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithHexString:kDefineBlankBackgroundColor];
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:kDefineBlankBackgroundColor];
    }
    
}

@end
