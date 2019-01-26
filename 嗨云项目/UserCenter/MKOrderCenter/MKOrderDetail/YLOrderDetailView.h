//
//  YLOrderDetailView.h
//  嗨云项目
//
//  Created by YanLu on 16/5/17.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

typedef enum {
    OrderStatusNoPay,//待付款
    OrderStatusNoSetting,//待发货
    OrderStatusSetting,//待收货
    OrderStatusCancel,//已取消
    OrderStatusClose,//已关闭
} OrderStauts;

#import <UIKit/UIKit.h>
#import "MKOrderObject.h"

@class YLUIBaseCellView,YLOrderDetailView,YLOrderBottomView;
/******************************/
@protocol YLUIBaseCellViewDelegate <NSObject>
@optional
-(void)onButtonCellView:(YLUIBaseCellView *)cellView Type:(NSInteger)nType;
@end

@protocol YLOrderDetailViewDelegate <NSObject>

@optional
/**
 *  订单详情代理
 *
 *  @param orderView
 *  @param type       0 支付，1确认收货，2查看物流
 */
- (void)showOrderDetailView:(YLOrderDetailView *)orderView InfoType:(NSInteger )type;
@end

#pragma mark -底部的代理
@protocol YLOrderBottomViewwDelegate <NSObject>
@optional
/**
 *  底部点击代理
 *
 *  @param bottomView
 *  @param nType      0 支付，1确认收货，2查看物流
 */
-(void)onButtonBottomView:(YLOrderBottomView *)bottomView Type:(NSInteger)nType;
@end

/******************************/
@interface YLUIBaseCellView : UITableViewCell
{
}
@property(nonatomic, weak) __weak id<YLUIBaseCellViewDelegate> delegate;
-(void)setMenuMsgDict:(id)MenuMsgDict bHiddenLine:(BOOL)bhidden;
@end

/****cell顶部****/
@interface YLOrderStatusTopUITableViewCell : YLUIBaseCellView

@end

/****cell地址****/
@interface YLOrderStatusAddressUITableViewCell : YLUIBaseCellView

@end

/****cell店铺名字****/
@interface YLOrderStatusShipNameUITableViewCell : YLUIBaseCellView

@end
/****cell商品****/
@interface YLOrderStatusShipUITableViewCell : YLUIBaseCellView

-(void)setMenuMsgDict:(id)MenuMsgDict
       setOrderObject:(id)orderObject
                  tag:(NSString *)activityTags
                 hide:(BOOL)hides;
@end

/****cell优惠券信息****/
@interface YLOrderStatusOtherUITableViewCell : YLUIBaseCellView

-(void)setMenuMsgDict:(id)MenuMsgDict;

@end
/****Cell赠品***/

@interface YLOrderGiftTableViewCell : YLUIBaseCellView



@end

/****cell时间****/
@interface YLOrderStatusTimeUITableViewCell : YLUIBaseCellView

@end
/****cell客服入口****/
@interface HYOrderServiceUITableViewCell : YLUIBaseCellView

@end

/**************底部View*******************************/
@interface YLOrderBottomView : UIView

/**
 *  更新底部信息
 *
 *  @param orderStatus 1待支付  0待收货 2 已完成
 *  @param prices      价格
 */
-(void)setOrderBottomStatus:(NSInteger)orderStatus price:(NSString *)prices num:(NSInteger)nums;

@property (nonatomic, weak) __weak id <YLOrderBottomViewwDelegate> delegate;

@end

/**************YLOrderDetailView*******************************/
@interface YLOrderDetailView : UIView<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,weak) __weak id<YLOrderDetailViewDelegate> delegate;
@property (nonatomic,strong) UITableView        *pTableView;
@property (nonatomic,strong) NSMutableDictionary     *nsDict;


@property (nonatomic, strong) MKOrderObject *order;

-(void)setInfDict:(NSDictionary *)nsDict;

@property (nonatomic, strong) NSString *orderUid;

@end
