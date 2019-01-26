//
//  MKMarketingComponentTitleCell.m
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketingComponentTitleCell.h"
#import "MKMarketingComponentTitleView.h"

@interface MKMarketingComponentTitleCell ()

@property (nonatomic, strong) MKMarketingComponentTitleView *titleView;

@end


@implementation MKMarketingComponentTitleCell

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    [super updateWithEntryObject:object];
    
    if (self.titleView == nil)
    {
        self.titleView = [MKMarketingComponentTitleView loadFromXib];
        [self.contentView addSubview:self.titleView];
        [self.titleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [self.titleView.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    MKMarketingObject *obj = object.values[0];
    self.titleView.titleLabel.text = obj.title;
    self.titleView.moreImagView.hidden = obj.targetUrl.length == 0;
    self.titleView.button.hidden = obj.targetUrl.length == 0;
    self.titleView.descLabel.text = obj.desc;
    if(obj.borderColor && obj.borderColor.length > 0)
    {
        NSString *colorString = [[obj.borderColor stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
        
        if(colorString.length == 3 || colorString.length == 4 || colorString.length == 6 || colorString.length == 8)
        {
            self.titleView.indicatorView.backgroundColor = [UIColor colorWithHexString:obj.borderColor];
        }
        else
        {
            self.titleView.indicatorView.backgroundColor = [UIColor colorWithHexString:@"FF4B55"];
        }
    }
    
    if(obj.bgColor && obj.bgColor.length > 0)
    {
        NSString *colorString = [[obj.bgColor stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
        
        if(colorString.length == 3 || colorString.length == 4 || colorString.length == 6 || colorString.length == 8)
        {
            self.contentView.backgroundColor = [UIColor colorWithHexString:obj.bgColor];
        }
        else
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
    }
    else
    {
         self.contentView.backgroundColor = [UIColor whiteColor];
    }

}

+ (CGFloat)cellHeight
{
    return 35;
}

- (void)buttonClick:(UIButton *)button
{
    MKMarketingObject *obj = self.entryObject.values[button.tag];
    [self.delegate marketingCell:self didClickWithUrl:obj.targetUrl];
}

@end
