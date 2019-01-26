//
//  seckillingBtnView.h
//  嗨云项目
//
//  Created by 小辉 on 16/10/13.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class seckillingBtnView;
@protocol seckillingBtnViewDelegate <NSObject>

- (void)seckillingBVBtnClick:(seckillingBtnView *)item;

@end
@interface seckillingBtnView : UIView
@property (weak, nonatomic) IBOutlet UILabel *seckillingBVLab;

@property (nonatomic, weak) id <seckillingBtnViewDelegate> delegate;
@end
