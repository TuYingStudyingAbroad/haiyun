//
//  MKWaterflowViewLayout.h
//  MKBaseLibDemo
//
//  Created by windy on 15/4/3.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <CoreGraphics/CGBase.h>
#include <CoreFoundation/CFDictionary.h>

@class MKWaterflowView,MKWaterflowViewLayout;
@protocol MKWaterflowViewDelegate;

@interface MKWaterflowViewLayoutAttributes : NSObject

@property (nonatomic)CGRect frame;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGSize size;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath;

@end

typedef NS_ENUM(NSInteger, MKWaterflowViewScrollDirection) {
    MKWaterflowViewScrollDirectionVertical,
    MKWaterflowViewScrollDirectionHorizontal
};

typedef NS_ENUM(NSInteger, MKWaterflowViewAlignment) {
    MKWaterflowViewAlignmentLeft,
    MKWaterflowViewAlignmentCenter,
    MKWaterflowViewAlignmentRight,
    MKWaterflowViewAlignmentJustify
};

@protocol MKWaterflowViewDelegateLayout <MKWaterflowViewDelegate>
@optional

- (CGSize)waterflowView:(MKWaterflowView *)waterflowView layout:(MKWaterflowViewLayout*)waterflowViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)waterflowView:(MKWaterflowView *)waterflowView layout:(MKWaterflowViewLayout*)waterflowViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)waterflowView:(MKWaterflowView *)waterflowView layout:(MKWaterflowViewLayout*)waterflowViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)waterflowView:(MKWaterflowView *)waterflowView layout:(MKWaterflowViewLayout*)waterflowViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)waterflowView:(MKWaterflowView *)waterflowView layout:(MKWaterflowViewLayout*)waterflowViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (CGSize)waterflowView:(MKWaterflowView *)waterflowView layout:(MKWaterflowViewLayout*)waterflowViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end

@interface MKWaterflowViewLayout : NSObject

@property (nonatomic, weak) MKWaterflowView *waterflowView;
@property (nonatomic)CGSize waterflowViewContentSize;

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) MKWaterflowViewScrollDirection scrollDirection;
@property (nonatomic) MKWaterflowViewAlignment alignment;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;

@property (nonatomic) UIEdgeInsets sectionInset;

- (void)invalidateLayout;

- (CGSize)waterflowViewContentSize;

- (void)prepareLayout;

- (void)prepareForWaterflowViewUpdates:(NSArray *)updateItems;

- (MKWaterflowViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect;

@end

