//
//  MKMarketingCell.m
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketingCell.h"

@implementation MKMarketingCell

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    self.entryObject = object;
    
    self.bottomSeperatorLine.hidden = YES;
}


@end
