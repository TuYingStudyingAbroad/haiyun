//
//  HYMainNotDataView.h
//  嗨云项目
//
//  Created by haiyun on 16/5/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYMainNotDataView;

@protocol HYMainNotDataViewDelegate <NSObject>

-(void)reloadDataView:(HYMainNotDataView *)noView;

@end

@interface HYMainNotDataView : UIView

@property (nonatomic,weak)  id <HYMainNotDataViewDelegate> delegate;


@end
