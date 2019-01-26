//
//  MKConsigneeDetailCell.h
//  嗨云项目
//
//  Created by 李景 on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKConsigneeObject;

@interface MKConsigneeDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *consigneeName;
@property (weak, nonatomic) IBOutlet UILabel *consigneePhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *consigneeAdress;
@property (weak, nonatomic) IBOutlet UILabel *consigneeIpNumber;
@property (weak, nonatomic) IBOutlet UILabel *isDefaultMarkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstant;
@property (weak, nonatomic) IBOutlet UILabel *idNoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ipNumberHeight;

- (void)loadCellWithItem:(MKConsigneeObject *) item;

@end
