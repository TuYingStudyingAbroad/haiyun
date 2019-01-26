//
//  HYKeywordView.h
//  嗨云项目
//
//  Created by haiyun on 16/9/20.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

@class HYOnewordView;

@protocol HYOnewordViewDelegate <NSObject>

///1删除，2点击搜索，3显示删除按钮
- (void)onewordView:(HYOnewordView *)wordView changeIndex:(NSInteger)index;

@end

#import <UIKit/UIKit.h>


@interface HYOnewordView : UIView
//是否可以点击
@property (nonatomic,assign) BOOL isTag;
@property (weak, nonatomic) IBOutlet UIButton *keyBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@property (weak, nonatomic) __weak id<HYOnewordViewDelegate>delegate;
@end
