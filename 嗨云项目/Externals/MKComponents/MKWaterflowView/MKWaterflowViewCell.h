//
//  MKWaterflowViewCell.h
//  MKBaseLibDemo
//
//  Created by windy on 15/4/3.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKWaterflowViewLayout.h"

@interface MKWaterflowViewCell : UIView

@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, strong, readonly) MKWaterflowViewLayoutAttributes *layoutAttributes;

- (void)applyLayoutAttributes:(MKWaterflowViewLayoutAttributes *)layoutAttributes;

- (void)prepareForReuse;
@end