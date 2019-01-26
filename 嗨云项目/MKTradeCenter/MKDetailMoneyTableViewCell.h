//
//  MKDetailMoneyTableViewCell.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKDetailMoneyTableViewCell : UITableViewCell
//具体值
@property (weak, nonatomic) IBOutlet UILabel *valueText;
//肩章的显示
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgeWidthCount;
//¥符号
@property (weak, nonatomic) IBOutlet UILabel *symbol;
//-号
@property (weak, nonatomic) IBOutlet UILabel *minus;
//类型
@property (weak, nonatomic) IBOutlet UILabel *showName;
@end
