//
//  MKDetailAdditionalInfoView.m
//  YangDongXi
//
//  Created by cocoa on 15/5/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDetailAdditionalInfoView.h"
#import "MKDetailInfView.h"
#import <PureLayout.h>


@interface MKDetailAdditionalInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation MKDetailAdditionalInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)updateItemPropertiesViewWithArray:(NSArray *)properties
{
    UIView *layoutLeftView = nil;

    for (MKItemPropertyObject *propertys in properties)
    {
        MKDetailInfView *detailInfView = [MKDetailInfView loadFromXib];
        detailInfView.nameLabel.text = propertys.name;
        detailInfView.contentLabel.text = propertys.value;
        [self addSubview:detailInfView];
        [detailInfView sizeToFit];
        [self layoutIfNeeded];
        
        [detailInfView autoSetDimension:ALDimensionHeight toSize:32];
        [detailInfView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [detailInfView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        if ( layoutLeftView ==  nil )
        {
            [detailInfView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        }else
        {
            [detailInfView autoPinEdge:ALEdgeTop  toEdge:ALEdgeBottom ofView:layoutLeftView withOffset:0];
        }

        layoutLeftView = detailInfView;
    }
}



@end
