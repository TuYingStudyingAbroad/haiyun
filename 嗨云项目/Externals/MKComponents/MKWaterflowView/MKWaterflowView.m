//
//  MKWaterflowView.m
//  MKBaseLibDemo
//
//  Created by windy on 15/4/3.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKWaterflowView.h"
#import "MKWaterflowViewCell.h"

@interface MKWaterflowView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)NSMutableDictionary *cellClassDic;
@property (nonatomic,strong)NSMutableDictionary *cellReuseDic;

@property (nonatomic,strong)NSMutableArray *visibleCells;
@property (nonatomic,strong)NSMutableDictionary *visibleCellsDic;

@end

@implementation MKWaterflowView{
    CGFloat _lastOffset;
    BOOL _reloadFlag;
}

- (NSMutableDictionary *)cellClassDic{
    if (!_cellClassDic) {
        _cellClassDic = [NSMutableDictionary new];
    }
    return _cellClassDic;
}
- (NSMutableDictionary *)cellReuseDic{
    if (!_cellReuseDic) {
        _cellReuseDic = [NSMutableDictionary new];
    }
    return _cellReuseDic;
}
- (NSMutableArray *)visibleCells{
    if (!_visibleCells) {
        _visibleCells = [NSMutableArray new];
    }
    return _visibleCells;
}
- (NSMutableDictionary *)visibleCellsDic{
    if (!_visibleCellsDic) {
        _visibleCellsDic = [NSMutableDictionary new];
    }
    return _visibleCellsDic;
}

- (void)setLayout:(MKWaterflowViewLayout *)layout{
    _layout = layout;
    _layout.waterflowView = self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame flowViewLayout:nil];
}

- (id)initWithFrame:(CGRect)frame flowViewLayout:(MKWaterflowViewLayout *)layout{
    if (self = [super initWithFrame:frame]) {
        self.layout = layout;
        _lastOffset = 0;
        _reloadFlag = NO;
    }
    return self;
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    NSParameterAssert(cellClass);
    NSParameterAssert(identifier);
    self.cellClassDic[identifier] = cellClass;
}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    NSParameterAssert(identifier);
    MKWaterflowViewLayoutAttributes *attributes = [self.layout layoutAttributesForItemAtIndexPath:indexPath];
    NSMutableArray *reuseCellsArray = self.cellReuseDic[identifier];
    MKWaterflowViewCell *cell = [reuseCellsArray lastObject];
    if (cell) {
        [reuseCellsArray removeLastObject];
    }
    else{
        //没有可重用的cell
        Class cellClass = self.cellClassDic[identifier];
        if (cellClass && [cellClass isSubclassOfClass:[MKWaterflowViewCell class]]) {
            if (attributes) {
                cell = [[cellClass alloc]initWithFrame:attributes.frame];
            }
            else{
                cell = [cellClass new];
            }
        }
        else{
            //无合法的class类型
            return nil;
        }
    }
    cell.reuseIdentifier = identifier;
    [cell applyLayoutAttributes:attributes];
    return cell;
}

- (void)reloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //重新对所有数据进行布局
        [self.layout invalidateLayout];
        [self.layout prepareLayout];
        self.contentSize = [self.layout waterflowViewContentSize];
        //对可见cell进行重新加载的flag
        if (!_reloadFlag && self.visibleCellsDic.count > 0) {
            _reloadFlag = YES;
        }
        [self performSelectorOnMainThread:@selector(updateVisibleCells) withObject:nil waitUntilDone:NO];
    });
}

- (void)loadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //只会对新增数据进行布局
        [self.layout prepareLayout];
        self.contentSize = [self.layout waterflowViewContentSize];
        [self performSelectorOnMainThread:@selector(updateVisibleCells) withObject:nil waitUntilDone:NO];
    });
}

- (NSInteger)numberOfSections{
    return 1;
}

- (void)deleteAllItems{
    [self.layout invalidateLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (fabs (self.bounds.origin.y-_lastOffset) < 10.0 && fabs (self.bounds.origin.y-_lastOffset) > 0) {
        return;
    }
    else{
        _lastOffset = self.bounds.origin.y;
        [self updateVisibleCells];
    }
    
}

- (void)updateVisibleCells{
    NSArray *layoutAttributesArray = [self.layout layoutAttributesForElementsInRect:self.bounds];
    //ETLog(@"%d",layoutAttributesArray.count);
    //    CGRect rect = self.bounds;
    //    ETLog(@"%f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    if (layoutAttributesArray == nil || [layoutAttributesArray count] == 0) {
        return;
    }
    NSMutableDictionary *itemKeysToAddDict = [NSMutableDictionary dictionary];
    for (MKWaterflowViewLayoutAttributes *attributes in layoutAttributesArray){
        itemKeysToAddDict[attributes.indexPath] = attributes;
        MKWaterflowViewCell *cell = self.visibleCellsDic[attributes.indexPath];
        if (cell) {
            //可见的cell
            [cell applyLayoutAttributes:attributes];
            if (_reloadFlag) {
                [cell removeFromSuperview];
                cell = [self cellForItemwithLayoutAttributes:attributes];
                if (cell) {
                    self.visibleCellsDic[attributes.indexPath] = cell;
                    [self addSubview:cell];
                }
            }
        }
        else{
            //不可见的cell
            cell = [self cellForItemwithLayoutAttributes:attributes];
            if (cell) {
                self.visibleCellsDic[attributes.indexPath] = cell;
                [self addSubview:cell];
            }
        }
    }
    _reloadFlag = NO;
    NSMutableSet *allVisibleItemKeys = [NSMutableSet setWithArray:[self.visibleCellsDic allKeys]];
    [allVisibleItemKeys minusSet:[NSSet setWithArray:[itemKeysToAddDict allKeys]]];
    for (NSIndexPath *unVisibleIndexPath in allVisibleItemKeys){
        MKWaterflowViewCell *unVisibleCell = self.visibleCellsDic[unVisibleIndexPath];
        if (unVisibleCell) {
            [self.visibleCellsDic removeObjectForKey:unVisibleIndexPath];
            [unVisibleCell removeFromSuperview];
            if (self.delegate && [self.delegate respondsToSelector:@selector(waterflowView:didEndDisplayingCell:forItemAtIndexPath:)]) {
                [self.delegate waterflowView:self didEndDisplayingCell:unVisibleCell forItemAtIndexPath:unVisibleIndexPath];
            }
            [self reuseCell:unVisibleCell];
        }
    }
}

- (MKWaterflowViewCell *)cellForItemwithLayoutAttributes:(MKWaterflowViewLayoutAttributes *)layoutAttributes {
    
    MKWaterflowViewCell *cell = [self.dataSource waterflowView:self cellForItemAtIndexPath:layoutAttributes.indexPath];
    [cell applyLayoutAttributes: layoutAttributes];
    
    if (cell.gestureRecognizers.count == 0 && cell.isUserInteractionEnabled) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTapGesture:)];
        tapGesture.delegate = self;
        [tapGesture setCancelsTouchesInView:YES];
        [cell addGestureRecognizer:tapGesture];
        //cell.userInteractionEnabled = YES;
    }
    
    cell.isAccessibilityElement = YES;
    
    return cell;
}

- (void)reuseCell:(MKWaterflowViewCell *)cell {
    NSString *cellIdentifier = cell.reuseIdentifier;
    NSParameterAssert([cellIdentifier length]);
    
    [cell removeFromSuperview];
    [cell prepareForReuse];
    
    // enqueue cell
    NSMutableArray *reuseableCells = self.cellReuseDic[cellIdentifier];
    if (!reuseableCells) {
        reuseableCells = [NSMutableArray array];
        self.cellReuseDic[cellIdentifier] = reuseableCells;
    }
    [reuseableCells addObject:cell];
}

- (void)cellTapGesture:(UITapGestureRecognizer *)sender{
    MKWaterflowViewCell *cell = (MKWaterflowViewCell *)sender.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(waterflowView:didSelectItemAtIndexPath:)] && cell.isUserInteractionEnabled) {
        [self.delegate waterflowView:self didSelectItemAtIndexPath:cell.layoutAttributes.indexPath];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO; // ignore the touch
    }
    return YES;
}

@end
