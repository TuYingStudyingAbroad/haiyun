//
//  WXHBankCardTableViewCell.m
//  嗨云项目
//
//  Created by kans on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "WXHBankCardTableViewCell.h"

@implementation WXHBankCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setBankListOBJ:(WXHBankListObject *)bankListOBJ{
    _bankListOBJ=bankListOBJ;
}
-(void)layoutCellSubviews{
    self.bankNameLab.text=_bankListOBJ.bankName;
  
    self.lastNumLab.text=[NSString stringWithFormat:@"%@",_bankListOBJ.bankLastNO];
    
    if ([[NSString stringWithFormat:@"%@",_bankListOBJ.bankIsdefault]isEqualToString:@"0"]) {
        self.isDefaultLab.hidden=NO;
    }else{
        self.isDefaultLab.hidden=YES;
    }
    
    if ([[NSString stringWithFormat:@"%@",_bankListOBJ.bankType]isEqualToString:@"1"]) {
        self.bankStylelab.text=@"储蓄卡";
    }else{
        self.bankStylelab.text=@"信用卡";
    }
    self.bankLogoImgv.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_bankListOBJ.bankName]];
    
    
    
}

@end
