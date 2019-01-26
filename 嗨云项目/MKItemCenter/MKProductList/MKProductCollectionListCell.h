//
//  MKProductCollectionListCell.h
//  YangDongXi
//
//  Created by Constance Yang on 25/07/2015.
//  Copyright (c) 2015 yangdongxi. All rights reserved.
//

#import "MKBaseTableViewCell.h"
#import "UIView+MKExtension.h"
#import "MKItemObject.h"
#import "MKStrikethroughLabel.h"
#import "MKMarketingComponentObject.h"

@class MKProductCollectionListCell;

@protocol  MKProductCollectionListCellDelegate <NSObject>

-(void)didSelect:(MKItemObject *)item;

@end

@interface MKProductCollectionListCell : MKBaseTableViewCell

@property (weak,nonatomic) id<MKProductCollectionListCellDelegate>delegate;
/**
 * choose either of the following method to update data
 */

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object;

- (void)updateWithArray:(NSArray *)objectsArray;

@end
