//
//  MKConsigneeCell.m
//  YangDongXi
//
//  Created by windy on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKConsigneeCell.h"
#import "MKRegionModel.h"

@interface MKConsigneeObject()

@end

@implementation MKConsigneeCell

+ (id)loadFromNib
{
    
    NSString *xibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
}

+ (NSString*)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

- (void)setConsignee:(MKConsigneeObject *)consigneeItem
{
    _consigneeItem = consigneeItem;
}

- (void)layoutCellSubviews
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",self.consigneeItem.consignee];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",self.consigneeItem.mobile];
    
    [MKRegionModel firstAddressWithCode1:self.consigneeItem.provinceCode
                                cityCode:self.consigneeItem.cityCode
                                areaCode:self.consigneeItem.areaCode
                              completion:^(NSString *address)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            self.firstAdressLabel.text = [NSString stringWithFormat:@"%@ %@",address,self.consigneeItem.address];
        });
    }];
    
    if (self.consigneeItem.idNo.length) {
        self.idNo.hidden = NO;
        NSMutableString *idNoString = [NSMutableString stringWithFormat:@"%@",self.consigneeItem.idNo];
        NSString *str = [NSString stringWithFormat:@"%@****************%@",[idNoString substringToIndex:1],[idNoString substringFromIndex:idNoString.length-1]];
        self.idNo.text = str;
    }else{
        self.idNo.hidden = YES;
    }
}

+ (CGFloat)cellHeight
{
    return 90;
}

@end
