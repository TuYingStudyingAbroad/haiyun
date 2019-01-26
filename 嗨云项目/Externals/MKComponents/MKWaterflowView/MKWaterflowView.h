//
//  MKWaterflowView.h
//  MKBaseLibDemo
//
//  Created by windy on 15/4/3.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKWaterflowViewLayout.h"

@class MKWaterflowView;
@class MKWaterflowViewCell;

@protocol MKWaterflowViewDataSource <NSObject>

@required

- (NSInteger)waterflowView:(MKWaterflowView *)waterflowView numberOfItemsInSection:(NSInteger)section;

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (MKWaterflowViewCell *)waterflowView:(MKWaterflowView *)waterflowView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInWaterflowView:(MKWaterflowView *)waterflowView;

@end

@protocol MKWaterflowViewDelegate <UIScrollViewDelegate>

- (void)waterflowView:(MKWaterflowView *)waterflowView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)waterflowView:(MKWaterflowView *)waterflowView didEndDisplayingCell:(MKWaterflowViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface MKWaterflowView : UIScrollView

- (id)initWithFrame:(CGRect)frame flowViewLayout:(MKWaterflowViewLayout *)layout;

@property (nonatomic,strong)MKWaterflowViewLayout *layout;
@property (nonatomic,weak)id<MKWaterflowViewDataSource> dataSource;
@property (nonatomic,weak)id<MKWaterflowViewDelegate> delegate;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

//对所有数据进行重新布局及显示
- (void)reloadData;

//只会对新增数据进行布局及显示
- (void)loadData;

- (NSInteger)numberOfSections;

- (void)deleteAllItems;
@end
