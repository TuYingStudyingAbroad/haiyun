//
//  HYShopInvitationView.h
//  嗨云项目
//
//  Created by haiyun on 16/8/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseScrollView.h"

@class HYShopIntvitationBottomView;
@interface HYShopInvitationView : HYBaseScrollView

@end

@protocol HYShopIntvitationBottomViewDelegate <NSObject>

@optional
/**
 *  代理方法
 *
 *  @param bottomView bottomView description
 *  @param types      1，邀请，2转跳url
 */
-(void)shopIntvitationBottomView:(HYShopIntvitationBottomView *)bottomView types:(NSInteger)types;

@end

@interface HYShopIntvitationBottomView : UIView

@property(nonatomic, weak) __weak id<HYShopIntvitationBottomViewDelegate> delegate;

@property (nonatomic, copy) NSString *shopImageName;

@property (nonatomic, copy) NSString *shopTitle;

@property (nonatomic, copy) NSString *shopNumRight;

@property (nonatomic, copy) NSString *shopNum;

@property (nonatomic, copy) NSString *shopUrl;

@property (nonatomic, copy) NSString *shopContent;

-(void)setShopNumMsg:(NSString *)numMsg;
@end