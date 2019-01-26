//
//  MKMarketingstyle48.m
//  YangDongXi
//
//  Created by Constance Yang on 24/07/2015.
//  Copyright (c) 2015 yangdongxi. All rights reserved.
//

#import "MKMarketingstyle48.h"
#import "MKMarketingSingleLineView.h"
#import <UIButton+WebCache.h>

@interface MKMarketingstyle48()

@property (nonatomic, strong) MKMarketingSingleLineView *singleLineView;

@end

@implementation MKMarketingstyle48

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
    
    MKMarketingObject *itemInformation = [object.values objectAtIndex:0];
    
    for (MKMarketingMarqueeItem *ob in itemInformation.itemList)
    {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        bt.adjustsImageWhenHighlighted = NO;
        
        [bt sd_setImageWithURL:[NSURL URLWithString:ob.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
        
        //bt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        
        bt.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        bt.tag = index ++;
        
        [a addObject:bt];
    }
    
    self.singleLineView = [[MKMarketingSingleLineView alloc] init];
    
    [self.singleLineView updateStyle4Views:a withSeperator:itemInformation.needBorder];
    
    //[self.singleLineView updateViews:a withSeperator:itemInformation.needBorder];
    
    [self.contentView insertSubview:self.singleLineView atIndex:0];
    
    [self.singleLineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)buttonClick:(UIButton *)button
{
    MKMarketingObject *ob = self.entryObject.values[0];
    
    MKMarketingMarqueeItem *item = [ob.itemList objectAtIndex:button.tag];
    
    [self.delegate marketingCell:self didClickWithUrl:item.targetUrl];
}

+(CGFloat)cellHeight
{
    return [UIScreen mainScreen].bounds.size.width/2.0;
}

@end
