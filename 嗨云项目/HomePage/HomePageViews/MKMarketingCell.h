//
//  MKMarketingCell.h
//  YangDongXi
//
//  Created by cocoa on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseTableViewCell.h"
#import "MKMarketingComponentObject.h"
#import <PureLayout.h>
#import "UIColor+MKExtension.h"

@class MKMarketingCell;
@protocol MKMarketingCellDelegate <NSObject>

- (void)marketingCell:(MKMarketingCell *)cell didClickWithUrl:(NSString *)url;

@optional

-(void)didCompleteDownloadImage;
-(void)longTouchUpDownLoadImage:(NSString *)imageUrl;

@end

@interface MKMarketingCell : MKBaseTableViewCell

@property (nonatomic, assign) id<MKMarketingCellDelegate> delegate;

@property (nonatomic, strong) MKMarketingComponentObject *entryObject;

@property (assign,nonatomic) int imageCellHeight;

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object;

@end
