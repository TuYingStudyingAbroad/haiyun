//
//  HYPlaceTheOrderView.h
//  嗨云项目
//
//  Created by haiyun on 16/9/22.
//  Copyright © 2016年 杨鑫. All rights reserved.
//


@class HYPayBaseCellView;

#import "HYBaseView.h"

/*****************协议************************/
@protocol HYPayBaseCellViewDelegate <NSObject>
@optional
-(void)onButtonCellView:(HYPayBaseCellView *)cellView
                   Type:(NSInteger)nType;
@end

/*****************BaseCell************************/
@interface HYPayBaseCellView : UITableViewCell
{

}
@property(nonatomic,weak) __weak id<HYPayBaseCellViewDelegate> delegate;

-(void)setMenuMsgDict:(NSMutableDictionary *)MenuMsgDict
          bHiddenLine:(BOOL)bhidden;

@end
/*********TopCell************/
@interface HYPayTopUITableViewCell : HYPayBaseCellView


@end

/*********PayWay************/
@interface HYPayWayUITableViewCell : HYPayBaseCellView


@end

/*********PayGo************/
@interface HYPayGoUITableViewCell : HYPayBaseCellView


@end

/***************HYPlaceTheOrderView*********************/
@interface HYPlaceTheOrderView : HYBaseView

-(void)setMessageArr:(NSMutableArray *)MesArr;

@end


