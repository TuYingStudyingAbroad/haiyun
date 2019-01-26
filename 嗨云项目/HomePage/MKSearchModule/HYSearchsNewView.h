//
//  HYSearchsNewView.h
//  嗨云项目
//
//  Created by haiyun on 16/9/20.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

@class HYSearchsNewView;

@protocol HYSearchsNewViewDelegate <NSObject>

///index:1全部删除，2删除，3点击,4点击热词，tags删除的那个，点击的那个
- (void)searchsNewView:(HYSearchsNewView *)searchView changeIndex:(NSInteger)index tags:(NSInteger)tags;

@end


#import <UIKit/UIKit.h>


@interface HYSearchsNewView : UIView

- (void)buildSearchsNewView:(NSArray *)props title:(NSString *)titles isRight:(BOOL)isHide;

@property (nonatomic, strong) NSArray *propertyButtons;
@property (nonatomic,assign)CGFloat abc ;

@property (weak, nonatomic) __weak id<HYSearchsNewViewDelegate>delegate;

@end
