//
//  MKSimpleItemTableViewCell.m
//  YangDongXi
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKSimpleItemTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "MKBaseItemObject.h"
#import <PureLayout.h>


@interface MKSimpleItemTableViewCell ()

@property (nonatomic,strong)UIImageView *backimageView;
@property (nonatomic,strong)UILabel     *activityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skuConstaint;

@end


@implementation MKSimpleItemTableViewCell

- (UIImageView *)backimageView
{
    if (!_backimageView) {
        self.backimageView = [[UIImageView alloc]init];
        _backimageView.image = [UIImage imageNamed:@"kuajingbiaoqian"];
    }
    return _backimageView;
}

-(UILabel *)activityLabel
{
    if ( _activityLabel == nil )
    {
        self.activityLabel = [[UILabel alloc] init];
        self.activityLabel.textColor = [UIColor whiteColor];
        self.activityLabel.backgroundColor = kHEXCOLOR(kRedColor);
        self.activityLabel.font = [UIFont systemFontOfSize:10.0f];
        self.activityLabel.layer.cornerRadius = 3.0f;
        self.activityLabel.layer.masksToBounds = YES;
        self.activityLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _activityLabel;
}
- (void)cellWithModel:(MKOrderItemObject *)model orderObject:(MKOrderObject *)orders
{
    self.refundBut.hidden = YES;
    self.refundLabel.hidden = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString: model.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder_57*57"]];
    self.titleLabel.text = model.itemName;
    self.priceLabel.text = [MKBaseItemObject priceString: model.price ];
    [self.priceLabel HYPriceChangeFont:9.0f colors:kHEXCOLOR(0x222222) isTop:NO];
    self.numberLabel.text = [NSString stringWithFormat:@"x%ld",model.number ];
    self.attributesLabel.text = model.skuSnapshot;
    if (model.higoMark)
    {
        [self addSubview: self.backimageView];
        [self.backimageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.backimageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:17];
        [self.backimageView autoSetDimension:(ALDimensionHeight) toSize:15];
        [self.backimageView autoSetDimension:(ALDimensionWidth) toSize:30];
    }else{
        if (self.backimageView)
        {
            [self.backimageView removeFromSuperview];
            self.backimageView = nil;
        }
    }
    
    
    NSString *activityTags = @"";
//    NSLog(@"orders.discountInfo == %@",orders.discountInfo);
    for ( MKOrderDiscountObject *item in orders.discountInfo )
    {
        if ( [item.discountCode isEqualToString:@"ReachMultipleReduceTool"]
            && [item.itemSkuId isEqual:model.itemSkuId] )
        {
            activityTags = @"活动";
        }
        else if (  [item.discountCode isEqualToString:@"TimeRangeDiscount"]
                 && [item.itemSkuId isEqual:model.itemSkuId])
        {
            activityTags = @"限时购";
        }
    }
    if ( !ISNSStringValid(activityTags) )
    {
        activityTags = [self textactivityLabel:model.itemTypeOne];

    }
    
    CGFloat height = GetHeightOfString(model.itemName,Main_Screen_Width-150.0f,[UIFont systemFontOfSize:12.0f]);
    if ( ISNSStringValid(activityTags) )
    {
        if (self.activityLabel)
        {
            [self.activityLabel removeFromSuperview];
            self.activityLabel = nil;
        }
        self.skuConstaint.constant = height<18.0f?0.0f:6.0f;
        CGFloat widths = GetWidthOfString(activityTags,16.0f,[UIFont systemFontOfSize:10.0f])+6.0f;
        [self addSubview:self.activityLabel];
        self.activityLabel.text = activityTags;
        [self.activityLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.iconImageView withOffset:0.0f];
        [self.activityLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:10.0f];
        [self.activityLabel autoSetDimension:(ALDimensionHeight) toSize:16.0f];
        [self.activityLabel autoSetDimension:(ALDimensionWidth) toSize:widths];
    }else
    {
         self.skuConstaint.constant = 29.0f;
        if (self.activityLabel)
        {
            [self.activityLabel removeFromSuperview];
            self.activityLabel = nil;
        }
    }
    
}

-(NSString *)textactivityLabel:(NSInteger)types
{
    NSString   *activitys = @"";
    switch (types)
    {
        case 14:
        {
            activitys = @"团购";
        }
            break;
        case 13:
        {
            activitys = @"秒杀";
        }
            break;
        default:
            break;
    }
    return activitys;
}

+ (CGFloat)cellHeight
{
    return 105;
}

@end
