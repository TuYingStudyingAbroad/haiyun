//
//  MKConsigneeSimpleOperationCell.h
//  嗨云项目
//
//  Created by 李景 on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKConsigneeSimpleOperationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *setDefaultButton;
@property (weak, nonatomic) IBOutlet UIButton *isDefault;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConstant;


@end
