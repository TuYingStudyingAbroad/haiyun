//
//  HYSafeBandCardView.h
//  嗨云项目
//
//  Created by haiyun on 16/8/31.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

@class HYSafeCardView,HYSafeBandInfo;
@protocol HYSafeCardViewDelegate <NSObject>

@optional
/**
 *  返回上传后图片URl
 *
 *  @param safeView HYSafeCardView
 *  @param imageUrl 上传图片URL
 *  @param index    1背面，0正面
 */
-(void)safeCardView:(HYSafeCardView *)safeView
           imageUrl:(NSString *)imageUrl
              index:(NSInteger)index;

@end

#import "HYBaseScrollView.h"

@interface HYSafeBandCardView : HYBaseScrollView

-(void)onButtonClickRight;


@end

/*************照片******************/
@interface HYSafeCardView : UIView

/**
 *  YES仅仅展示，NO可以上传
 */
@property (nonatomic,assign) BOOL isOnlyShow;
@property (nonatomic,copy) NSString *leftImageStr;
@property (nonatomic,copy) NSString *rightImageStr;

@property (nonatomic,weak) __weak id<HYSafeCardViewDelegate> delegate;

@end

/***********已经信息，没有成功或在审核中****************/
@interface HYSafeNoCardView : HYBaseScrollView

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cardId;
/**
 *  是否拒绝，YES在审核，NO拒绝
 */
@property (nonatomic, assign) BOOL isReject;

-(void)onButtonClickRight;

-(void)updateMessage:(HYSafeBandInfo *)safeInfo;

@end

