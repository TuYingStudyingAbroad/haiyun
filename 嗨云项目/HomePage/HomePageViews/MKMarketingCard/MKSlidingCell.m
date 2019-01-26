//
//  MKSlidingCell.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/17.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKSlidingCell.h"
#import <PureLayout.h>
#import <UIImageView+WebCache.h>
#import "MKMarketingListItem.h"
#import "MKItemObject.h"
#import "MKStrikethroughLabel.h"



@interface MKSlidingCell ()

@property (nonatomic,strong)UIScrollView *scrollview;

@property (nonatomic,strong)NSLayoutConstraint *layout;

@end

@implementation MKSlidingCell

- (UIScrollView *)scrollview{
    if (!_scrollview) {
        self.scrollview = [[UIScrollView alloc]init];
        _scrollview.contentSize =CGSizeMake([self.entryObject.values[0] productList].count * [UIScreen mainScreen].bounds.size.width/3, 0);
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator= NO;
//        _scrollview.backgroundColor = [UIColor redColor];
    }
    return _scrollview;
}

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object{
    [super updateWithEntryObject:object];
    NSArray *arr =[object.values[0] productList];
    [self addSubview:self.scrollview];
    [self.scrollview autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsetsZero)];
    UIButton *bu = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.scrollview addSubview:bu];
    [bu autoSetDimension:(ALDimensionWidth) toSize:0];
    [bu autoSetDimension:(ALDimensionHeight) toSize:100 - 20];
    [bu autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.layout = [bu autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.scrollview withOffset:0];
    [bu addTarget:self action:@selector(handleClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    bu.adjustsImageWhenHighlighted = NO;
    bu.tag = 0;
    for (int j = 0 ; j <arr.count;j ++) {
        UIView *v = self.layout.firstItem;
        UIImageView *but = [[UIImageView alloc]init];
        [self.scrollview addSubview:but];
        [but autoSetDimension:(ALDimensionWidth) toSize:[UIScreen mainScreen].bounds.size.width/3 - 10];
        [but autoSetDimension:(ALDimensionHeight) toSize:100];
        [but autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
//        [but autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        self.layout = [but autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:v withOffset:8];
//        [but addTarget:self action:@selector(handleClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [but sd_setImageWithURL:[NSURL URLWithString:[arr[j] imageUrl]] placeholderImage:[UIImage imageNamed:@""]];
        but.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.text = [arr[j] text];
        [self.scrollview addSubview:label];
        [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:but];
        [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:but withOffset:4];
        [label autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:but];
        UILabel *label2 = [[UILabel alloc]init];
        label2.font = [UIFont systemFontOfSize:12];
        label2.text =[NSString stringWithFormat:@"¥%@",[MKItemObject priceString:[arr[j] wirelessPrice]]];
        [self.scrollview addSubview:label2];
        label2.textColor = [UIColor colorWithHex:0xf84e37];
        [label2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:label];
        [label2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:4];
        [label2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:label];
        UILabel *label3 = [[UILabel alloc]init];
        label3.font = [UIFont systemFontOfSize:10];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[MKItemObject priceString:[arr[j] marketPrice]]]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@1
                                range:NSMakeRange(0, [attributeString length])];
        label3.attributedText = attributeString;
        [self.scrollview addSubview:label3];
        label3.textColor = [UIColor colorWithHex:0x999999];
        [label3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:label2];
        [label3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label2 withOffset:4];
        [label3 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:label2];
        
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.scrollview addSubview:button];
        button.backgroundColor = [UIColor clearColor];
        [button autoSetDimension:(ALDimensionWidth) toSize:[UIScreen mainScreen].bounds.size.width/3 - 10];
        [button autoSetDimension:(ALDimensionHeight) toSize:167];
        [button autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
//        [button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:v withOffset:8];
        [button addTarget:self action:@selector(handleClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag = j+1;
    }
    
}
- (void)handleClickAction:(UIButton *)sender{
    NSArray *arr =[self.entryObject.values[0] productList];
    MKMarketingListItem *object = arr[sender.tag - 1];
    [self.delegate marketingCell:self didClickWithUrl:object.targetUrl];
}
+ (CGFloat)cellHeight{
    return 167;
}


@end
