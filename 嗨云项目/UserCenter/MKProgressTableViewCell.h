//
//  MKProgressTableViewCell.h
//  嗨云项目
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHBankStatusListObject.h"
#import "WXHBankDetailCellObject.h"
@interface MKProgressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statuLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *progressImgV;

@property (nonatomic,strong)WXHBankStatusListObject* WXHBankStatusOBJ;

@property (nonatomic,strong)WXHBankDetailCellObject * bankDetailCellOBJ;

-(void)getDataWithIndex:(NSIndexPath *)index;
@end
