//
//  MKMarketingStyle4Cell.m
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//
#import "MKMarketingStyle4Cell.h"
#import "MKMarketingStyle4View.h"
#import <UIButton+WebCache.h>

@interface MKMarketingStyle4Cell ()

@property (nonatomic, strong) MKMarketingStyle4View *view;

@end


@implementation MKMarketingStyle4Cell

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    [super updateWithEntryObject:object];
    if (self.view == nil)
    {
        self.view = [MKMarketingStyle4View loadFromXib];
        [self.contentView addSubview:self.view];
        [self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [self.contentView bringSubviewToFront:self.bottomSeperatorLine];
    }
    NSInteger index = 0;
    for (MKMarketingObject *obj in object.values)
    {
        UIButton *button = self.view.buttons[index];
        button.adjustsImageWhenHighlighted = NO;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:obj.imageUrl]
                                    forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:)
                           forControlEvents:UIControlEventTouchUpInside];
        button.tag = index ++ ;
    }
}

+ (CGFloat)cellHeight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width * 360 / 640;
}

- (void)buttonClick:(UIButton *)button
{
    MKMarketingObject *obj = self.entryObject.values[button.tag];
    [self.delegate marketingCell:self didClickWithUrl:obj.targetUrl];
}

@end
