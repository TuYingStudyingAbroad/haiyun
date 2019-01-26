//
//  MKMarketingImageCell.m
//  YangDongXi
//
//  Created by Constance Yang on 24/07/2015.
//  Copyright (c) 2015 yangdongxi. All rights reserved.
//

#import "MKMarketingImageCell.h"

#import "MKMarketingSingleLineView.h"

#import <UIButton+WebCache.h>

#import "UIImage+ResizeMagick.h"

#import "MKFlagShared.h"

@interface MKMarketingImageCell()

@property (nonatomic, strong) MKMarketingSingleLineView *singleLineView;

@end

@implementation MKMarketingImageCell

#pragma mark --
#pragma mark -- life cycle method

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    [super updateWithEntryObject:object];
    
    [self setBottomSeperatorLineMarginLeft:0 rigth:0];
    
    if (self.singleLineView != nil)
    {
        [self.singleLineView removeFromSuperview];
        
        self.singleLineView = nil;
    }
    
    NSMutableArray *a = [NSMutableArray array];
    
    NSInteger index = 0;
    
    for (MKMarketingObject *ob in object.values)
    {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        bt.adjustsImageWhenHighlighted = NO;
        
        [bt sd_setImageWithURL:[NSURL URLWithString:ob.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_60x60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(image && image.size.width > 0.0)
            {
                CGFloat ratio = [UIScreen mainScreen].bounds.size.width/image.size.width;
                
                int imageHeight = (int)roundf(image.size.height * ratio);
                
                if(![[MKFlagShared sharedInstance].imageHeightDictionary objectForKey:ob.imageUrl])
                {
                    [[MKFlagShared sharedInstance].imageHeightDictionary setObject:[NSNumber numberWithInt:imageHeight] forKey:ob.imageUrl];
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(didCompleteDownloadImage)])
                    {
                        [self.delegate didCompleteDownloadImage];
                    }
                
                
                }
            }
            
        }];
   
        //bt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        
        bt.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        bt.tag = index ++ ;
        
        [a addObject:bt];
    }
    self.singleLineView = [[MKMarketingSingleLineView alloc] init];
    
    [self.singleLineView updateViews:a withSeperator:YES];
    
    [self.contentView insertSubview:self.singleLineView atIndex:0];
    
    [self.singleLineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)buttonClick:(UIButton *)button
{
    MKMarketingObject *ob = self.entryObject.values[button.tag];
    [self.delegate marketingCell:self didClickWithUrl:ob.targetUrl];
}

+ (CGFloat)cellHeight
{
    return 35.0;
}
@end
