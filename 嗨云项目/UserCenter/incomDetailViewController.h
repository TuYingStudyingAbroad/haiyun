//
//  incomDetailViewController.h
//  嗨云项目
//
//  Created by kans on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "THSegmentedPager.h"

#import "incomeListViewController.h"


@protocol incomDetailViewControllerDelegate

- (void)detailDetailViewControllerNeedScrollToTop;

@end



@interface incomDetailViewController : THSegmentedPager

@property (nonatomic,assign)NSInteger orderStatus;

@property (nonatomic,strong)incomeListViewController * incomelistVC;
@property (nonatomic, weak) id<incomDetailViewControllerDelegate> delegate;


- (void)enableScroll:(BOOL)enable;
@end
