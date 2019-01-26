//
//  HYAcountSafeView.h
//  嗨云项目
//
//  Created by YanLu on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYUIBaseCellView,HYAcountSafeView,YLSafeUserInfo;
/******************************/
@protocol HYUIBaseCellViewDelegate <NSObject>
@optional
-(void)onButtonCellView:(HYUIBaseCellView *)cellView Type:(NSInteger)nType;
@end

@protocol HYAcountSafeViewDelegate <NSObject>

@optional
- (void)showSafeView:(HYAcountSafeView *)safeView InfoType:(NSInteger )type;
@end

/******************************/
@interface HYUIBaseCellView : UITableViewCell
{
}
@property(nonatomic, weak) __weak id<HYUIBaseCellViewDelegate> delegate;
-(void)setMenuMsgDict:(NSMutableDictionary *)MenuMsgDict bHiddenLine:(BOOL)bhidden;
@end

//cell
@interface HYAccountUITableViewCell : HYUIBaseCellView

@end

/*************************************/
@interface HYAcountSafeView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) __weak id<HYAcountSafeViewDelegate> delegate;
@property (nonatomic,strong) UITableView        *pTableView;
@property (nonatomic,retain) NSMutableArray     *ArrayGrid;

-(void)sentSafeView:(YLSafeUserInfo *)userInfo;
@end
