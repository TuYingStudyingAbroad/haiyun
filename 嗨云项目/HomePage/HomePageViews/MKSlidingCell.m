//
//  MKSlidingCell.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/17.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKSlidingCell.h"
#import <PureLayout.h>
#import <UIImageView+WebCache.h>
#import "MKMarketingListItem.h"
#import "MKItemObject.h"
#import "MKStrikethroughLabel.h"
#import "MKSlidingView.h"



@interface MKSlidingCell ()<MKSlidingViewMKMarketingComponentObjectDelegate>


@property (nonatomic,strong)MKSlidingView *slidingView;

@end

@implementation MKSlidingCell



- (void)updateWithEntryObject:(MKMarketingComponentObject *)object{
    [super updateWithEntryObject:object];
    NSArray *arr =[object.values[0] productList];
    [self.slidingView removeFromSuperview];
    self.slidingView = nil;
    if (!self.slidingView) {
        self.slidingView = [[MKSlidingView alloc]init];
       
        [self addSubview:self.slidingView ];
        self.slidingView.delegate = self;
        [self.slidingView autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsetsZero)];
    }
    self.slidingView.entryObject = object;
    [self.slidingView slidingViewWith:arr];
}

- (void)slidingCellWithListItem:(MKMarketingListItem *)object{
    [self.delegate marketingCell:self didClickWithUrl:object.targetUrl];
}
//- (void)handleClickAction:(UIButton *)sender{
//    NSArray *arr =[self.entryObject.values[0] productList];
//    MKMarketingListItem *object = arr[sender.tag - 1];
//    [self.delegate marketingCell:self didClickWithUrl:object.targetUrl];
//}
+ (CGFloat)cellHeight{
    return 165;
}


@end
