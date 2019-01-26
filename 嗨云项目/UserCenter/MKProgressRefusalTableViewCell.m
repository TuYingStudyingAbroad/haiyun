//
//  MKProgressRefusalTableViewCell.m
//  嗨云项目
//
//  Created by 小辉 on 16/6/14.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKProgressRefusalTableViewCell.h"

@implementation MKProgressRefusalTableViewCell
-(void)setWXHBankStatusOBJ:(WXHBankStatusListObject *)WXHBankStatusOBJ{
    _WXHBankStatusOBJ=WXHBankStatusOBJ;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)getDataWithIndex:(NSIndexPath *)index{
    //  UILabel * statusLab=(UILabel *)[self.contentView viewWithTag:4];
    // UILabel * timeLab=(UILabel *)[self.contentView viewWithTag:5];
    //原因lab暂时隐藏
    
    if ( self.bankDetailCellOBJ.statusList) {
        if (index.row==0) {
            
            UIImageView * imagV=(UIImageView *)[self.contentView viewWithTag:3];
            imagV.highlighted=YES;
            UILabel * textLab=(UILabel *)[self.contentView viewWithTag:4];
            textLab.textColor=[UIColor colorWithRed:112/255.0 green:172/255.0 blue:41/255.0 alpha:1.0];
            
        }
        
        
        self.reasonLab.text=self.bankDetailCellOBJ.refusalReason;
        NSArray * arr= self.bankDetailCellOBJ.statusList;
        WXHBankStatusListObject * lastStatuesOBJ=(WXHBankStatusListObject*)[arr lastObject];
        NSInteger lastStatue=lastStatuesOBJ.status;
        NSString * timeStr=lastStatuesOBJ.time;
        if (lastStatue==1||lastStatue==2) {
            self.statuLab.text=@"银行处理中";
            self.timeLab.hidden=YES;
            
        }
        
        if (lastStatue==3) {
            self.statuLab.text=@"提现成功";
            self.timeLab.hidden=NO;
            self.timeLab.text=timeStr;
            
        }
        if (lastStatue==4||lastStatue==5) {
            self.progressImgV.highlighted=NO;
            self.statuLab.text=@"提现失败";
            self.statuLab.textColor=[UIColor redColor];
            self.progressImgV.image=[UIImage imageNamed:@"tixianshibai.png"];
            self.timeLab.hidden=NO;
            self.timeLab.text=timeStr;
            
        }
    }
    
}



@end
