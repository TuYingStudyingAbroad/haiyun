//
//  MKWaterflowViewLayout.m
//  MKBaseLibDemo
//
//  Created by windy on 15/4/3.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKWaterflowViewLayout.h"
#import "MKWaterflowView.h"

@implementation MKWaterflowViewLayoutAttributes

+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath {
    MKWaterflowViewLayoutAttributes *attributes = [self new];
    attributes.indexPath = indexPath;
    return attributes;
}

- (void)setSize:(CGSize)size {
    _size = size;
    _frame = (CGRect){_frame.origin, _size};
}

- (void)setCenter:(CGPoint)center {
    _center = center;
    _frame = (CGRect){{_center.x - _frame.size.width / 2, _center.y - _frame.size.height / 2}, _frame.size};
}

- (void)setFrame:(CGRect)frame {
    _frame = frame;
    _size = _frame.size;
    _center = (CGPoint){CGRectGetMidX(_frame), CGRectGetMidY(_frame)};
}

@end


@interface MKWaterflowViewLayout ()

@property (nonatomic,weak)id<MKWaterflowViewDelegateLayout> layoutDelegate;
@property (nonatomic,weak)id<MKWaterflowViewDataSource> layoutDatasource;

@property (nonatomic)CGPoint layoutPoint;
@property (nonatomic)NSUInteger  numOfRow;
@property (nonatomic)CGSize currentContentSize;

@property (nonatomic,strong)NSMutableDictionary *sectionFrames;
@property (nonatomic,strong)NSMutableDictionary *layoutStacksOfSection;
@property (nonatomic,strong)NSMutableDictionary *layoutFramesOfSection;
@end


@implementation MKWaterflowViewLayout{
    CGRect _visibleRect;
}

- (id<MKWaterflowViewDelegateLayout>)layoutDelegate{
    if (!_layoutDelegate) {
        _layoutDelegate = (id<MKWaterflowViewDelegateLayout>)self.waterflowView.delegate;
    }
    return _layoutDelegate;
}

- (id<MKWaterflowViewDataSource>)layoutDatasource{
    if (!_layoutDatasource) {
        _layoutDatasource = (id<MKWaterflowViewDataSource>)self.waterflowView.dataSource;
    }
    return _layoutDatasource;
}

- (NSMutableDictionary *)sectionFrames{
    if (!_sectionFrames) {
        _sectionFrames = [NSMutableDictionary new];
    }
    return _sectionFrames;
}

- (NSMutableDictionary *)layoutStacksOfSection{
    if (!_layoutStacksOfSection) {
        _layoutStacksOfSection = [NSMutableDictionary new];
    }
    return _layoutStacksOfSection;
}

- (NSMutableDictionary *)layoutFramesOfSection{
    if (!_layoutFramesOfSection) {
        _layoutFramesOfSection = [NSMutableDictionary new];
    }
    return _layoutFramesOfSection;
}

- (id)init{
    if (self = [super init]) {
        [self initSettings];
    }
    return self;
}

- (void)initSettings{
    _minimumLineSpacing = 50.0f;
    _minimumInteritemSpacing = 20.0f;
    _itemSize = CGSizeMake(100, 100);
    _scrollDirection = MKWaterflowViewScrollDirectionVertical;
    _alignment = MKWaterflowViewAlignmentLeft;
    _headerReferenceSize = CGSizeZero;
    _footerReferenceSize = CGSizeZero;
    _sectionInset = UIEdgeInsetsZero;
    _layoutPoint = CGPointZero;
    _numOfRow = 2;
    _currentContentSize = CGSizeZero;
    _visibleRect = CGRectNull;
}

- (CGSize)waterflowViewContentSize{
    return self.currentContentSize;
}

- (void)invalidateLayout{
    self.sectionFrames = nil;
    self.layoutFramesOfSection = nil;
    self.layoutStacksOfSection = nil;
    self.currentContentSize = CGSizeZero;
}

- (void)prepareLayout{
    [self updateItemsLayout];
}

- (MKWaterflowViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *itemsFrame = self.sectionFrames[[NSString stringWithFormat:@"%d",indexPath.section]];
    CGRect itemRect = CGRectFromString(itemsFrame[indexPath.row]);
    MKWaterflowViewLayoutAttributes *attributes = [MKWaterflowViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    [attributes setFrame:itemRect];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSInteger numbersOfSections = [self.waterflowView numberOfSections];
    if (numbersOfSections <= 0) {
        return nil;
    }
    NSArray *layoutAttributesArray;
    for (int i = 0; i < numbersOfSections; i++) {
        NSMutableArray *itemsFrame = self.sectionFrames[[NSString stringWithFormat:@"%d",i]];
        layoutAttributesArray = [self enumerateItemsFrame1:[itemsFrame copy] InRect:rect InSection:i];
    }
    return layoutAttributesArray;
}

- (NSArray *)enumerateItemsFrame1:(NSArray *)itemsFrame InRect:(CGRect)rect InSection:(NSInteger)section{
    NSMutableArray *layoutAttributesArray = [NSMutableArray array];
    int stride = 20;
    if (!self.currentContentSize.height) {
        return nil;
    }
    int j = rect.origin.y/self.currentContentSize.height * itemsFrame.count;
    j = j-stride/2<0?0:j-stride/2;
    int j_stop = j+stride>itemsFrame.count?itemsFrame.count:j+stride;
    for (int i = j; i < j_stop; i++) {
        if (layoutAttributesArray.count == 6) {
            break;
        }
        CGRect itemRect = CGRectFromString(itemsFrame[i]);
        if (CGRectIntersectsRect(itemRect, rect)) {
            MKWaterflowViewLayoutAttributes *attributes = [MKWaterflowViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
            [attributes setFrame:itemRect];
            [layoutAttributesArray addObject:attributes];
        }
    }
    return [layoutAttributesArray copy];
}

- (NSArray *)enumerateItemsFrame:(NSArray *)itemsFrame InRect:(CGRect)rect InSection:(NSInteger)section{
    NSMutableArray *layoutAttributesArray = [NSMutableArray array];
    int stride = 20;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(itemsFrame.count/stride, queue, ^(size_t idx) {
        size_t j = idx *stride;
        size_t j_stop = j + stride;
        do {
            if (layoutAttributesArray.count == 6) {
                break;
            }
            CGRect itemRect = CGRectFromString(itemsFrame[j]);
            if (CGRectIntersectsRect(itemRect, rect)) {
                MKWaterflowViewLayoutAttributes *attributes = [MKWaterflowViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:j inSection:section]];
                [attributes setFrame:itemRect];
                [layoutAttributesArray addObject:attributes];
            }
            j++;
        } while (j < j_stop);
    });
    for (int j = itemsFrame.count-(itemsFrame.count%stride); j<itemsFrame.count; j++) {
        if (layoutAttributesArray.count == 6) {
            break;
        }
        CGRect itemRect = CGRectFromString(itemsFrame[j]);
        if (CGRectIntersectsRect(itemRect, rect)) {
            MKWaterflowViewLayoutAttributes *attributes = [MKWaterflowViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:j inSection:section]];
            [attributes setFrame:itemRect];
            [layoutAttributesArray addObject:attributes];
        }
    }
    return layoutAttributesArray;
}

- (void)prepareForWaterflowViewUpdates:(NSArray *)updateItems{
    NSMutableArray *itemsFrame = [[NSMutableArray alloc]initWithCapacity:updateItems.count];
    CGSize contentSize = self.currentContentSize;
    for (NSIndexPath *indexPath in updateItems){
        CGRect itemFrame = CGRectZero;
        //获取对应item的size
        CGSize itemSize = [self itemSizeAtIndexPath:indexPath];
        //获取对应section的inset
        UIEdgeInsets insetOfSection = [self insetForSectionAtIndex:indexPath.section];
        
        CGFloat lowHeight = CGFLOAT_MAX;
        NSInteger col = 0;
        for (int i = 0;i<self.numOfRow;i++){
            CGFloat topHeight;
            NSString *topString = self.layoutStacksOfSection[[NSString stringWithFormat:@"%d",i]];
            if (topString) {
                CGSize size = CGSizeFromString(topString);
                topHeight = size.height;
            }
            else{
                topHeight = 0;
            }
            
            if (topHeight < lowHeight){
                lowHeight = topHeight;
                col = i;
            }
        }
        //ETLog(@"lowHeight = %f col = %d",lowHeight,col);
        CGFloat oringX;
        CGFloat oringY;
        oringX = insetOfSection.left + [self minimumInteritemSpacingForSectionAtIndex:indexPath.section]*col;
        for (int j = 0; j < col; j++) {
            CGSize size = CGSizeFromString(self.layoutStacksOfSection[[NSString stringWithFormat:@"%d",j]]);
            oringX += size.width;
        }
        if (lowHeight == 0) {
            oringY = insetOfSection.top;
        }
        else{
            oringY = lowHeight + [self minimumLineSpacingForSectionAtIndex:indexPath.section];
        }
        
        itemFrame = CGRectMake(oringX, oringY, itemSize.width, itemSize.height);
        
        //update the layout stack
        self.layoutStacksOfSection[[NSString stringWithFormat:@"%d",col]] = NSStringFromCGSize(CGSizeMake(itemSize.width, oringY+itemSize.height));
        //build the map from indexPath to frame
        self.layoutFramesOfSection[[NSString stringWithFormat:@"%d",indexPath.row]] = NSStringFromCGRect(itemFrame);
        
        [itemsFrame addObject:NSStringFromCGRect(itemFrame)];
        
        contentSize.width = fmaxf(contentSize.width, oringX+itemSize.width+insetOfSection.right);
        contentSize.height = fmaxf(contentSize.height, oringY+itemSize.height+insetOfSection.bottom);
    }
    self.currentContentSize = contentSize;
    NSMutableArray *framesArray = self.sectionFrames[[NSString stringWithFormat:@"%d",0]];
    if (framesArray) {
        [framesArray addObjectsFromArray:itemsFrame];
    }
    else{
        framesArray = itemsFrame;
    }
    self.sectionFrames[[NSString stringWithFormat:@"%d",0]] = framesArray;
}

- (void)updateItemsLayout{
    NSInteger numbersOfSections = [self.waterflowView numberOfSections];
    if (numbersOfSections <= 0) {
        return;
    }
    //self.currentContentSize = CGSizeZero;
    for (int i = 0; i < numbersOfSections; i++) {
        if ([self.layoutDatasource respondsToSelector:@selector(waterflowView:numberOfItemsInSection:)]) {
            //每个section的item个数
            NSInteger numbersOfItems = [self.layoutDatasource waterflowView:self.waterflowView numberOfItemsInSection:i];
            //[self layoutItems:numbersOfItems InSection:i];
            NSInteger layoutedItemsCount = [self.sectionFrames[[NSString stringWithFormat:@"%d",i]]count];
            NSInteger updateItemsCount = numbersOfItems - layoutedItemsCount;
            if (updateItemsCount == 0) {
                return;
            }
            NSMutableArray *updateItems = [NSMutableArray arrayWithCapacity:updateItemsCount];
            for (int j = layoutedItemsCount; j<numbersOfItems; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [updateItems addObject:indexPath];
            }
            [self prepareForWaterflowViewUpdates:updateItems];
        }
    }
}

- (void)layoutItems:(NSInteger)numberOfItems InSection:(NSInteger)section{
    NSMutableArray *itemsFrame = [[NSMutableArray alloc]initWithCapacity:numberOfItems];
    CGSize contentSize = self.currentContentSize;
    for (int i = 0; i < numberOfItems; i++) {
        NSInteger row = i/self.numOfRow;
        NSInteger col = i%self.numOfRow;
        CGRect itemFrame;
        //对应item的indexpath
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:section];
        //获取对应item的size
        CGSize itemSize = [self itemSizeAtIndexPath:indexpath];
        
        UIEdgeInsets insetOfSection = [self insetForSectionAtIndex:section];
        
        CGFloat oringX;
        CGFloat oringY;
        
        oringX = insetOfSection.left + [self minimumInteritemSpacingForSectionAtIndex:i]*col;
        for (int j = 0; j < col; j++) {
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:i-1*(j+1) inSection:section];
            CGSize lastItemSize = [self itemSizeAtIndexPath:lastIndexPath];
            oringX += lastItemSize.width;
        }
        
        oringY = insetOfSection.top + [self minimumLineSpacingForSectionAtIndex:i]*row;
        for (int j = 0; j < row; j++) {
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:i-self.numOfRow*(j+1) inSection:section];
            CGSize lastItemSize = [self itemSizeAtIndexPath:lastIndexPath];
            oringY += lastItemSize.height;
        }
        
        itemFrame = CGRectMake(oringX, oringY, itemSize.width, itemSize.height);
        
        //[itemsFrame addObject:NSStringFromCGRect(itemFrame)];
        [itemsFrame insertObject:NSStringFromCGRect(itemFrame) atIndex:i];
        
        contentSize.width = fmaxf(contentSize.width, oringX+itemSize.width+insetOfSection.right);
        contentSize.height = fmaxf(contentSize.height, oringY+itemSize.height+insetOfSection.bottom);
    }
    self.currentContentSize = contentSize;
    [self.sectionFrames setObject:itemsFrame forKey:[NSString stringWithFormat:@"%d",section]];
}

#pragma mark ----
#pragma mark private methods
- (CGSize)itemSizeAtIndexPath:(NSIndexPath *)indexPath{
    CGSize itemSize;
    if ([self.layoutDelegate respondsToSelector:@selector(waterflowView:layout:sizeForItemAtIndexPath:)]) {
        itemSize = [self.layoutDelegate waterflowView:self.waterflowView layout:self sizeForItemAtIndexPath:indexPath];
    }
    else{
        itemSize = self.itemSize;
    }
    return itemSize;
}
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insetOfSection = UIEdgeInsetsZero;
    if ([self.layoutDelegate respondsToSelector:@selector(waterflowView:layout:insetForSectionAtIndex:)]) {
        insetOfSection = [self.layoutDelegate waterflowView:self.waterflowView layout:self insetForSectionAtIndex:section];
    }
    return insetOfSection;
}
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    if ([self.layoutDelegate respondsToSelector:@selector(waterflowView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        minimumInteritemSpacing = [self.layoutDelegate waterflowView:self.waterflowView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return minimumInteritemSpacing;
}
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat minimumLineSpacing = self.minimumLineSpacing;
    if ([self.layoutDelegate respondsToSelector:@selector(waterflowView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        minimumLineSpacing = [self.layoutDelegate waterflowView:self.waterflowView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return minimumLineSpacing;
}
- (CGSize)sizeForHeaderInSection:(NSInteger)section{
    CGSize headerSize = self.headerReferenceSize;
    if ([self.layoutDelegate respondsToSelector:@selector(waterflowView:layout:referenceSizeForHeaderInSection:)]) {
        headerSize = [self.layoutDelegate waterflowView:self.waterflowView layout:self referenceSizeForHeaderInSection:section];
    }
    return headerSize;
}
- (CGSize)sizeForFooterInSection:(NSInteger)section{
    CGSize footerSize = self.footerReferenceSize;
    if ([self.layoutDelegate respondsToSelector:@selector(waterflowView:layout:referenceSizeForFooterInSection:)]) {
        footerSize = [self.layoutDelegate waterflowView:self.waterflowView layout:self referenceSizeForFooterInSection:section];
    }
    return footerSize;
}
@end