//
//  WXHBankCardTableViewCell.h
//  嗨云项目
//
//  Created by kans on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHBankListObject.h"
@interface WXHBankCardTableViewCell : UITableViewCell
//银行卡logo
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImgv;
//银行卡名
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
//信用卡还是储蓄卡
@property (weak, nonatomic) IBOutlet UILabel *bankStylelab;
//是否是默认卡
@property (weak, nonatomic) IBOutlet UILabel *isDefaultLab;
//银行卡尾号
@property (weak, nonatomic) IBOutlet UILabel *lastNumLab;
@property (nonatomic,strong)WXHBankListObject*bankListOBJ;
-(void)layoutCellSubviews;
@end
