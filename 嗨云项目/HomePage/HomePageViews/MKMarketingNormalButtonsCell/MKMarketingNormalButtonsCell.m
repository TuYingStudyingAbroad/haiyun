//
//  MKMarketingNormalButtonsCell.m
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketingNormalButtonsCell.h"
#import "MKMarketingButtonView.h"
#import "MKMarketingSingleLineView.h"
#import <UIImageView+WebCache.h>

@interface MKMarketingNormalButtonsCell ()
{

}

@property (nonatomic, strong) MKMarketingSingleLineView *singleLineView;

@end


@implementation MKMarketingNormalButtonsCell

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    [super updateWithEntryObject:object];
    
    if (self.singleLineView != nil)
    {
        [self.singleLineView removeFromSuperview];
        
        self.singleLineView = nil;
    }
    
    NSMutableArray *ar = [NSMutableArray array];
    
    NSInteger index = 0;
    
    for (int tempIndex = 0; tempIndex < object.values.count; tempIndex ++)
    {
        MKMarketingButtonView *b = [MKMarketingButtonView loadFromXib];
        
        [b.button addTarget:self action:@selector(buttonClick:)
           forControlEvents:UIControlEventTouchUpInside];
        
        MKMarketingObject *obj = [object.values objectAtIndex:tempIndex];
        
        [b.imageView sd_setImageWithURL:[NSURL URLWithString:obj.imageUrl]];
        
        b.titleLabel.text = obj.text;
        
        [ar addObject:b];
        
        b.button.tag = index ++ ;
    }
    
    /*
    for (MKMarketingObject *obj in object.values)
    {
        MKMarketingButtonView *b = [MKMarketingButtonView loadFromXib];
        
        [b.button addTarget:self action:@selector(buttonClick:)
           forControlEvents:UIControlEventTouchUpInside];
        
        [b.imageView sd_setImageWithURL:[NSURL URLWithString:obj.imageUrl]];
        
        b.titleLabel.text = obj.text;
        
        [ar addObject:b];
        
        b.button.tag = index ++ ;

    }
     */
    
    self.singleLineView = [[MKMarketingSingleLineView alloc] init];
    
    [self.singleLineView updateViews:ar];
    
    [self.contentView insertSubview:self.singleLineView atIndex:0];
    
    [self.singleLineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [super setBottomSeperatorLineMarginLeft:0 rigth:0];
}

- (void)buttonClick:(UIButton *)button
{
    MKMarketingObject *obj = self.entryObject.values[button.tag];
    
    [self.delegate marketingCell:self didClickWithUrl:obj.targetUrl];
}

+ (CGFloat)cellHeight
{
    return 79.0;
}

@end
