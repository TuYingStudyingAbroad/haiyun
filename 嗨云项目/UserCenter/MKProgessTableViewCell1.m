//
//  MKProgessTableViewCell1.m
//  嗨云项目
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKProgessTableViewCell1.h"

@implementation MKProgessTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData{
    if (self.bankDetailCellObj.statusList) {
        
    }
    
        self.moneyLab.text=[NSString stringWithFormat:@"%.2f",(long)self.bankDetailCellObj.amount/100.0];
        if (self.bankDetailCellObj.number) {
            self.numLab.text=[NSString stringWithFormat:@"%@",self.bankDetailCellObj.number];
            
        }else{
            self.numLab.text=@"";
        }
    
    if (self.bankDetailCellObj.type>0) {
        if (self.bankDetailCellObj.type==1) {
            if (self.bankDetailCellObj.bankName||(long)self.bankDetailCellObj.bankOn) {
                self.lastNumLab.text=[NSString stringWithFormat:@"%@ 尾号 %@",self.bankDetailCellObj.bankName,self.bankDetailCellObj.bankOn];
                
            }
            
        }else{
            self.lastNumLab.text=@"微信钱包";
        }
    }
    
    
    
        if (self.bankDetailCellObj.statusList) {
            WXHBankStatusListObject * bankStatus =[(NSArray * )self.bankDetailCellObj.statusList lastObject];
            NSInteger lastStatue=bankStatus.status;
            
            if (lastStatue==1||lastStatue==2) {
                _statusLab.text=@"银行处理中";
            }
            
            if (lastStatue==3) {
                _statusLab.text=@"提现成功";
            }
            if (lastStatue==4||lastStatue==5) {
                _statusLab.text=@"提现失败";
            }
        }

    
    
    
}
@end
