//
//  MKSlidingView.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/6/1.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PureLayout.h>
#import <UIImageView+WebCache.h>
#import "MKMarketingListItem.h"
#import "MKItemObject.h"
#import "MKStrikethroughLabel.h"
#import "MKMarketingComponentObject.h"
#import "MKSlidingCell.h"


@protocol MKSlidingViewMKMarketingComponentObjectDelegate <NSObject>

- (void)slidingCellWithListItem:(MKMarketingListItem *)object;

@end
@interface MKSlidingView : UIView



@property (nonatomic,strong)MKMarketingComponentObject *entryObject;


@property (nonatomic,assign)id<MKSlidingViewMKMarketingComponentObjectDelegate> delegate;
- (void)slidingViewWith:(NSArray *)itemArray;

@end
