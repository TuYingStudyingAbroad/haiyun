//
//  fansSortView.h
//  嗨云项目
//
//  Created by 小辉 on 16/8/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//


@protocol fansSortViewDelegate <NSObject>

- (void)didPressBtnTag:(NSInteger)btnTag withUPDown:(NSInteger)ud;
@end


#import <UIKit/UIKit.h>
#import "FL_Button.h"
@interface fansSortView : UIView




@property (weak, nonatomic) IBOutlet FL_Button *timeBtn;

@property (weak, nonatomic) IBOutlet FL_Button *incomeBtn;
@property (assign, nonatomic) NSInteger btnTag;

@property (weak,nonatomic) id<fansSortViewDelegate>delegate;

@end
