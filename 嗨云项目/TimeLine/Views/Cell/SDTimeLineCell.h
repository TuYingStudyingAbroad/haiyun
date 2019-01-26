//
//  SDTimeLineCell.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol SDTimeLineCellDelegate <NSObject>

//- (void)didClickLickButtonInCell:(UITableViewCell *)cell;
//- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;

-(void)share:(NSIndexPath *)indexPath;

@end

@class SDTimeLineCellModel;

@interface SDTimeLineCell : UITableViewCell



@property (nonatomic, strong) SDTimeLineCellModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
@property (nonatomic,strong) id <SDTimeLineCellDelegate> cellDelegate;

@end
