//
//  MKProgessTableViewCell1.h
//  嗨云项目
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHBankDetailCellObject.h"
#import "WXHBankStatusListObject.h"
@interface MKProgessTableViewCell1 : UITableViewCell

@property(nonatomic,strong)WXHBankDetailCellObject*bankDetailCellObj ;

//提现状态
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
//提现金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
//提现编号
@property (weak, nonatomic) IBOutlet UILabel *numLab;
//银行卡类型
@property (weak, nonatomic) IBOutlet UILabel *bankStyleLab;
//银行卡尾号
@property (weak, nonatomic) IBOutlet UILabel *lastNumLab;
-(void)setData;
@end
