//
//  MKMarketingTopNewsCell.m
//  YangDongXi
//
//  Created by cocoa on 15/5/7.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketingTopNewsCell.h"

#import "MKMarketingTopNewsView.h"

#import <UIImageView+WebCache.h>

#import "NSString+HTML.h"

@interface MKMarketingTopNewsCell ()

@property (nonatomic, strong) MKMarketingTopNewsView *topNewsView;

@end

@implementation MKMarketingTopNewsCell

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    [super updateWithEntryObject:object];
    
    if (self.topNewsView == nil)
    {        
        self.topNewsView = [MKMarketingTopNewsView loadFromXib];
        
        [self.contentView addSubview:self.topNewsView];
        
        [self.topNewsView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        //[self.contentView bringSubviewToFront:self.bottomSeperatorLine];
        
        [self.topNewsView.oneButton addTarget:self action:@selector(buttonClick:)
                             forControlEvents:UIControlEventTouchUpInside];
        
        [self.topNewsView.twoButton addTarget:self action:@selector(buttonClick:)
                             forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (object.values.count > 0)
    {
        MKMarketingObject *ob = object.values[0];
        
        [self.topNewsView.imageView sd_setImageWithURL:[NSURL URLWithString:ob.label]
                                             completed:^(UIImage *image, NSError *error,
                                                         SDImageCacheType cacheType, NSURL *imageURL)
        {
//            image = [UIImage imageWithCGImage:[image CGImage] scale:(image.scale * 2.0)
//                                  orientation:(image.imageOrientation)];
            CGFloat proportion = image.size.width/image.size.height;
            self.topNewsView.headlinesImageViewWidth.constant = 30*proportion;
            self.topNewsView.imageView.image = image;
        }];
    }
    
    NSMutableArray *ar = [NSMutableArray array];
    
    MKMarketingObject *newslist = [object.values objectAtIndex:0];
    
    for (int i = 0; i < newslist.itemList.count ; ++i)
    {
        MKMarketingMarqueeItem *ob = newslist.itemList[i];
        
        NSString *text = [ob.text stringByConvertingHTMLToPlainText];
        
        [ar addObject:text];
    }
    
    [self.topNewsView updateTitles:ar];
}

- (void)buttonClick:(UIButton *)button
{
    NSInteger index = button.tag;
    MKMarketingObject *newslist = [self.entryObject.values objectAtIndex:0];
    
    MKMarketingMarqueeItem *ob = newslist.itemList[index];
    
    [self.delegate marketingCell:self didClickWithUrl:ob.targetUrl];
}

+ (CGFloat)cellHeight
{
    return 35;
}

@end
