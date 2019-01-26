//
//  MKProgressRefusalTableViewCell.h
//  嗨云项目
//
//  Created by 小辉 on 16/6/14.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHBankDetailCellObject.h"
#import "WXHBankStatusListObject.h"
@interface MKProgressRefusalTableViewCell : UITableViewCell

@property (nonatomic,strong)WXHBankDetailCellObject * bankDetailCellOBJ;
@property (nonatomic,strong)WXHBankStatusListObject* WXHBankStatusOBJ;
@property (weak, nonatomic) IBOutlet UILabel *statuLab;
@property (weak, nonatomic) IBOutlet UILabel *reasonLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middle;
@property (weak, nonatomic) IBOutlet UIImageView *progressImgV;
-(void)getDataWithIndex:(NSIndexPath *)index;

@end
