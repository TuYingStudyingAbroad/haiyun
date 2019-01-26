//
//  MKMarketingBannerCell.m
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketingBannerCell.h"
#import "MKRollImagesView.h"

@interface MKMarketingBannerCell () <MKRollImagesViewDelegate>

@property (nonatomic, strong) MKRollImagesView *rollImageView;

@end


@implementation MKMarketingBannerCell

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    [super updateWithEntryObject:object];
    
    if (self.rollImageView == nil)
    {
        self.rollImageView = [[MKRollImagesView alloc] init];
        self.rollImageView.placeHolderImage = [UIImage imageNamed:@"placeholder_320x189"];
        self.rollImageView.delegate = self;
        [self.rollImageView autoRollEnable:YES];
        [self.contentView addSubview:self.rollImageView];
        [self.rollImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    
    NSMutableArray *urls = [NSMutableArray array];
    
    for (MKMarketingObject *ob in object.values)
    {
        if (ob.imageUrl) {
             [urls addObject:ob.imageUrl];
        }
       
    }
    self.rollImageView.bannerUrls = urls;
}

+ (CGFloat)cellHeight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width / 640 * 300;
}

- (void)rollImagesView:(MKRollImagesView *)rollView didClickIndex:(NSInteger)index
{
    if ( index <0 || index >= self.entryObject.values.count ) {
        return;
    }
    if ( self.delegate && [self.delegate respondsToSelector:@selector(marketingCell:didClickWithUrl:)]) {
        [self.delegate marketingCell:self didClickWithUrl:[self.entryObject.values[index] targetUrl]];
    }
}

@end
