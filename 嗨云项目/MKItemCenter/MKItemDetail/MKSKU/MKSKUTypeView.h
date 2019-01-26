//
//  MKSKUTypeView.h
//  YangDongXi
//
//  Created by cocoa on 14/12/5.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "UIView+MKExtension.h"


@class MKSKUTypeView;

@protocol MKSKUTypeViewDelegate <NSObject>

- (void)skuTypeView:(MKSKUTypeView *)skuTypeView changeFromIndex:(NSInteger)from toIndex:(NSInteger)to;

@end


@interface MKSKUTypeView : UIView

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSArray *propertyButtons;
@property (nonatomic,assign)CGFloat abc ;

@property (nonatomic, weak) id<MKSKUTypeViewDelegate> delegate;

- (void)buildItemsWithProperties:(NSArray *)props;

- (void)setButton:(NSInteger)index enable:(BOOL)enable;

- (NSInteger)getSelectedIndex;

- (void)selectIndex:(NSInteger)index;

- (void)attributeButtonClick:(UIButton *)button;

- (void)buildItemsProperties:(NSArray *)props;

@end
