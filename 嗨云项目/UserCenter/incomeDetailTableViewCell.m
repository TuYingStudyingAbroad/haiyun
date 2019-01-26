//
//  incomeDetailTableViewCell.m
//  嗨云项目
//
//  Created by kans on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "incomeDetailTableViewCell.h"
#import "NSString+MKExtension.h"
@implementation incomeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutCellSubviews{
    self.nameLab.text=self.WXHBalanceOBJ.text;
    self.timeLab.text=self.WXHBalanceOBJ.time;
    self.numLab.text=[NSString stringWithFormat:@"%.2f",self.WXHBalanceOBJ.amount/100.0];
    
    NSInteger statu=self.WXHBalanceOBJ.status;
    switch (self.status) {
        case 1:
            //收入的
        {
            self.statuesLab.hidden=NO;
            if (statu == 0) {
                self.statuesLab.text=@"冻结中";
                self.statuesLab.textColor=[UIColor redColor];

            }else if (statu == 1){
                //self.statuesLab.text=@"到账";
                self.statuesLab.hidden=YES;
            }else if (statu == 2){
                self.statuesLab.text=@"已取消";
            }
           
        }
            break;
        case 2:
            self.statuesLab.hidden=YES;
            break;
        case 3:
            //提现的
             self.statuesLab.hidden=NO;
            if (statu==1||statu==2) {
                self.statuesLab.text=@"处理中";
                self.statuesLab.textColor=[UIColor redColor];
            }
            
            if (statu==3) {
                //self.statuesLab.text=@"已完成";
                self.statuesLab.hidden=YES;
            }
            if (statu==4||statu==5) {
                self.statuesLab.text=@"提现失败";
                self.statuesLab.textColor=[UIColor lightGrayColor];
                
            }
//            if (statu==5) {
//                self.statuesLab.text=@"已拒绝";
//            }
           // self.statuesLab.hidden=NO;
            break;
        default:
            break;
    }
//
//    方法二：
//    self.statuesLab.text = [self cellWithStute:self.WXHBalanceOBJ.status withLabel:self.statuesLab];

}
- (NSString *)cellWithStute:(NSInteger)stute withLabel:(UILabel *)label{
    if (self.status == 1) {
        label.hidden = NO;
        if (stute == 0) {
            label.textColor=[UIColor redColor];
        }
        if (stute == 1) {
            label.hidden = YES;
        }
        if (stute == 2) {
            label.textColor=[UIColor colorWithHex:0x999999];
        }
        return @{@(0)       : @"冻结" ,
                 @(1)       : @"到账" ,
                 @(2)       : @"已取消",
                 @(3)       : @"待发货" ,
                 @(4)       : @"待发货",
                 @(5)       : @"卖家已取消"}[@(stute)];
    }
    if (self.status == 2) {
        label.hidden = YES;
        return @"";
    }
    if (self.status == 3) {
        label.hidden = NO;
        if (stute == 1||stute == 2) {
            label.textColor=[UIColor redColor];
        }
        if (stute == 3 ) {
            label.hidden = YES;
        }
        if (stute == 4 || stute == 5) {
            label.textColor=[UIColor colorWithHex:0x999999];
        }
        return @{@(0)       : @"" ,
                 @(1)       : @"处理中" ,
                 @(2)       : @"处理中",
                 @(3)       : @"已完成" ,
                 @(4)       : @"提现失败",
                 @(5)       : @"提现失败"}[@(stute)];
    }
    return @"";
}
@end
