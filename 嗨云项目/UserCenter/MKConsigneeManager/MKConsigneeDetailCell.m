//
//  MKConsigneeDetailCell.m
//  嗨云项目
//
//  Created by 李景 on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKConsigneeDetailCell.h"
#import "MKConsigneeObject.h"
#import "MKRegionModel.h"

@implementation MKConsigneeDetailCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)loadCellWithItem:(MKConsigneeObject *)item {
    self.consigneeName.text = item.consignee;
    
    [MKRegionModel firstAddressWithCode1:item.provinceCode
                                cityCode:item.cityCode
                                areaCode:item.areaCode
                              completion:^(NSString *address)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            self.consigneeAdress.text = [NSString stringWithFormat:@"%@ %@",address,item.address];
        });
    }];
    self.consigneePhoneNumber.text = item.mobile;
    self.consigneeIpNumber.text = item.idNo;
    
    if (!item.idNo || [item.idNo isEqualToString:@""]) {
        self.ipNumberHeight.constant = 0;
        self.idNoLabel.hidden = YES;
    }else {
        self.ipNumberHeight.constant = 17;
        self.idNoLabel.hidden = NO;
    }
    
    if (!item.isDefault) {
        self.isDefaultMarkLabel.hidden = YES;
        self.leftConstant.constant = -50;
    }else {
        self.isDefaultMarkLabel.hidden = NO;
        self.leftConstant.constant = 0;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
