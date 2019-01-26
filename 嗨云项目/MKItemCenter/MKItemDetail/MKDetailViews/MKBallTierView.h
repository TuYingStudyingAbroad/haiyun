//
//  MKBallTierView.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCouponObject.h"
#import "MKExceptionView.h"



typedef NS_ENUM(NSInteger, MKPopUpHierarchy) {
    /**
     *      @brief 优惠劵
     */
    MKPopUpHierarchyCoupon,
    
    /**
     *      @brief 满减赠
     */
    MKPopUpHierarchyReduction,
};
@protocol MKPopUpHierarchyDelegate <NSObject>
/**
 *      @brief 确认订单选取优惠劵
 *
 *      @param couponItem 返回优惠劵对象
 */
- (void)didSelectCouponObject:(MKCouponObject*)couponItem;

@end

@interface MKBallTierView : UIView
/**
 *      @brief 优惠劵弹出的时候样式 type 为1时 确认订单的调用 默认为0
 */
@property (nonatomic,assign)NSInteger type;

/**
 *      @brief objectItem 确认订单传入的
 */
@property (nonatomic,strong)MKCouponObject *objectItem;

@property (nonatomic,assign)id<MKPopUpHierarchyDelegate> delegate;

/**
 *      @brief 占位图信息
 */
@property (nonatomic,strong)MKExceptionView *exceptionView;


/**
 *      @brief 用户所选择的对象
 */
@property (nonatomic,strong)NSMutableArray *seleArray;


- (void)MKPopUpHierarchywithType:(MKPopUpHierarchy)type withDataArray:(NSMutableArray *)dataArray;


- (void)show;


- (void)dismiss:(void (^)(void))completion;


//- (void)updataWithDataArray:(NSMutableArray *)dataArray;

@end
