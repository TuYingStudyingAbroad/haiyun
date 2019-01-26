//
//  HYUpdateTipsView.h
//  嗨云项目
//
//  Created by haiyun on 16/8/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^didSelect)(NSInteger nTipsIndex);

@interface HYUpdateTipsView : UIView

@property (nonatomic,copy)NSString * nsTitle;
@property (nonatomic,copy)NSString * nsTips;
@property (nonatomic,copy)NSString * nsleft;
@property (nonatomic,copy)NSString * nsright;
@property (nonatomic,strong)didSelect tipsselect;

@end
