//
//  MKDetailDetailViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "THSegmentedPager.h"
#import "MKItemObject.h"

@protocol MKDetailDetailViewController

- (void)detailDetailViewControllerNeedScrollToTop;

@end


@interface MKDetailDetailViewController : THSegmentedPager

@property (nonatomic, weak) id<MKDetailDetailViewController> delegate;

- (void)enableScroll:(BOOL)enable;

- (void)loadItem:(MKItemObject *)item;

@end
