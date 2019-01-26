//
//  firstSeckillingCutDownView.h
//  嗨云项目
//
//  Created by 小辉 on 16/10/12.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol firstSeckillingCutDownViewDelegate <NSObject>

- (void)firstSeckillingCutDownViewImgVClick:(NSInteger) tag;

@end

#import "seckillingBtnView.h"
@interface firstSeckillingCutDownView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeCutDownLab;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *firstSeckillingTitleLab;
@property (strong,nonatomic) seckillingBtnView * seckillingBV;
@property (nonatomic, weak) id <firstSeckillingCutDownViewDelegate> delegate;
- (void)setUpATopScrollMenu:(NSArray *)menuItems;

-(void)changeTime:(NSInteger) location;
@end
